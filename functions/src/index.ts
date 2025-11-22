/**
 * Cloud Functions para CICATRIZA - Esqueleto M0
 * 
 * Funcionalidades implementadas:
 * - onUserCreate: Auditoria e inicialização de perfil
 * - onStorageFinalize: Gerar thumbnails para imagens
 * - Funções auxiliares para M1+
 */

import {randomUUID} from "crypto";
import {setGlobalOptions} from "firebase-functions";
import {onRequest} from "firebase-functions/v2/https";
import {onObjectFinalized} from "firebase-functions/v2/storage";
import {beforeUserCreated} from "firebase-functions/v2/identity";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import sharp from "sharp";

// Inicializar Admin SDK
admin.initializeApp();

// Configurações globais
setGlobalOptions({ maxInstances: 10 });

const THUMBNAIL_MAX_DIMENSION = 640;
const THUMBNAIL_QUALITY = 75;
const THUMBNAIL_CONTENT_TYPE = "image/jpeg";
const THUMBNAIL_GENERATOR_TAG = "cicatriza-thumbnail";
const MEDIA_COLLECTION_GROUP = "media";
const MEDIA_PATH_REGEX = /^users\/([^/]+)\/patients\/([^/]+)\/wounds\/([^/]+)\/assessments\/([^/]+)\/(photos|media)\/([^/]+)$/i;

interface ParsedMediaPath {
  userId: string;
  patientId: string;
  woundId: string;
  assessmentId: string;
  fileName: string;
  mediaId: string | null;
}

interface MediaDocumentUpdates {
  thumbUrl?: string;
  thumbStoragePath?: string;
  width?: number | null;
  height?: number | null;
  fileSize?: number | null;
  mimeType?: string;
}

/**
 * Trigger quando um novo usuário é criado via Firebase Auth
 * - Log de auditoria
 * - Opcional: inicialização adicional de perfil
 */
export const onUserCreate = beforeUserCreated(async (event) => {
  try {
    const user = event.data;
    
    if (!user || !user.uid) {
      logger.warn("Dados de usuário inválidos", { user });
      return;
    }
    
    logger.info("Novo usuário criado", {
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      timestamp: new Date().toISOString(),
    });

    // Opcional: criar documento inicial em users/{uid} se não existir
    // (normalmente feito pelo app no primeiro login)
    const userDocRef = admin.firestore().doc(`users/${user.uid}`);
    const userDoc = await userDocRef.get();
    
    if (!userDoc.exists) {
      logger.info("Criando documento inicial do usuário", { uid: user.uid });
      
      await userDocRef.set({
        uid: user.uid,
        email: user.email || "",
        displayName: user.displayName || null,
        photoURL: user.photoURL || null,
        crmCofen: null,
        specialty: "Estomaterapia",
        timezone: "America/Sao_Paulo",
        ownerId: user.uid,
        acl: {
          roles: {
            [user.uid]: "owner"
          }
        },
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    return;
  } catch (error) {
    logger.error("Erro ao processar criação de usuário", {
      uid: event.data?.uid,
      error: error instanceof Error ? error.message : String(error),
    });
    // Não falhar o processo de criação do usuário
    return;
  }
});

/**
 * Trigger quando um arquivo é enviado para Storage
 * - Gerar thumbnails para imagens
 * - Atualizar contadores de mídia
 */
export const onStorageFinalize = onObjectFinalized(async (event) => {
  try {
    const object = event.data;
    const {name, contentType, bucket: bucketName, metadata, size} = object;

    if (!name || !contentType || !bucketName) {
      logger.warn("Objeto sem atributos obrigatórios", {name, contentType, bucketName});
      return;
    }

    logger.info("Arquivo enviado para Storage", {
      name,
      contentType,
      size,
      bucketName,
    });

    if (!contentType.startsWith("image/")) {
      logger.info("Ignorando arquivo não imagem", {name, contentType});
      return;
    }

    if (metadata?.generatedBy === THUMBNAIL_GENERATOR_TAG || isThumbnailPath(name)) {
      logger.info("Ignorando thumbnail já processado", {name});
      return;
    }

    const mediaPath = parseMediaPath(name);
    if (!mediaPath) {
      logger.info("Imagem fora do escopo de assessments", {name});
      return;
    }

    const thumbnailResult = await createThumbnail({
      bucketName,
      filePath: name,
      contentType,
    });

    if (thumbnailResult) {
      const {thumbPath, thumbUrl, width, height} = thumbnailResult;
      const fileSize = parseSize(size);

      await updateMediaDocuments({
        ...mediaPath,
        storagePath: name,
        updates: {
          thumbUrl,
          thumbStoragePath: thumbPath,
          width,
          height,
          fileSize,
          mimeType: contentType,
        },
      });
    }

    await updateAttachmentsCount(name);

    return;
  } catch (error) {
    logger.error("Erro ao processar arquivo Storage", {
      name: event.data?.name,
      error: error instanceof Error ? error.message : String(error),
    });
    return;
  }
});

/**
 * Função auxiliar: atualizar attachmentsCount no assessment
 */
async function updateAttachmentsCount(storagePath: string): Promise<void> {
  try {
    // Espera caminhos do tipo:
    // users/{uid}/patients/{pid}/wounds/{wid}/assessments/{aid}/photos/{file}
    // ou .../media/{file}
    const pathParts = storagePath.split("/");
    
    if (
      pathParts.length < 10 ||
      pathParts[0] !== "users" ||
      pathParts[2] !== "patients" ||
      pathParts[4] !== "wounds" ||
      pathParts[6] !== "assessments" ||
      (pathParts[8] !== "photos" && pathParts[8] !== "media")
    ) {
      logger.warn("Path de mídia não reconhecido", { storagePath });
      return;
    }

    const [, userId, , patientId, , woundId, , assessmentId] = pathParts;

    const assessmentMediaPath = `users/${userId}/patients/${patientId}/wounds/${woundId}/assessments/${assessmentId}/media`;

    // Contar arquivos na subcoleção media do assessment
    const mediaCollection = admin.firestore().collection(assessmentMediaPath);
    
    const mediaSnapshot = await mediaCollection.get();
    const attachmentsCount = mediaSnapshot.size;

    // Atualizar o documento do assessment
    const assessmentRef = admin
      .firestore()
      .doc(`users/${userId}/patients/${patientId}/wounds/${woundId}/assessments/${assessmentId}`);

    await assessmentRef.update({
      attachmentsCount,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info("Contador de anexos atualizado", {
      userId,
      patientId,
      woundId,
      assessmentId,
      attachmentsCount,
    });

  } catch (error) {
    logger.error("Erro ao atualizar contador de anexos", {
      storagePath,
      error: error instanceof Error ? error.message : String(error),
    });
  }
}

function isThumbnailPath(storagePath: string): boolean {
  return /_thumb(?:\.[^/]+)?$/i.test(storagePath);
}

function parseMediaPath(storagePath: string): ParsedMediaPath | null {
  const match = MEDIA_PATH_REGEX.exec(storagePath);
  if (!match) {
    return null;
  }

  const [, userId, patientId, woundId, assessmentId, , fileName] = match;

  return {
    userId,
    patientId,
    woundId,
    assessmentId,
    fileName,
    mediaId: extractMediaId(fileName),
  };
}

async function createThumbnail(params: {
  bucketName: string;
  filePath: string;
  contentType: string;
}): Promise<{thumbPath: string; thumbUrl: string; width: number | null; height: number | null;} | null> {
  const {bucketName, filePath, contentType} = params;

  try {
    const bucket = admin.storage().bucket(bucketName);
    const file = bucket.file(filePath);
    const [originalBuffer] = await file.download();

    const image = sharp(originalBuffer, {failOnError: false});
    const metadata = await image.metadata();

    const resizedBuffer = await image
      .clone()
      .rotate()
      .resize({
        width: THUMBNAIL_MAX_DIMENSION,
        height: THUMBNAIL_MAX_DIMENSION,
        fit: "inside",
        withoutEnlargement: true,
      })
      .jpeg({quality: THUMBNAIL_QUALITY})
      .toBuffer();

    const thumbPath = buildThumbnailPath(filePath);
    const downloadToken = randomUUID();
    const thumbFile = bucket.file(thumbPath);

    await thumbFile.save(resizedBuffer, {
      resumable: false,
      metadata: {
        contentType: THUMBNAIL_CONTENT_TYPE,
        cacheControl: "public,max-age=86400",
        metadata: {
          firebaseStorageDownloadTokens: downloadToken,
          generatedBy: THUMBNAIL_GENERATOR_TAG,
          originalPath: filePath,
          sourceContentType: contentType,
        },
      },
    });

    const thumbUrl = buildDownloadUrl(bucketName, thumbPath, downloadToken);

    return {
      thumbPath,
      thumbUrl,
      width: metadata.width ?? null,
      height: metadata.height ?? null,
    };
  } catch (error) {
    logger.error("Falha ao gerar thumbnail", {
      filePath,
      error: error instanceof Error ? error.message : String(error),
    });
    return null;
  }
}

function buildThumbnailPath(originalPath: string): string {
  const dotIndex = originalPath.lastIndexOf(".");
  if (dotIndex === -1) {
    return `${originalPath}_thumb.jpg`;
  }
  const base = originalPath.substring(0, dotIndex);
  return `${base}_thumb.jpg`;
}

function buildDownloadUrl(bucketName: string, filePath: string, token: string): string {
  const encodedPath = encodeURIComponent(filePath);
  return `https://firebasestorage.googleapis.com/v0/b/${bucketName}/o/${encodedPath}?alt=media&token=${token}`;
}

function parseSize(size: unknown): number | null {
  if (typeof size === "number" && Number.isFinite(size)) {
    return Math.trunc(size);
  }
  if (typeof size === "string") {
    const parsed = Number.parseInt(size, 10);
    return Number.isNaN(parsed) ? null : parsed;
  }
  return null;
}

async function updateMediaDocuments(input: ParsedMediaPath & {
  storagePath: string;
  updates: MediaDocumentUpdates;
}): Promise<void> {
  const {userId, patientId, woundId, assessmentId, mediaId, fileName, storagePath, updates} = input;

  const payload: Record<string, unknown> = {
    storagePath,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  if (updates.thumbUrl) {
    payload.thumbUrl = updates.thumbUrl;
  }
  if (updates.thumbStoragePath) {
    payload.thumbStoragePath = updates.thumbStoragePath;
  }
  if (updates.mimeType) {
    payload.mimeType = updates.mimeType;
  }
  if (updates.width !== undefined && updates.width !== null) {
    payload.width = updates.width;
  }
  if (updates.height !== undefined && updates.height !== null) {
    payload.height = updates.height;
  }
  if (updates.fileSize !== undefined && updates.fileSize !== null) {
    payload.fileSize = updates.fileSize;
  }

  const updatedDocPaths: string[] = [];

  if (mediaId) {
    const docPath = `users/${userId}/patients/${patientId}/wounds/${woundId}/assessments/${assessmentId}/media/${mediaId}`;
    const docRef = admin.firestore().doc(docPath);
    const snapshot = await docRef.get();
    if (snapshot.exists) {
      await docRef.set(payload, {merge: true});
      updatedDocPaths.push(docPath);
    }
  }

  if (updatedDocPaths.length === 0) {
    const docs = await findMediaDocsByStoragePath(storagePath);
    if (docs.length === 0) {
      logger.warn("Nenhum documento de mídia encontrado para atualizar", {
        storagePath,
        fileName,
      });
      return;
    }

    await Promise.all(docs.map((doc) => doc.ref.set(payload, {merge: true})));
    updatedDocPaths.push(...docs.map((doc) => doc.ref.path));
  }

  logger.info("Documentos de mídia atualizados", {
    storagePath,
    updatedDocs: updatedDocPaths,
  });
}

async function findMediaDocsByStoragePath(storagePath: string, retries = 3, delayMs = 250): Promise<FirebaseFirestore.QueryDocumentSnapshot[]> {
  for (let attempt = 0; attempt < retries; attempt++) {
    const snapshot = await admin
      .firestore()
      .collectionGroup(MEDIA_COLLECTION_GROUP)
      .where("storagePath", "==", storagePath)
      .get();

    if (!snapshot.empty) {
      return snapshot.docs;
    }

    if (attempt < retries - 1) {
      await wait(delayMs * (attempt + 1));
    }
  }

  return [];
}

function wait(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function extractMediaId(fileName: string): string | null {
  const dotIndex = fileName.lastIndexOf(".");
  const base = dotIndex >= 0 ? fileName.substring(0, dotIndex) : fileName;
  if (!base) {
    return null;
  }
  const sanitized = base.replace(/_thumb$/i, "");
  return sanitized || null;
}

/**
 * Função HTTP para teste (desenvolvimento)
 */
export const helloWorld = onRequest((request, response) => {
  logger.info("Hello World chamado", { 
    method: request.method,
    url: request.url,
  });
  
  response.json({
    message: "Hello from Cicatriza Functions!",
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || "development",
  });
});

// TODO: Implementar em M1+
// export const onAssessmentCreate = ...
// export const scheduleReviewReminder = ...
// export const onTransferRequested = ...
