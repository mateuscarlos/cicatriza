import { Stack } from 'expo-router';

export default function PatientsLayout() {
  return (
    <Stack>
      <Stack.Screen name="index" options={{ title: 'Pacientes' }} />
      <Stack.Screen name="add" options={{ title: 'Adicionar Paciente' }} />
      <Stack.Screen name="add-wound" options={{ title: 'Cadastrar Lesão' }} />
      <Stack.Screen name="bodyparts" options={{ title: 'Partes do Corpo' }} />
    </Stack>
  );
}