import { useEffect, useState } from 'react';
import { View, Text, TextInput, Button, StyleSheet, Alert } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { doc, getDoc, updateDoc } from 'firebase/firestore';
import { db } from '../../src/services/firebase';
import { Patient } from '../../components/interfaces/interfaces.firestore';

export default function EditPatientScreen() {
  const { id } = useLocalSearchParams();
  const [patient, setPatient] = useState<Patient | null>(null);
  const router = useRouter();

  useEffect(() => {
    const fetchPatient = async () => {
      if (typeof id !== 'string') {
        console.error('Invalid ID provided');
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
      }
    };

    if (id) {
      fetchPatient();
    }
  }, [id]);

  const handleUpdatePatient = async () => {
    if (!patient || typeof id !== 'string') return;

    Alert.alert(
      'Confirmar Alterações',
      'Tem certeza de que deseja salvar as alterações?',
      [
        { text: 'Cancelar', style: 'cancel' },
        {
          text: 'Salvar',
          onPress: async () => {
            try {
              const docRef = doc(db, 'patients', id);
              await updateDoc(docRef, { ...patient });

              // Adicionando intervalo de 300ms antes de exibir o próximo alerta
              setTimeout(() => {
                Alert.alert('Sucesso', 'Paciente atualizado com sucesso!', [
                  {
                    text: 'OK',
                    onPress: () => router.push('/patients'), // Redirecionar para a listagem
                  },
                ]);
              }, 300);
            } catch (error) {
              console.error('Erro ao atualizar paciente:', error);
              Alert.alert('Erro', 'Não foi possível salvar as alterações.');
            }
          },
        },
      ]
    );
  };

  if (!patient) {
    return (
      <View style={styles.container}>
        <Text style={styles.title}>Carregando...</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Editar Paciente</Text>
      <TextInput
        style={styles.input}
        placeholder="Nome"
        value={patient.name}
        onChangeText={(text) => setPatient({ ...patient, name: text })}
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
        placeholder="Peso"
        keyboardType="numeric"
        value={patient.weight.toString()}
        onChangeText={(text) => setPatient({ ...patient, weight: parseFloat(text) || 0 })}
      />
      <TextInput
        style={styles.input}
        placeholder="Comorbidades (separadas por vírgula)"
        value={patient.comorbidities.join(', ')}
        onChangeText={(text) =>
          setPatient({ ...patient, comorbidities: text.split(',').map((item) => item.trim()) })
        }
      />
      <TextInput
        style={styles.input}
        placeholder="Medicações (separadas por vírgula)"
        value={patient.medications.join(', ')}
        onChangeText={(text) =>
          setPatient({ ...patient, medications: text.split(',').map((item) => item.trim()) })
        }
      />
      <Button title="Salvar Alterações" onPress={handleUpdatePatient} />
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