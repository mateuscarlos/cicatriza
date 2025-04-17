import { Stack } from 'expo-router';

export default function PatientsLayout() {
  return (
    <Stack>
      <Stack.Screen name="index" options={{ title: 'Pacientes' }} />
      <Stack.Screen name="details" options={{ title: 'Detalhes do Paciente' }} />
      <Stack.Screen name="history" options={{ title: 'Histórico' }} />
      <Stack.Screen name="lesions" options={{ title: 'Lesões' }} />
    </Stack>
  );
}