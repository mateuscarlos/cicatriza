import { useState } from 'react';
import { View, Text, TextInput, Button, StyleSheet, ScrollView, Alert } from 'react-native';
import { collection, addDoc } from 'firebase/firestore';
import { db } from '../../src/services/firebase';
import { Patient } from '../../components/interfaces/interfaces.firestore';
import { useRouter } from 'expo-router';

export default function AddPatientScreen() {
  const [patient, setPatient] = useState<Patient>({
    id: '',
    name: '',
    birthDate: '',
    age: 0,
    weight: 0,
    gender: '',
    comorbidities: [],
    medications: [],
    allergies: [],
    smoker: false,
    alcohol: false,
    notes: '',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  });

  const router = useRouter();

  const handleSavePatient = async (redirectTo: string) => {
    try {
      const docRef = await addDoc(collection(db, 'patients'), {
        ...patient,
        comorbidities: patient.comorbidities.map((item) => item.trim()),
        medications: patient.medications.map((item) => item.trim()),
        allergies: patient.allergies.map((item) => item.trim()),
      });
      console.log('Paciente adicionado com ID:', docRef.id);
      Alert.alert('Sucesso', 'Paciente adicionado com sucesso!');
      if (redirectTo === 'bodyparts') {
        router.push({ pathname: '/patients/bodyparts', query: { id: docRef.id } });
      } else {
        router.push('/patients');
      }
    } catch (error) {
      console.error('Erro ao adicionar paciente:', error);
      Alert.alert('Erro', 'Não foi possível adicionar o paciente.');
    }
  };

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.title}>Adicionar Paciente</Text>

      <Text style={styles.label}>Nome</Text>
      <TextInput
        style={styles.input}
        placeholder="Nome"
        value={patient.name}
        onChangeText={(text) => setPatient({ ...patient, name: text })}
      />

      <Text style={styles.label}>Data de Nascimento (YYYY-MM-DD)</Text>
      <TextInput
        style={styles.input}
        placeholder="Data de Nascimento"
        value={patient.birthDate}
        onChangeText={(text) => setPatient({ ...patient, birthDate: text })}
      />

      <Text style={styles.label}>Idade</Text>
      <TextInput
        style={styles.input}
        placeholder="Idade"
        keyboardType="numeric"
        value={patient.age.toString()}
        onChangeText={(text) => setPatient({ ...patient, age: parseInt(text) || 0 })}
      />

      <Text style={styles.label}>Peso (kg)</Text>
      <TextInput
        style={styles.input}
        placeholder="Peso"
        keyboardType="numeric"
        value={patient.weight.toString()}
        onChangeText={(text) => setPatient({ ...patient, weight: parseFloat(text) || 0 })}
      />

      <Text style={styles.label}>Gênero</Text>
      <TextInput
        style={styles.input}
        placeholder="Gênero"
        value={patient.gender}
        onChangeText={(text) => setPatient({ ...patient, gender: text })}
      />

      <Text style={styles.label}>Comorbidades (separadas por vírgula)</Text>
      <TextInput
        style={styles.input}
        placeholder="Comorbidades"
        value={patient.comorbidities.join(', ')}
        onChangeText={(text) =>
          setPatient({ ...patient, comorbidities: text.split(',').map((item) => item.trim()) })
        }
      />

      <Text style={styles.label}>Medicações (separadas por vírgula)</Text>
      <TextInput
        style={styles.input}
        placeholder="Medicações"
        value={patient.medications.join(', ')}
        onChangeText={(text) =>
          setPatient({ ...patient, medications: text.split(',').map((item) => item.trim()) })
        }
      />

      <Text style={styles.label}>Alergias (separadas por vírgula)</Text>
      <TextInput
        style={styles.input}
        placeholder="Alergias"
        value={patient.allergies.join(', ')}
        onChangeText={(text) =>
          setPatient({ ...patient, allergies: text.split(',').map((item) => item.trim()) })
        }
      />

      <Text style={styles.label}>Fumante</Text>
      <TextInput
        style={styles.input}
        placeholder="Sim ou Não"
        value={patient.smoker ? 'Sim' : 'Não'}
        onChangeText={(text) =>
          setPatient({ ...patient, smoker: text.toLowerCase() === 'sim' })
        }
      />

      <Text style={styles.label}>Consome Álcool</Text>
      <TextInput
        style={styles.input}
        placeholder="Sim ou Não"
        value={patient.alcohol ? 'Sim' : 'Não'}
        onChangeText={(text) =>
          setPatient({ ...patient, alcohol: text.toLowerCase() === 'sim' })
        }
      />

      <Text style={styles.label}>Notas Adicionais</Text>
      <TextInput
        style={styles.input}
        placeholder="Notas"
        value={patient.notes || ''}
        onChangeText={(text) => setPatient({ ...patient, notes: text })}
      />

      <Button title="Salvar Paciente" onPress={() => handleSavePatient('patients')} />
      <Button
        title="Adicionar Lesão"
        onPress={() => handleSavePatient('bodyparts')}
        color="#007BFF"
      />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flexGrow: 1,
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
    fontWeight: 'bold',
    marginBottom: 4,
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