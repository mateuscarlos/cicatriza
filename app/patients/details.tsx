import { useEffect, useState } from 'react';
import { View, Text, Button, StyleSheet, ActivityIndicator, Alert } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { doc, getDoc, deleteDoc } from 'firebase/firestore';
import { db } from '../../src/services/firebase';
import { Patient } from '../../components/interfaces/interfaces.firestore';

export default function PatientDetailsScreen() {
  const { id } = useLocalSearchParams();
  const [patient, setPatient] = useState<Patient | null>(null);
  const [loading, setLoading] = useState(true); // Estado para carregamento
  const [deleting, setDeleting] = useState(false); // Estado para exclusão
  const router = useRouter();

  useEffect(() => {
    const fetchPatient = async () => {
      if (typeof id !== 'string') {
        console.error('Invalid ID provided');
        setLoading(false);
        return;
      }
      try {
        const docRef = doc(db, 'patients', id);
        const docSnap = await getDoc(docRef);

        if (docSnap.exists()) {
          setPatient(docSnap.data() as Patient);
        } else {
          console.log('Paciente não encontrado!');
          Alert.alert('Erro', 'Paciente não encontrado!');
        }
      } catch (error) {
        console.error('Erro ao buscar paciente:', error);
        Alert.alert('Erro', 'Não foi possível carregar os dados do paciente.');
      } finally {
        setLoading(false);
      }
    };

    if (id) {
      fetchPatient();
    }
  }, [id]);

  const handleDeletePatient = async () => {
    if (typeof id !== 'string') return;

    Alert.alert(
      'Confirmar Exclusão',
      'Tem certeza de que deseja excluir este paciente?',
      [
        { text: 'Cancelar', style: 'cancel' },
        {
          text: 'Excluir',
          style: 'destructive',
          onPress: async () => {
            setDeleting(true);
            try {
              const docRef = doc(db, 'patients', id);
              await deleteDoc(docRef);

              // Adicionando intervalo de 300ms antes de redirecionar
              setTimeout(() => {
                Alert.alert('Sucesso', 'Paciente excluído com sucesso!', [
                  {
                    text: 'OK',
                    onPress: () => router.push('/patients'), // Redirecionar para a listagem
                  },
                ]);
              }, 300);
            } catch (error) {
              console.error('Erro ao excluir paciente:', error);
              Alert.alert('Erro', 'Não foi possível excluir o paciente.');
            } finally {
              setDeleting(false);
            }
          },
        },
      ]
    );
  };

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#0000ff" />
        <Text>Carregando...</Text>
      </View>
    );
  }

  if (!patient) {
    return (
      <View style={styles.container}>
        <Text style={styles.title}>Paciente não encontrado</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Detalhes do Paciente</Text>
      <Text>Nome: {patient.name}</Text>
      <Text>Idade: {patient.age}</Text>
      <Text>Peso: {patient.weight} kg</Text>
      <Text>Gênero: {patient.gender}</Text>
      <Text>Comorbidades: {patient.comorbidities.join(', ')}</Text>
      <Text>Medicações: {patient.medications.join(', ')}</Text>
      <Button title="Editar Paciente" onPress={() => router.push(`/patients/edit?id=${id}`)} />
      <Button
        title={deleting ? 'Excluindo...' : 'Excluir Paciente'}
        onPress={handleDeletePatient}
        color="red"
        disabled={deleting}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
  },
});