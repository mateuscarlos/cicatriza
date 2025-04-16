import { View, Text, StyleSheet } from 'react-native';

export default function PatientDetailsScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Detalhes do Paciente</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
  },
});