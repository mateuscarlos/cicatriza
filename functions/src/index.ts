/**
 * Cloud Functions para CICATRIZA - Esqueleto M0
 * 
 * Funcionalidades implementadas:
 * - onUserCreate: Auditoria e inicialização de perfil
 * - onStorageFinalize: Gerar thumbnails para imagens
 * - Funções auxiliares para M1+
 */

import {setGlobalOptions} from "firebase-functions";
import {onRequest} from "firebase-functions/v2/https";
import {onObjectFinalized} from "firebase-functions/v2/storage";
import {beforeUserCreated} from "firebase-functions/v2/identity";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

// Inicializar Admin SDK
admin.initializeApp();

// Configurações globais
setGlobalOptions({ maxInstances: 10 });

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
    const { name, contentType } = object;
    
    if (!name || !contentType) {
      logger.warn("Objeto sem name ou contentType", { name, contentType });
      return;
    }

    logger.info("Arquivo enviado para Storage", {
      name,
      contentType,
      size: object.size,
    });

    // Verificar se é uma imagem em path de usuário
    if (contentType.startsWith("image/") && name.includes("users/")) {
      logger.info("Processando imagem para thumbnails", { name });
      
      // TODO: Implementar geração de thumbnails em M1
      // - Usar Sharp ou ImageMagick
      // - Gerar tamanhos: 512px, 1024px
      // - Salvar em thumbs/{size}/users/{uid}/...
      
      // Por enquanto, apenas log
      logger.info("Thumbnail será gerado em M1", { name });
    }

    // Verificar se é mídia de assessment e atualizar contador
    if (name.includes("/assessments/") && name.includes("/photos/")) {
      await updateAttachmentsCount(name);
    }

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
    const pathParts = storagePath.split("/");
    
    if (
      pathParts.length < 10 ||
      pathParts[0] !== "users" ||
      pathParts[2] !== "patients" ||
      pathParts[4] !== "wounds" ||
      pathParts[6] !== "assessments" ||
      pathParts[8] !== "photos"
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
