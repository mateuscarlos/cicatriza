import { View, Text, StyleSheet } from 'react-native';

export default function LesionsScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Lesões do Paciente</Text>
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