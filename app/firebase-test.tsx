import * as React from 'react';
import '../src/services/firebase';
import { View, Button, StyleSheet, Alert } from 'react-native';
import { Timestamp } from 'firebase/firestore';
import {
  createUser,
  addPatient,
  addBodyPart,
  addWound,
  addBedEvaluation,
  addEdgeEvaluation,
  addPerilesionalSkinEvaluation,
  addPrescription,
} from '../src/services/firebase-structure';

const FirebaseTestScreen = () => {
  const handleCreateStructure = async () => {
    try {
      const userId = 'user123';
      const user = { name: 'João Silva', email: 'joao@example.com' };
      await createUser(userId, user);

      const patient = {
        id: '',
        name: 'Maria Oliveira',
        birthDate: '1990-05-15',
        age: 33,
        weight: 70,
        gender: 'Feminino',
        comorbidities: ['Diabetes', 'Hipertensão'],
        medications: ['Metformina', 'Losartana'],
        allergies: ['Nenhuma'],
        smoker: false,
        alcohol: false,
        notes: 'Paciente com histórico de feridas crônicas.',
        createdAt: Timestamp.fromDate(new Date()),
        updatedAt: Timestamp.fromDate(new Date()),
      };
      const patientId = await addPatient(userId, patient);
      if (!patientId) {
        throw new Error('Falha ao criar paciente.');
      }
      const bodyPart = {
        name: 'Perna Direita',
        imageTag: 'perna-direita',
        createdAt: Timestamp.fromDate(new Date()),
      };
      const bodyPartId = await addBodyPart(userId, patientId, bodyPart);
      if (!bodyPartId) {
        throw new Error('Falha ao adicionar parte do corpo.');
      }

      const wound = {
        type: 'Úlcera',
        duration: '3 meses',
        previousTreatments: ['Curativo com hidrogel'],
        size: { lengthMm: 50, widthMm: 30, depthMm: 5 },
        locationImageTag: 'joelho-direito',
        painLevel: { value: 5, category: 'Moderada' },
        status: 'Estagnação' as const,
        goalManagement: {
          woundEdge: ['Reduzir maceração'],
          woundBed: ['Promover granulação'],
          periwoundSkin: ['Reduzir xerose'],
          fullTextGoals: 'Melhorar o estado geral da ferida.',
        },
        treatmentPlan: {
          treatment: 'Curativo com hidrocolóide',
          dressingType: 'Hidrocolóide',
          dressingRationale: 'Manter um ambiente úmido para cicatrização.',
        },
        reassessmentPlan: {
          nextVisit: '2025-04-20',
          mainObjective: 'Avaliar evolução da granulação.',
        },
        createdAt: Timestamp.fromDate(new Date()),
        lastUpdated: new Date().toISOString(),
      };
      const woundId = await addWound(userId, patientId, bodyPartId, wound);
      if (!woundId) {
        throw new Error('Falha ao adicionar ferida.');
      }

      const bedEvaluation = {
        tissueComposition: {
          necrotic: 10,
          granulation: 60,
          slough: 20,
          epithelialization: 10,
        },
        exudate: {
          level: { dry: false, low: true, moderate: false, high: false },
          type: {
            fino: true,
            turvo: false,
            espesso: false,
            purulento: false,
            claro: true,
            rosa_vermelho: false,
          },
          accumulated: false,
        },
        infection: {
          local: {
            aumento_da_dor: false,
            eritrema: false,
            edema: false,
            calor_local: false,
            aumento_exsudato: false,
            atraso_cicatrização: false,
            tecido_friavel: false,
            odor: false,
            descolamento: false,
            biofilme: false,
          },
          systemic: {
            aumento_eritema: false,
            febre: false,
            abccesos_pus: false,
            rompimento: false,
            celulite: false,
            mal_estar: false,
            aumento_leucocitos: false,
            linfangite: false,
          },
        },
        observedAt: Timestamp.fromDate(new Date()),
      };
      await addBedEvaluation(userId, patientId, bodyPartId, woundId, bedEvaluation);

      const edgeEvaluation = {
        features: {
          maceracao: true,
          desidratacao: false,
          deslocamento: false,
          epíbole: false,
          extensao: 2,
        },
        observedAt: Timestamp.fromDate(new Date()),
      };
      await addEdgeEvaluation(userId, patientId, bodyPartId, woundId, edgeEvaluation);

      const skinEvaluation = {
        maceracao: 1,
        escoriacao: 0,
        xerose: 2,
        hiperqueratose: 0,
        calo: 0,
        eczema: 0,
        observedAt: Timestamp.fromDate(new Date()),
      };
      await addPerilesionalSkinEvaluation(userId, patientId, bodyPartId, woundId, skinEvaluation);

      const prescription = {
        title: 'Curativo com hidrocolóide',
        content: 'Trocar o curativo a cada 3 dias.',
        createdAt: Timestamp.fromDate(new Date()),
      };
      await addPrescription(userId, patientId, prescription);

      Alert.alert('Sucesso', 'Estrutura de coleções criada com sucesso!');
    } catch (error) {
      console.error('Erro ao criar estrutura:', error);
      Alert.alert('Erro', 'Não foi possível criar a estrutura.');
    }
  };

  return (
    <View style={styles.container}>
      <Button title="Criar Estrutura no Firebase" onPress={handleCreateStructure} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 16,
  },
});

export default FirebaseTestScreen;