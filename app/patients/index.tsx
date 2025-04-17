import { useEffect, useState } from 'react';
import { View, Text, FlatList, Button, StyleSheet } from 'react-native';
import { collection, getDocs } from 'firebase/firestore';
import { db } from '../../src/services/firebase';
import { useRouter } from 'expo-router';
import { Patient } from '../../components/interfaces/interfaces.firestore'; // Importando o tipo Patient

// Define a type that includes the document ID along with Patient data
type PatientWithId = Patient & { id: string };

export default function PatientsScreen() {
  const [patients, setPatients] = useState<PatientWithId[]>([]);
  const router = useRouter();

  useEffect(() => {
    const fetchPatients = async () => {
      try {
        const querySnapshot = await getDocs(collection(db, 'patients'));
        const patientsData = querySnapshot.docs.map((doc) => {
          const data = doc.data() as Patient;
          // Ensure the document ID takes precedence over any 'id' field in the data
          return { ...data, id: doc.id };
        });
        setPatients(patientsData);
      } catch (error) {
        console.error('Erro ao buscar pacientes:', error);
      }
    };

    fetchPatients();
  }, []);

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Pacientes</Text>
      <FlatList
        data={patients}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <View style={styles.patientCard}>
            <Text style={styles.patientName}>{item.name}</Text>
            <Text>Idade: {item.age}</Text>
            <Button
              title="Detalhes"
              onPress={() => router.push(`/patients/details?id=${item.id}`)}
            />
          </View>
        )}
      />
      <Button title="Adicionar Paciente" onPress={() => router.push('/patients/add')} />
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
  patientCard: {
    padding: 16,
    marginBottom: 8,
    backgroundColor: '#f9f9f9',
    borderRadius: 8,
  },
  patientName: {
    fontSize: 18,
    fontWeight: 'bold',
  },
});