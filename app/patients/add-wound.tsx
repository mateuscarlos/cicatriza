import React, { useState } from 'react';
import { View, Text, TextInput, Button, StyleSheet, Alert } from 'react-native';
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
    <View style={styles.container}>
      <Text style={styles.title}>Cadastrar Lesão</Text>

      <Text style={styles.label}>Tipo de Lesão</Text>
      <TextInput
        style={styles.input}
        placeholder="Tipo de Lesão"
        value={wound.type}
        onChangeText={(text) => setWound({ ...wound, type: text })}
      />

      <Text style={styles.label}>Duração</Text>
      <TextInput
        style={styles.input}
        placeholder="Duração"
        value={wound.duration}
        onChangeText={(text) => setWound({ ...wound, duration: text })}
      />

      <Text style={styles.label}>Tratamentos Anteriores</Text>
      <TextInput
        style={styles.input}
        placeholder="Tratamentos Anteriores (separados por vírgula)"
        value={wound.previousTreatments.join(', ')}
        onChangeText={(text) =>
          setWound({ ...wound, previousTreatments: text.split(',').map((item) => item.trim()) })
        }
      />

      <Text style={styles.label}>Comprimento (mm)</Text>
      <TextInput
        style={styles.input}
        placeholder="Comprimento (mm)"
        keyboardType="numeric"
        value={wound.size.lengthMm.toString()}
        onChangeText={(text) =>
          setWound({ ...wound, size: { ...wound.size, lengthMm: parseInt(text) || 0 } })
        }
      />

      <Text style={styles.label}>Largura (mm)</Text>
      <TextInput
        style={styles.input}
        placeholder="Largura (mm)"
        keyboardType="numeric"
        value={wound.size.widthMm.toString()}
        onChangeText={(text) =>
          setWound({ ...wound, size: { ...wound.size, widthMm: parseInt(text) || 0 } })
        }
      />

      <Text style={styles.label}>Profundidade (mm)</Text>
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
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
    backgroundColor: '#f5f5f5',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
    color: '#333',
  },
  label: {
    fontSize: 16,
    fontWeight: '500',
    marginBottom: 4,
    color: '#555',
  },
  input: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 8,
    padding: 8,
    marginBottom: 16,
    backgroundColor: '#fff',
  },
});