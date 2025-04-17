// types.ts
import { Timestamp, FieldValue } from 'firebase/firestore';

// Alias Timestamp for clarity if needed
type FirestoreTimestamp = Timestamp;

// Interface para Paciente
export interface Patient {
  id: string; // ID gerado pelo Firestore
  name: string;
  birthDate: string; // Ou Date, dependendo de como você armazena
  age: number;
  weight: number;
  gender: string;
  comorbidities: string[];
  medications: string[];
  allergies: string[];
  smoker: boolean;
  alcohol: boolean;
  notes?: string; // Notas adicionais, opcional
  createdAt?: Timestamp | string | FieldValue; // Data de criação do registro do paciente
  updatedAt?: Timestamp | string | FieldValue; // Data da última atualização
}

  export interface UserData {
    name: string;
    email: string;
  }
  
 // Interface para representar uma Parte do Corpo associada a um Paciente
export interface BodyPart {
  name: string;
  imageTag: string; // Tag ou identificador para a imagem associada
  createdAt: FieldValue; // Data de criação do registro da parte do corpo
}
  
  export interface Wound {
    type: string;
    duration: string;
    previousTreatments: string[];
    size: {
      lengthMm: number;
      widthMm: number;
      depthMm: number;
    };
    locationImageTag: string;
    painLevel: {
      value: number;
      category: string;
    };
    status: "N/A - primeira avaliação" | "Piora" | "Estagnação" | "Melhorando";
    goalManagement: {
      woundEdge: string[];
      woundBed: string[];
      periwoundSkin: string[];
      fullTextGoals: string;
    };
    treatmentPlan: {
      treatment: string;
      dressingType: string;
      dressingRationale: string;
    };
    reassessmentPlan: {
      nextVisit: string;
      mainObjective: string;
    };
    createdAt: FieldValue | Timestamp; // Firestore server timestamp or Date object after fetch
    lastUpdated: string;
  }
  
  export interface BedEvaluation {
    tissueComposition: {
      necrotic: number;
      granulation: number;
      slough: number;
      epithelialization: number;
    };
    exudate: {
      level: {
        dry: boolean;
        low: boolean;
        moderate: boolean;
        high: boolean;
      };
      type: {
        fino: boolean;
        turvo: boolean;
        espesso: boolean;
        purulento: boolean;
        claro: boolean;
        rosa_vermelho: boolean;
      };
      accumulated: boolean;
    };
    infection: {
      local: {
        aumento_da_dor: boolean;
        eritrema: boolean;
        edema: boolean;
        calor_local: boolean;
        aumento_exsudato: boolean;
        atraso_cicatrização: boolean;
        tecido_friavel: boolean;
        odor: boolean;
        descolamento: boolean;
        biofilme: boolean;
      };
      systemic: {
        aumento_eritema: boolean;
        febre: boolean;
        abccesos_pus: boolean;
        rompimento: boolean;
        celulite: boolean;
        mal_estar: boolean;
        aumento_leucocitos: boolean;
        linfangite: boolean;
      };
    };
    observedAt: FieldValue | Timestamp; // Firestore server timestamp or Date object after fetch
  }
  
  export interface EdgeEvaluation {
    features: {
      maceracao: boolean;
      desidratacao: boolean;
      deslocamento: boolean;
      epíbole: boolean;
      extensao: number; // cm
    };
    observedAt: FieldValue | Timestamp; // Firestore server timestamp or Date object after fetch
  }
  
  export interface PerilesionalSkinEvaluation {
    maceracao: number;
    escoriacao: number;
    xerose: number;
    hiperqueratose: number;
    calo: number;
    eczema: number;
    observedAt: FieldValue | Timestamp; // Firestore server timestamp or Date object after fetch
  }
  
  export interface Prescription {
    title: string;
    content: string;
    createdAt: FieldValue | Timestamp; // Firestore server timestamp or Date object after fetch
  }
  