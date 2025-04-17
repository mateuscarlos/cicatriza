import { useState } from 'react';
import { View, Text, TextInput, Button, StyleSheet } from 'react-native';
import { useRouter } from 'expo-router';

export default function AddPatientScreen() {
  const [name, setName] = useState('');
  const [age, setAge] = useState('');
  const router = useRouter();

  const handleAddPatient = () => {
    // Aqui você pode integrar com o Firestore para salvar o paciente
    console.log('Paciente adicionado:', { name, age });
    router.push('/patients');
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Adicionar Paciente</Text>
      <TextInput
        style={styles.input}
        placeholder="Nome"
        value={name}
        onChangeText={setName}
      />
      <TextInput
        style={styles.input}
        placeholder="Idade"
        value={age}
        onChangeText={setAge}
        keyboardType="numeric"
      />
      <Button title="Salvar" onPress={handleAddPatient} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
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