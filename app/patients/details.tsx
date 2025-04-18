import React, { useEffect, useState } from 'react';
import { ActivityIndicator, Alert } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { doc, getDoc } from 'firebase/firestore';
import { db } from '../../src/services/firebase';
import { Patient } from '../../components/interfaces/interfaces.firestore';
import { YStack, H1, H2, Button, Separator, Paragraph } from 'tamagui';

export default function PatientDetailsScreen() {
  const { id } = useLocalSearchParams();
  const [patient, setPatient] = useState<Patient | null>(null);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  useEffect(() => {
    const fetchPatient = async () => {
      if (typeof id !== 'string') {
        console.error('ID inválido');
        setLoading(false);
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
      } finally {
        setLoading(false);
      }
    };

    fetchPatient();
  }, [id]);

  if (loading) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center">
        <ActivityIndicator size="large" color="#0000ff" />
        <Paragraph>Carregando...</Paragraph>
      </YStack>
    );
  }

  if (!patient) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center">
        <H1>Paciente não encontrado</H1>
      </YStack>
    );
  }

  return (
    <YStack flex={1} padding="$4" space="$4">
      <H1>Detalhes do Paciente</H1>
      <Separator />
      <H2>Nome: {patient.name}</H2>
      <Paragraph>Idade: {patient.age}</Paragraph>
      <Paragraph>Peso: {patient.weight} kg</Paragraph>
      <Paragraph>Gênero: {patient.gender}</Paragraph>
      <Paragraph>Comorbidades: {patient.comorbidities.join(', ')}</Paragraph>
      <Paragraph>Medicações: {patient.medications.join(', ')}</Paragraph>
      <Button onPress={() => router.push(`/patients/add-wound?id=${id}`)}>Cadastrar Lesão</Button>
    </YStack>
  );
}