import React, { useState, useEffect } from 'react';
import { StyleSheet, View, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import { useRouter } from 'expo-router';
import { ThemedText } from '../components/ThemedText';
import { ThemedView } from '../components/ThemedView';
import { MaterialIcons, Ionicons } from '@expo/vector-icons';

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
  
  const navigateToModelViewer = () => {
    router.push('/modelViewer');
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
        
        {/* Botão temporário para visualização do modelo 3D */}
        <TouchableOpacity 
          style={styles.testModelButton} 
          onPress={navigateToModelViewer}
        >
          <Ionicons name="cube-outline" size={24} color="#fff" />
          <ThemedText style={styles.testButtonText}>
            Visualizar Modelo 3D
          </ThemedText>
        </TouchableOpacity>
        
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
    marginTop: 25,
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
    backgroundColor: '#ffffff',
    padding: 12,
    borderRadius: 8,
    marginBottom: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 1,
  },
  appointmentTime: {
    backgroundColor: '#E0E0E0',
    borderRadius: 6,
    padding: 8,
    marginRight: 12,
    justifyContent: 'center',
    minWidth: 60,
    alignItems: 'center',
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
    fontSize: 14,
    color: '#555',
  },
  noAppointments: {
    textAlign: 'center',
    marginTop: 20,
    color: '#666',
  },
  buttonsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 15,
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
    marginLeft: 10,
  },
  buttonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 16,
    marginLeft: 8,
  },
  // Estilos para o botão temporário de teste do modelo 3D
  testModelButton: {
    backgroundColor: '#9C27B0', // Cor roxa para destacar
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 14,
    borderRadius: 8,
    marginBottom: 15,
    elevation: 3,
    shadowColor: "#000",
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
  },
  testButtonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 16,
    marginLeft: 8,
  },
});