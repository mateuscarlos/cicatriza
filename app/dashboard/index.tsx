import { View, Text, Button, StyleSheet } from 'react-native';
import { useRouter } from 'expo-router';

export default function DashboardScreen() {
  const router = useRouter();

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Dashboard</Text>
      <Button
        title="Ir para Pacientes"
        onPress={() => router.push('/patients')}
      />
      <Button
        title="Adicionar Paciente"
        onPress={() => router.push('/patients/add')}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 16,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
  },
});