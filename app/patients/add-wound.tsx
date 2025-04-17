import React, { useState } from 'react';
import { View, Text, TextInput, Button, StyleSheet, ScrollView, Alert } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { collection, addDoc, Timestamp } from 'firebase/firestore';
import { db } from '../../src/services/firebase';
import { Wound } from '../../components/interfaces/interfaces.firestore';

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
      router.navigate(`/patients/details?id=${id}`);
    } catch (error) {
      console.error('Erro ao cadastrar lesão:', error);
      Alert.alert('Erro', 'Não foi possível cadastrar a lesão.');
    }
  };

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.title}>Cadastrar Lesão</Text>
      <TextInput
        style={styles.input}
        placeholder="Tipo de Lesão"
        value={wound.type}
        onChangeText={(text) => setWound({ ...wound, type: text })}
      />
      <TextInput
        style={styles.input}
        placeholder="Duração"
        value={wound.duration}
        onChangeText={(text) => setWound({ ...wound, duration: text })}
      />
      <TextInput
        style={styles.input}
        placeholder="Tratamentos Anteriores (separados por vírgula)"
        value={wound.previousTreatments.join(', ')}
        onChangeText={(text) =>
          setWound({ ...wound, previousTreatments: text.split(',').map((item) => item.trim()) })
        }
      />
      <TextInput
        style={styles.input}
        placeholder="Comprimento (mm)"
        keyboardType="numeric"
        value={wound.size.lengthMm.toString()}
        onChangeText={(text) =>
          setWound({ ...wound, size: { ...wound.size, lengthMm: parseInt(text) || 0 } })
        }
      />
      <TextInput
        style={styles.input}
        placeholder="Largura (mm)"
        keyboardType="numeric"
        value={wound.size.widthMm.toString()}
        onChangeText={(text) =>
          setWound({ ...wound, size: { ...wound.size, widthMm: parseInt(text) || 0 } })
        }
      />
      <TextInput
        style={styles.input}
        placeholder="Profundidade (mm)"
        keyboardType="numeric"
        value={wound.size.depthMm.toString()}
        onChangeText={(text) =>
          setWound({ ...wound, size: { ...wound.size, depthMm: parseInt(text) || 0 } })
        }
      />
      <Button title="Salvar Lesão" onPress={handleSaveWound} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flexGrow: 1,
    padding: 16,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
  },
  input: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 8,
    padding: 8,
    marginBottom: 16,
  },
});