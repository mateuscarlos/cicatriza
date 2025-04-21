import React, { useState, useEffect } from 'react';
import { StyleSheet, View, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import { useRouter } from 'expo-router';
import { ThemedText } from '../components/ThemedText';
import { ThemedView } from '../components/ThemedView';
import { MaterialIcons } from '@expo/vector-icons';

// Mock de dados para compromissos
const mockAppointments = [
  { id: 1, time: '08:30', patient: 'Maria Silva', type: 'Troca de Curativo' },
  { id: 2, time: '10:15', patient: 'João Pereira', type: 'Avaliação Inicial' },
  { id: 3, time: '13:00', patient: 'Ana Costa', type: 'Acompanhamento' },
  { id: 4, time: '15:45', patient: 'Carlos Mendes', type: 'Desbridamento' },
];

const AppointmentItem = ({ time, patient, type }) => (
  <View style={styles.appointmentItem}>
    <View style={styles.appointmentTime}>
      <ThemedText style={styles.timeText}>{time}</ThemedText>
    </View>
    <View style={styles.appointmentInfo}>
      <ThemedText style={styles.patientName}>{patient}</ThemedText>
      <ThemedText style={styles.appointmentType}>{type}</ThemedText>
    </View>
  </View>
);

export default function HomeScreen() {
  const router = useRouter();
  const [appointments, setAppointments] = useState([]);
  const [user, setUser] = useState({ name: 'Usuário' }); // Valor padrão para evitar erros
  
  useEffect(() => {
    // A verificação de login agora é feita no AuthenticationGuard
    // Aqui apenas atualizamos os dados do usuário se estiverem disponíveis
    if (global.loggedInUser) {
      setUser(global.loggedInUser);
    }
    
    // Carregar compromissos (mock)
    setAppointments(mockAppointments);
  }, []);

  const navigateToPatients = () => {
    router.push('/patient/patient');
  };
  
  const navigateToNewPatient = () => {
    router.push('/patient/register');
  };

  return (
    <SafeAreaView style={{flex: 1}}>
      <ThemedView style={styles.container}>
        <View style={styles.header}>
          <ThemedText type="title">Olá, {user.name}</ThemedText>
        </View>
        
        <View style={styles.calendarSection}>
          <View style={styles.sectionHeader}>
            <ThemedText type="subtitle">Compromissos de Hoje</ThemedText>
            <MaterialIcons name="event" size={24} color="#555" />
          </View>
          
          <ScrollView style={styles.appointmentsList}>
            {appointments.length > 0 ? (
              appointments.map((app) => (
                <AppointmentItem 
                  key={app.id}
                  time={app.time}
                  patient={app.patient}
                  type={app.type}
                />
              ))
            ) : (
              <ThemedText style={styles.noAppointments}>
                Não há compromissos agendados para hoje.
              </ThemedText>
            )}
          </ScrollView>
        </View>
        
        <View style={styles.buttonsContainer}>
          <TouchableOpacity 
            style={styles.actionButton} 
            onPress={navigateToPatients}
          >
            <MaterialIcons name="people" size={24} color="white" />
            <ThemedText style={styles.buttonText}>Ver Pacientes</ThemedText>
          </TouchableOpacity>
          
          <TouchableOpacity 
            style={[styles.actionButton, styles.registerButton]} 
            onPress={navigateToNewPatient}
          >
            <MaterialIcons name="person-add" size={24} color="white" />
            <ThemedText style={styles.buttonText}>Cadastrar Paciente</ThemedText>
          </TouchableOpacity>
        </View>
      </ThemedView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  header: {
    paddingVertical: 16,
    marginTop: 25, // Adicionado espaço extra no topo
    marginBottom: 16,
  },
  calendarSection: {
    flex: 1,
    backgroundColor: '#f8f8f8',
    borderRadius: 8,
    padding: 16,
    marginBottom: 20,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  appointmentsList: {
    flex: 1,
  },
  appointmentItem: {
    flexDirection: 'row',
    borderBottomWidth: 1,
    borderBottomColor: '#e0e0e0',
    paddingVertical: 12,
  },
  appointmentTime: {
    backgroundColor: '#e7f3ff',
    borderRadius: 4,
    paddingHorizontal: 8,
    paddingVertical: 6,
    justifyContent: 'center',
    marginRight: 12,
  },
  timeText: {
    fontWeight: 'bold',
  },
  appointmentInfo: {
    flex: 1,
    justifyContent: 'center',
  },
  patientName: {
    fontWeight: 'bold',
    fontSize: 16,
    marginBottom: 4,
  },
  appointmentType: {
    color: '#666',
    fontSize: 14,
  },
  noAppointments: {
    textAlign: 'center',
    color: '#888',
    paddingVertical: 20,
  },
  buttonsContainer: {
    flexDirection: 'row',
    gap: 10,
  },
  actionButton: {
    backgroundColor: '#4285F4',
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 14,
    borderRadius: 8,
  },
  registerButton: {
    backgroundColor: '#34A853',
  },
  buttonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 16,
    marginLeft: 8,
  },
});