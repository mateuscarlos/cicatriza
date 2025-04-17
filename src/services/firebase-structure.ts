import firestore from '@react-native-firebase/firestore';
import {
  Patient,
  BodyPart,
  Wound,
  BedEvaluation,
  EdgeEvaluation,
  PerilesionalSkinEvaluation,
  Prescription,
} from '../../components/interfaces/interfaces.firestore';

// Função para criar um usuário
interface UserData {
  name: string;
  email: string;
}

async function createUser(userId: string, userData: UserData): Promise<void> {
  try {
    const userRef = firestore().collection('users').doc(userId);
    await userRef.set(userData);
    console.log('Usuário criado com ID:', userId);
  } catch (error) {
    console.error('Erro ao criar usuário:', error);
  }
}

// Função para adicionar um paciente a um usuário
async function addPatient(userId: string, patientData: Patient): Promise<string | undefined> {
  try {
    const patientsCollectionRef = firestore()
      .collection('users')
      .doc(userId)
      .collection('patients');
    const docRef = await patientsCollectionRef.add(patientData);
    console.log('Paciente adicionado com ID:', docRef.id);
    return docRef.id;
  } catch (error) {
    console.error('Erro ao adicionar paciente:', error);
  }
}

// Função para adicionar uma parte do corpo a um paciente
async function addBodyPart(userId: string, patientId: string, bodyPartData: BodyPart): Promise<string | undefined> {
  try {
    const bodyPartsCollectionRef = firestore()
      .collection('users')
      .doc(userId)
      .collection('patients')
      .doc(patientId)
      .collection('bodyParts');
    const docRef = await bodyPartsCollectionRef.add(bodyPartData);
    console.log('Parte do corpo adicionada com ID:', docRef.id);
    return docRef.id;
  } catch (error) {
    console.error('Erro ao adicionar parte do corpo:', error);
  }
}

// Função para adicionar uma ferida a uma parte do corpo
async function addWound(userId: string, patientId: string, bodyPartId: string, woundData: Wound): Promise<string | undefined> {
  try {
    const woundsCollectionRef = firestore()
      .collection('users')
      .doc(userId)
      .collection('patients')
      .doc(patientId)
      .collection('bodyParts')
      .doc(bodyPartId)
      .collection('wounds');
    const docRef = await woundsCollectionRef.add(woundData);
    console.log('Ferida adicionada com ID:', docRef.id);
    return docRef.id;
  } catch (error) {
    console.error('Erro ao adicionar ferida:', error);
  }
}

// Função para adicionar uma avaliação do leito da ferida
async function addBedEvaluation(
  userId: string,
  patientId: string,
  bodyPartId: string,
  woundId: string,
  evaluationData: BedEvaluation
): Promise<void> {
  try {
    const bedEvalCollectionRef = firestore()
      .collection('users')
      .doc(userId)
      .collection('patients')
      .doc(patientId)
      .collection('bodyParts')
      .doc(bodyPartId)
      .collection('wounds')
      .doc(woundId)
      .collection('bedEvaluations');
    const docRef = await bedEvalCollectionRef.add(evaluationData);
    console.log('Avaliação do leito da ferida adicionada com ID:', docRef.id);
  } catch (error) {
    console.error('Erro ao adicionar avaliação do leito:', error);
  }
}

// Função para adicionar uma avaliação da borda da ferida
async function addEdgeEvaluation(
  userId: string,
  patientId: string,
  bodyPartId: string,
  woundId: string,
  evaluationData: EdgeEvaluation
): Promise<void> {
  try {
    const edgeEvalCollectionRef = firestore()
      .collection('users')
      .doc(userId)
      .collection('patients')
      .doc(patientId)
      .collection('bodyParts')
      .doc(bodyPartId)
      .collection('wounds')
      .doc(woundId)
      .collection('edgeEvaluations');
    const docRef = await edgeEvalCollectionRef.add(evaluationData);
    console.log('Avaliação da borda da ferida adicionada com ID:', docRef.id);
  } catch (error) {
    console.error('Erro ao adicionar avaliação da borda:', error);
  }
}

// Função para adicionar uma avaliação da pele perilesional
async function addPerilesionalSkinEvaluation(
  userId: string,
  patientId: string,
  bodyPartId: string,
  woundId: string,
  evaluationData: PerilesionalSkinEvaluation
): Promise<void> {
  try {
    const skinEvalCollectionRef = firestore()
      .collection('users')
      .doc(userId)
      .collection('patients')
      .doc(patientId)
      .collection('bodyParts')
      .doc(bodyPartId)
      .collection('wounds')
      .doc(woundId)
      .collection('perilesionalSkinEvaluations');
    const docRef = await skinEvalCollectionRef.add(evaluationData);
    console.log('Avaliação da pele perilesional adicionada com ID:', docRef.id);
  } catch (error) {
    console.error('Erro ao adicionar avaliação da pele perilesional:', error);
  }
}

// Função para adicionar uma prescrição a um paciente
async function addPrescription(
  userId: string,
  patientId: string,
  prescriptionData: Prescription
): Promise<void> {
  try {
    const prescriptionsCollectionRef = firestore()
      .collection('users')
      .doc(userId)
      .collection('patients')
      .doc(patientId)
      .collection('prescriptions');
    const docRef = await prescriptionsCollectionRef.add(prescriptionData);
    console.log('Prescrição adicionada com ID:', docRef.id);
  } catch (error) {
    console.error('Erro ao adicionar prescrição:', error);
  }
}

export {
  createUser,
  addPatient,
  addBodyPart,
  addWound,
  addBedEvaluation,
  addEdgeEvaluation,
  addPerilesionalSkinEvaluation,
  addPrescription,
};