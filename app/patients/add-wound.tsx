import React, { useState } from 'react';
import { Alert } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { collection, addDoc, Timestamp } from 'firebase/firestore';
import { db } from '../../src/services/firebase';
import { Wound } from '../../components/interfaces/interfaces.firestore';
import { YStack, Input, Button, Label, H1, Separator } from 'tamagui';

export default function AddWoundScreen() {
  const { id } = useLocalSearchParams();
  const router = useRouter();
  const [wound, setWound] = useState<Wound>({
    type: '',
    duration: '',
    previousTreatments: [],
    size: { lengthMm: 0, widthMm: 0, depthMm: 0 },
    locationImageTag: '',
    painLevel: { value: 0, category: '' },
    status: 'N/A - primeira avaliação',
    goalManagement: {
      woundEdge: [],
      woundBed: [],
      periwoundSkin: [],
      fullTextGoals: '',
    },
    treatmentPlan: {
      treatment: '',
      dressingType: '',
      dressingRationale: '',
    },
    reassessmentPlan: {
      nextVisit: '',
      mainObjective: '',
    },
    createdAt: Timestamp.fromDate(new Date()),
    lastUpdated: new Date().toISOString(),
  });

  const handleSaveWound = async () => {
    if (typeof id !== 'string') {
      Alert.alert('Erro', 'ID do paciente inválido.');
      return;
    }

    try {
      const woundsCollectionRef = collection(db, 'patients', id, 'wounds');
      await addDoc(woundsCollectionRef, wound);
      Alert.alert('Sucesso', 'Lesão cadastrada com sucesso!');
      router.push(`/patients/details?id=${id}`);
    } catch (error) {
      console.error('Erro ao cadastrar lesão:', error);
      Alert.alert('Erro', 'Não foi possível cadastrar a lesão.');
    }
  };

  return (
    <YStack flex={1} padding="$4" space="$4">
      <H1>Cadastrar Lesão</H1>
      <Separator />
      <Label>Tipo de Lesão</Label>
      <Input
        placeholder="Tipo de Lesão"
        value={wound.type}
        onChangeText={(text) => setWound({ ...wound, type: text })}
      />
      <Label>Duração</Label>
      <Input
        placeholder="Duração"
        value={wound.duration}
        onChangeText={(text) => setWound({ ...wound, duration: text })}
      />
      <Label>Tratamentos Anteriores</Label>
      <Input
        placeholder="Tratamentos Anteriores (separados por vírgula)"
        value={wound.previousTreatments.join(', ')}
        onChangeText={(text) =>
          setWound({ ...wound, previousTreatments: text.split(',').map((item) => item.trim()) })
        }
      />
      <Label>Comprimento (mm)</Label>
      <Input
        placeholder="Comprimento (mm)"
        keyboardType="numeric"
        value={wound.size.lengthMm.toString()}
        onChangeText={(text) =>
          setWound({ ...wound, size: { ...wound.size, lengthMm: parseInt(text) || 0 } })
        }
      />
      <Button onPress={handleSaveWound}>Salvar Lesão</Button>
    </YStack>
  );
}