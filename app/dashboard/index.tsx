import React from 'react';
import { useRouter } from 'expo-router';
import { YStack, H1, Button, Separator } from 'tamagui';

export default function DashboardScreen() {
  const router = useRouter();

  return (
    <YStack flex={1} padding="$4" space="$4" justifyContent="center" alignItems="center">
      <H1>Dashboard</H1>
      <Separator />
      <Button
        size="$4"
        theme="primary"
        onPress={() => router.push('/patients')}
      >
        Ir para Pacientes
      </Button>
      <Button
        size="$4"
        theme="secondary"
        onPress={() => router.push('/patients/add')}
      >
        Adicionar Paciente
      </Button>
      <Button
        size="$4"
        theme="primary"
        onPress={() => router.push('/firebase-test')}
      >
        Testar Firebase
      </Button>
    </YStack>
  );
}