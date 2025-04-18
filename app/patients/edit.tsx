import React, { useEffect, useState } from 'react';
import { Alert } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { doc, getDoc, updateDoc } from 'firebase/firestore';
import { db } from '../../src/services/firebase';
import { Patient } from '../../components/interfaces/interfaces.firestore';
import { YStack, Input, Button, Label, H1, Separator } from 'tamagui';

export default function EditPatientScreen() {
  const { id } = useLocalSearchParams();
  const [patient, setPatient] = useState<Patient | null>(null);
  const router = useRouter();

  useEffect(() => {
    const fetchPatient = async () => {
      if (typeof id !== 'string') {
        console.error('ID inválido');
        return;
      }
      try {
        const docRef = doc(db, 'patients', id);
        const docSnap = await getDoc(docRef);

        if (docSnap.exists()) {
          setPatient(docSnap.data() as Patient);
        } else {
          Alert.alert('Erro', 'Paciente não encontrado!');
        }
      } catch (error) {
        console.error('Erro ao buscar paciente:', error);
        Alert.alert('Erro', 'Não foi possível carregar os dados do paciente.');
      }
    };

    fetchPatient();
  }, [id]);

  const handleUpdatePatient = async () => {
    if (!patient || typeof id !== 'string') return;

    try {
      const docRef = doc(db, 'patients', id);
      await updateDoc(docRef, { ...patient });
      Alert.alert('Sucesso', 'Paciente atualizado com sucesso!');
      router.push(`/patients/details?id=${id}`);
    } catch (error) {
      console.error('Erro ao atualizar paciente:', error);
      Alert.alert('Erro', 'Não foi possível salvar as alterações.');
    }
  };

  if (!patient) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center">
        <H1>Carregando...</H1>
      </YStack>
    );
  }

  return (
    <YStack flex={1} padding="$4" space="$4">
      <H1>Editar Paciente</H1>
      <Separator />
      <Label htmlFor="name">Nome</Label>
      <Input
        id="name"
        placeholder="Nome"
        value={patient.name}
        onChangeText={(text) => setPatient({ ...patient, name: text })}
      />
      <Label htmlFor="age">Idade</Label>
      <Input
        id="age"
        placeholder="Idade"
        keyboardType="numeric"
        value={patient.age.toString()}
        onChangeText={(text) => setPatient({ ...patient, age: parseInt(text) || 0 })}
      />
      <Button onPress={handleUpdatePatient}>Salvar Alterações</Button>
    </YStack>
  );
}