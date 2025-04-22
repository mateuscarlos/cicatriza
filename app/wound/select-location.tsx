import React, { useState } from 'react';
import { View, TouchableOpacity, StyleSheet } from 'react-native';
import { ThemedText } from '../../components/ThemedText';
import { ThemedView } from '../../components/ThemedView';
import Human3DModel from './Human3DModel';
import { useRouter } from 'expo-router';

export default function SelectWoundLocationScreen() {
  const [gender, setGender] = useState<'male' | 'female'>('male');
  const [selectedPoint, setSelectedPoint] = useState<{ x: number; y: number; z: number } | null>(null);
  const router = useRouter();

  const handleModelPress = (point) => {
    setSelectedPoint(point);
  };

  const handleConfirm = () => {
    if (selectedPoint) {
      // Passe os dados para o fluxo de cadastro de lesão
      router.push({
        pathname: '/wound/register',
        params: { gender, ...selectedPoint },
      });
    }
  };

  return (
    <ThemedView style={styles.container}>
      <View style={styles.genderSwitch}>
        <TouchableOpacity onPress={() => setGender('male')} style={[styles.genderButton, gender === 'male' && styles.selected]}>
          <ThemedText>Masculino</ThemedText>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => setGender('female')} style={[styles.genderButton, gender === 'female' && styles.selected]}>
          <ThemedText>Feminino</ThemedText>
        </TouchableOpacity>
      </View>
      <Human3DModel
        gender={gender}
        onSelectPoint={handleModelPress}
        selectedPoint={selectedPoint}
      />
      <TouchableOpacity
        style={[styles.confirmButton, !selectedPoint && styles.disabledButton]}
        onPress={handleConfirm}
        disabled={!selectedPoint}
      >
        <ThemedText style={styles.confirmButtonText}>Cadastrar Lesão</ThemedText>
      </TouchableOpacity>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16 },
  genderSwitch: { flexDirection: 'row', justifyContent: 'center', marginBottom: 16 },
  genderButton: { padding: 12, marginHorizontal: 8, borderRadius: 8, backgroundColor: '#eee' },
  selected: { backgroundColor: '#4dabf7' },
  confirmButton: { marginTop: 24, padding: 16, borderRadius: 8, backgroundColor: '#4dabf7', alignItems: 'center' },
  disabledButton: { backgroundColor: '#a0a0a0', opacity: 0.7 },
  confirmButtonText: { color: 'white', fontWeight: 'bold' },
});