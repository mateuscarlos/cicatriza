import React from 'react';
import { StyleSheet, View, FlatList } from 'react-native';
import { ThemedText } from '../../components/ThemedText';
import { ThemedView } from '../../components/ThemedView';

// Mock de dados para pacientes
const mockPatients = [
  { id: '1', name: 'Maria Silva', condition: 'Úlcera Venosa', lastVisit: '15/04/2025' },
  { id: '2', name: 'João Pereira', condition: 'Queimadura 2º Grau', lastVisit: '10/04/2025' },
  { id: '3', name: 'Ana Costa', condition: 'Úlcera de Pressão', lastVisit: '08/04/2025' },
  { id: '4', name: 'Carlos Mendes', condition: 'Lesão Diabética', lastVisit: '03/04/2025' },
  { id: '5', name: 'Fernanda Lima', condition: 'Ferida Cirúrgica', lastVisit: '01/04/2025' },
];

const PatientItem = ({ name, condition, lastVisit }) => (
  <View style={styles.patientItem}>
    <ThemedText style={styles.patientName}>{name}</ThemedText>
    <ThemedText style={styles.patientCondition}>{condition}</ThemedText>
    <ThemedText style={styles.lastVisit}>Última visita: {lastVisit}</ThemedText>
  </View>
);

export default function PatientsScreen() {
  return (
    <ThemedView style={styles.container}>
      <FlatList
        data={mockPatients}
        renderItem={({ item }) => (
          <PatientItem 
            name={item.name}
            condition={item.condition}
            lastVisit={item.lastVisit}
          />
        )}
        keyExtractor={item => item.id}
      />
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  patientItem: {
    backgroundColor: '#f8f8f8',
    borderRadius: 8,
    padding: 16,
    marginBottom: 12,
  },
  patientName: {
    fontWeight: 'bold',
    fontSize: 18,
    marginBottom: 4,
  },
  patientCondition: {
    fontSize: 16,
    marginBottom: 4,
  },
  lastVisit: {
    fontSize: 14,
    color: '#666',
  },
});