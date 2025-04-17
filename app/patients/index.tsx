import { useEffect, useState } from 'react';
import { View, Text, FlatList, StyleSheet } from 'react-native';
import { collection, getDocs } from 'firebase/firestore';
import { db } from '../../src/services/firebase';

interface Patient {
  id: string;
  name: string; // Assuming 'name' exists in your Firestore data
  age: number;  // Assuming 'age' exists in your Firestore data
  // Add other patient fields as needed
}

export default function PatientsScreen() {
  const [patients, setPatients] = useState<Patient[]>([]);

  useEffect(() => {
    const fetchPatients = async () => {
      try {
        const querySnapshot = await getDocs(collection(db, 'patients'));
        const patientsData = querySnapshot.docs.map((doc) => ({
          id: doc.id,
          ...(doc.data() as Omit<Patient, 'id'>), // Assert the type here
        }));
        setPatients(patientsData);
      } catch (e) {
        console.error('Erro ao buscar pacientes:', e);
      }
    };

    fetchPatients();
  }, []); // Add empty dependency array to run only once on mount

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Lista de Pacientes</Text>
      <FlatList
        data={patients}
        keyExtractor={(item: Patient) => item.id}
        renderItem={({ item }: { item: Patient }) => (
          <View style={styles.patientCard}>
            <Text style={styles.patientName}>{item.name}</Text>
            <Text>Idade: {item.age}</Text>
          </View>
        )}
      />
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