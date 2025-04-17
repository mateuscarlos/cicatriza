import { useState } from 'react';
import { View, Text, TextInput, Button, StyleSheet, ScrollView } from 'react-native';
import { collection, addDoc } from 'firebase/firestore';
import { db } from '../../src/services/firebase';

export default function AddPatientScreen() {
  const [patient, setPatient] = useState({
    name: '',
    birthDate: '',
    age: 0,
    weight: 0,
    gender: '',
    nutritionalStatus: false,
    mobility: false,
    smoker: false,
    cigarettesPerDay: 0,
    comorbidities: '',
    medications: '',
  });

  const handleAddPatient = async () => {
    try {
      const docRef = await addDoc(collection(db, 'patients'), {
        ...patient,
        comorbidities: patient.comorbidities.split(',').map((item) => item.trim()),
        medications: patient.medications.split(',').map((item) => item.trim()),
        createdAt: new Date().toISOString(),
      });
      console.log('Paciente adicionado com ID:', docRef.id);
      alert('Paciente adicionado com sucesso!');
    } catch (error) {
      console.error('Erro ao adicionar paciente:', error);
      alert('Erro ao adicionar paciente.');
    }
  };

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.title}>Adicionar Paciente</Text>
      <TextInput
        style={styles.input}
        placeholder="Nome"
        value={patient.name}
        onChangeText={(text) => setPatient({ ...patient, name: text })}
      />
      <TextInput
        style={styles.input}
        placeholder="Data de Nascimento (YYYY-MM-DD)"
        value={patient.birthDate}
        onChangeText={(text) => setPatient({ ...patient, birthDate: text })}
      />
      <TextInput
        style={styles.input}
        placeholder="Idade"
        keyboardType="numeric"
        value={patient.age.toString()}
        onChangeText={(text) => setPatient({ ...patient, age: parseInt(text) || 0 })}
      />
      <TextInput
        style={styles.input}
        placeholder="Peso (kg)"
        keyboardType="numeric"
        value={patient.weight.toString()}
        onChangeText={(text) => setPatient({ ...patient, weight: parseFloat(text) || 0 })}
      />
      <TextInput
        style={styles.input}
        placeholder="Gênero"
        value={patient.gender}
        onChangeText={(text) => setPatient({ ...patient, gender: text })}
      />
      <TextInput
        style={styles.input}
        placeholder="Comorbidades (separadas por vírgula)"
        value={patient.comorbidities}
        onChangeText={(text) => setPatient({ ...patient, comorbidities: text })}
      />
      <TextInput
        style={styles.input}
        placeholder="Medicações (separadas por vírgula)"
        value={patient.medications}
        onChangeText={(text) => setPatient({ ...patient, medications: text })}
      />
      <Button title="Salvar Paciente" onPress={handleAddPatient} />
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