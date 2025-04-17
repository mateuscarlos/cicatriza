// types.ts

export interface Patient {
    id: string;
    name: string;
    birthDate: string;
    age: number;
    weight: number;
    gender: string;
    nutritionalStatus: boolean;
    mobility: boolean;
    smoker: boolean;
    cigarettesPerDay: number;
    comorbidities: string[];
    medications: string[];
    createdAt: string;
  }
  
  export interface BodyPart {
    name: string;
    imageTag: string;
    createdAt: string;
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
    createdAt: string;
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
      level: string;
      type: string;
      accumulated: boolean;
    };
    infection: {
      local: string[];
      systemic: string[];
    };
    observedAt: string;
  }
  
  export interface EdgeEvaluation {
    features: string[];
    extensionCm: number;
    observedAt: string;
  }
  
  export interface PerilesionalSkinEvaluation {
    maceraçãoCm: number;
    escoriacaoCm: number;
    xeroseCm: number;
    hiperqueratoseCm: number;
    caloCm: number;
    eczemaCm: number;
    observedAt: string;
  }
  
  export interface Prescription {
    title: string;
    content: string;
    createdAt: string;
  }
  