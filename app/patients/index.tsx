import React, { useEffect, useState } from 'react';
import { collection, getDocs } from 'firebase/firestore';
import { db } from '../../src/services/firebase';
import { Patient } from '../../components/interfaces/interfaces.firestore';
import { YStack, H1, Button, Separator, Paragraph } from 'tamagui';

export default function PatientsScreen() {
  const [patients, setPatients] = useState<Patient[]>([]);

  useEffect(() => {
    const fetchPatients = async () => {
      try {
        const querySnapshot = await getDocs(collection(db, 'patients'));
        const patientsData = querySnapshot.docs.map((doc) => ({
          id: doc.id,
          ...doc.data(),
        })) as Patient[];
        setPatients(patientsData);
      } catch (error) {
        console.error('Erro ao buscar pacientes:', error);
      }
    };

    fetchPatients();
  }, []);

  return (
    <YStack flex={1} padding="$4" space="$4">
      <H1>Pacientes</H1>
      <Separator />
      {patients.map((patient) => (
        <YStack key={patient.id} space="$2">
          <Paragraph>Nome: {patient.name}</Paragraph>
          <Button onPress={() => console.log(`Detalhes de ${patient.name}`)}>Ver Detalhes</Button>
        </YStack>
      ))}
    </YStack>
  );
}