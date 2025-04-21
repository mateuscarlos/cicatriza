import React, { useState } from 'react';
import { StyleSheet, View, TouchableOpacity, ScrollView } from 'react-native';
import { useRouter } from 'expo-router';
import { ThemedText } from '../../components/ThemedText';
import { ThemedView } from '../../components/ThemedView';
import { TextInput } from 'react-native-gesture-handler';
import { MaterialIcons } from '@expo/vector-icons';

export default function PatientRegisterScreen() {
  const router = useRouter();
  const [formData, setFormData] = useState({
    name: '',
    age: '',
    gender: '',
    condition: '',
    notes: '',
  });
  const [errors, setErrors] = useState({});

  const handleChange = (field, value) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    // Limpar erro do campo quando o usuário começa a digitar
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: null }));
    }
  };

  const validate = () => {
    const newErrors = {};
    
    if (!formData.name.trim()) {
      newErrors.name = 'Nome é obrigatório';
    }
    
    if (!formData.age.trim()) {
      newErrors.age = 'Idade é obrigatória';
    } else if (isNaN(Number(formData.age))) {
      newErrors.age = 'Idade deve ser um número';
    }
    
    if (!formData.condition.trim()) {
      newErrors.condition = 'Condição é obrigatória';
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = () => {
    if (!validate()) return;
    
    // Aqui você enviaria os dados para sua API
    console.log('Dados do paciente:', formData);
    
    // Simulando sucesso no registro
    alert('Paciente cadastrado com sucesso!');
    
    // Voltar para a tela inicial
    router.back();
  };

  return (
    <ThemedView style={styles.container}>
      <ScrollView showsVerticalScrollIndicator={false}>
        <View style={styles.header}>
          <ThemedText type="title">Cadastrar Novo Paciente</ThemedText>
          <ThemedText style={styles.subtitle}>
            Preencha os dados do paciente abaixo
          </ThemedText>
        </View>
        
        <View style={styles.form}>
          <View style={styles.fieldContainer}>
            <ThemedText style={styles.label}>Nome completo*</ThemedText>
            <TextInput 
              style={[styles.input, errors.name && styles.inputError]}
              value={formData.name}
              onChangeText={(text) => handleChange('name', text)}
              placeholder="Nome do paciente"
            />
            {errors.name && <ThemedText style={styles.errorText}>{errors.name}</ThemedText>}
          </View>
          
          <View style={styles.fieldContainer}>
            <ThemedText style={styles.label}>Idade*</ThemedText>
            <TextInput 
              style={[styles.input, errors.age && styles.inputError]}
              value={formData.age}
              onChangeText={(text) => handleChange('age', text)}
              placeholder="Idade"
              keyboardType="numeric"
            />
            {errors.age && <ThemedText style={styles.errorText}>{errors.age}</ThemedText>}
          </View>
          
          <View style={styles.fieldContainer}>
            <ThemedText style={styles.label}>Gênero</ThemedText>
            <TextInput 
              style={styles.input}
              value={formData.gender}
              onChangeText={(text) => handleChange('gender', text)}
              placeholder="Gênero"
            />
          </View>
          
          <View style={styles.fieldContainer}>
            <ThemedText style={styles.label}>Condição/Diagnóstico*</ThemedText>
            <TextInput 
              style={[styles.input, errors.condition && styles.inputError]}
              value={formData.condition}
              onChangeText={(text) => handleChange('condition', text)}
              placeholder="Ex: Úlcera Venosa, Queimadura, etc."
            />
            {errors.condition && <ThemedText style={styles.errorText}>{errors.condition}</ThemedText>}
          </View>
          
          <View style={styles.fieldContainer}>
            <ThemedText style={styles.label}>Observações</ThemedText>
            <TextInput 
              style={[styles.input, styles.textArea]}
              value={formData.notes}
              onChangeText={(text) => handleChange('notes', text)}
              placeholder="Informações adicionais relevantes"
              multiline
              numberOfLines={4}
              textAlignVertical="top"
            />
          </View>
        </View>
        
        <View style={styles.buttonsContainer}>
          <TouchableOpacity 
            style={styles.cancelButton} 
            onPress={() => router.back()}
          >
            <ThemedText style={styles.cancelButtonText}>Cancelar</ThemedText>
          </TouchableOpacity>
          
          <TouchableOpacity 
            style={styles.submitButton} 
            onPress={handleSubmit}
          >
            <MaterialIcons name="save" size={20} color="white" />
            <ThemedText style={styles.submitButtonText}>Salvar</ThemedText>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  header: {
    paddingVertical: 16,
    marginBottom: 16,
  },
  subtitle: {
    color: '#666',
    marginTop: 4,
  },
  form: {
    backgroundColor: '#f8f8f8',
    borderRadius: 8,
    padding: 16,
    marginBottom: 20,
  },
  fieldContainer: {
    marginBottom: 16,
  },
  label: {
    fontWeight: 'bold',
    marginBottom: 6,
  },
  input: {
    backgroundColor: 'white',
    paddingHorizontal: 12,
    paddingVertical: 10,
    borderRadius: 5,
    borderWidth: 1,
    borderColor: '#ddd',
  },
  inputError: {
    borderColor: 'red',
  },
  errorText: {
    color: 'red',
    fontSize: 12,
    marginTop: 4,
  },
  textArea: {
    height: 100,
    paddingTop: 10,
  },
  buttonsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 30,
  },
  cancelButton: {
    flex: 1,
    alignItems: 'center',
    padding: 14,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#ddd',
    marginRight: 8,
  },
  cancelButtonText: {
    fontWeight: 'bold',
  },
  submitButton: {
    flex: 2,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#34A853',
    padding: 14,
    borderRadius: 8,
    marginLeft: 8,
  },
  submitButtonText: {
    color: 'white',
    fontWeight: 'bold',
    marginLeft: 8,
  },
});