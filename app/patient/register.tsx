import React, { useState } from 'react';
import { StyleSheet, View, TouchableOpacity, ScrollView, Switch, Platform } from 'react-native';
import { useRouter } from 'expo-router';
import { ThemedText } from '../../components/ThemedText';
import { ThemedView } from '../../components/ThemedView';
import { TextInput } from 'react-native-gesture-handler';
import { MaterialIcons } from '@expo/vector-icons';
import { Picker } from '@react-native-picker/picker';

export default function PatientRegisterScreen() {
  const router = useRouter();
  const [formData, setFormData] = useState({
    name: '',
    identification: '',
    age: '',
    weight: '',
    gender: '',
    nutritionalStatus: 'Bom',
    mobility: 'Normal',
    isSmoker: false,
    cigarettesPerDay: '',
    alcoholConsumption: false,
    alcoholUnitsPerWeek: '',
    comorbidities: '',
    medications: '',
    allergies: '',
    address: '',
  });

  const [errors, setErrors] = useState({});

  const handleChange = (field, value) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
    // Limpar erro do campo quando o usuário começa a digitar
    if (errors[field]) {
      setErrors((prev) => ({ ...prev, [field]: null }));
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

    if (formData.weight && isNaN(Number(formData.weight))) {
      newErrors.weight = 'Peso deve ser um número';
    }

    if (formData.isSmoker && !formData.cigarettesPerDay.trim()) {
      newErrors.cigarettesPerDay = 'Quantidade de cigarros é obrigatória';
    }

    if (formData.alcoholConsumption && !formData.alcoholUnitsPerWeek.trim()) {
      newErrors.alcoholUnitsPerWeek = 'Quantidade de álcool é obrigatória';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = () => {
    if (!validate()) return;

    // Aqui você enviaria os dados para sua API/Firestore
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
          <ThemedText style={styles.subtitle}>Preencha os dados do paciente abaixo</ThemedText>
        </View>

        <View style={styles.form}>
          <ThemedText style={styles.sectionTitle}>Informações Pessoais</ThemedText>

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
            <ThemedText style={styles.label}>Identificação do Paciente</ThemedText>
            <TextInput
              style={styles.input}
              value={formData.identification}
              onChangeText={(text) => handleChange('identification', text)}
              placeholder="CPF ou outro documento"
            />
          </View>

          <View style={styles.rowContainer}>
            <View style={[styles.fieldContainer, { flex: 1, marginRight: 8 }]}>
              <ThemedText style={styles.label}>Idade* (anos)</ThemedText>
              <TextInput
                style={[styles.input, errors.age && styles.inputError]}
                value={formData.age}
                onChangeText={(text) => handleChange('age', text)}
                placeholder="Idade"
                keyboardType="numeric"
              />
              {errors.age && <ThemedText style={styles.errorText}>{errors.age}</ThemedText>}
            </View>

            <View style={[styles.fieldContainer, { flex: 1, marginLeft: 8 }]}>
              <ThemedText style={styles.label}>Peso (kg)</ThemedText>
              <TextInput
                style={[styles.input, errors.weight && styles.inputError]}
                value={formData.weight}
                onChangeText={(text) => handleChange('weight', text)}
                placeholder="Peso"
                keyboardType="numeric"
              />
              {errors.weight && <ThemedText style={styles.errorText}>{errors.weight}</ThemedText>}
            </View>
          </View>

          <View style={styles.fieldContainer}>
            <ThemedText style={styles.label}>Gênero</ThemedText>
            <View style={styles.pickerContainer}>
              <Picker
                selectedValue={formData.gender}
                onValueChange={(value) => handleChange('gender', value)}
                style={styles.picker}
              >
                <Picker.Item label="Selecione" value="" />
                <Picker.Item label="Masculino" value="Masculino" />
                <Picker.Item label="Feminino" value="Feminino" />
                <Picker.Item label="Outro" value="Outro" />
              </Picker>
            </View>
          </View>

          <View style={styles.fieldContainer}>
            <ThemedText style={styles.label}>Endereço</ThemedText>
            <TextInput
              style={[styles.input, styles.textArea]}
              value={formData.address}
              onChangeText={(text) => handleChange('address', text)}
              placeholder="Endereço completo"
              multiline
              numberOfLines={2}
              textAlignVertical="top"
            />
          </View>

          <ThemedText style={[styles.sectionTitle, { marginTop: 20 }]}>
            Informações Médicas
          </ThemedText>

          <View style={styles.fieldContainer}>
            <ThemedText style={styles.label}>Estado Nutricional</ThemedText>
            <View style={styles.pickerContainer}>
              <Picker
                selectedValue={formData.nutritionalStatus}
                onValueChange={(value) => handleChange('nutritionalStatus', value)}
                style={styles.picker}
              >
                <Picker.Item label="Bom" value="Bom" />
                <Picker.Item label="Ruim" value="Ruim" />
              </Picker>
            </View>
          </View>

          <View style={styles.fieldContainer}>
            <ThemedText style={styles.label}>Mobilidade</ThemedText>
            <View style={styles.pickerContainer}>
              <Picker
                selectedValue={formData.mobility}
                onValueChange={(value) => handleChange('mobility', value)}
                style={styles.picker}
              >
                <Picker.Item label="Normal" value="Normal" />
                <Picker.Item label="Baixa" value="Baixa" />
                <Picker.Item label="Nenhuma" value="Nenhuma" />
              </Picker>
            </View>
          </View>

          <View style={styles.switchFieldContainer}>
            <ThemedText style={styles.label}>Fumante</ThemedText>
            <Switch
              value={formData.isSmoker}
              onValueChange={(value) => {
                handleChange('isSmoker', value);
                if (!value) handleChange('cigarettesPerDay', '');
              }}
              trackColor={{ false: '#d3d3d3', true: '#34A853' }}
            />
          </View>

          {formData.isSmoker && (
            <View style={[styles.fieldContainer, { marginLeft: 30, marginTop: -5 }]}>
              <ThemedText style={styles.label}>Cigarros por dia*</ThemedText>
              <TextInput
                style={[styles.input, errors.cigarettesPerDay && styles.inputError]}
                value={formData.cigarettesPerDay}
                onChangeText={(text) => handleChange('cigarettesPerDay', text)}
                placeholder="Quantidade"
                keyboardType="numeric"
              />
              {errors.cigarettesPerDay && (
                <ThemedText style={styles.errorText}>{errors.cigarettesPerDay}</ThemedText>
              )}
            </View>
          )}

          <View style={styles.switchFieldContainer}>
            <ThemedText style={styles.label}>Consumo de Álcool</ThemedText>
            <Switch
              value={formData.alcoholConsumption}
              onValueChange={(value) => {
                handleChange('alcoholConsumption', value);
                if (!value) handleChange('alcoholUnitsPerWeek', '');
              }}
              trackColor={{ false: '#d3d3d3', true: '#34A853' }}
            />
          </View>

          {formData.alcoholConsumption && (
            <View style={[styles.fieldContainer, { marginLeft: 30, marginTop: -5 }]}>
              <ThemedText style={styles.label}>Unidades/semana*</ThemedText>
              <TextInput
                style={[styles.input, errors.alcoholUnitsPerWeek && styles.inputError]}
                value={formData.alcoholUnitsPerWeek}
                onChangeText={(text) => handleChange('alcoholUnitsPerWeek', text)}
                placeholder="Quantidade"
                keyboardType="numeric"
              />
              {errors.alcoholUnitsPerWeek && (
                <ThemedText style={styles.errorText}>{errors.alcoholUnitsPerWeek}</ThemedText>
              )}
            </View>
          )}

          <View style={styles.fieldContainer}>
            <ThemedText style={styles.label}>Comorbidades</ThemedText>
            <TextInput
              style={[styles.input, styles.textArea]}
              value={formData.comorbidities}
              onChangeText={(text) => handleChange('comorbidities', text)}
              placeholder="Ex: Diabetes, Hipertensão, etc."
              multiline
              numberOfLines={2}
              textAlignVertical="top"
            />
          </View>

          <View style={styles.fieldContainer}>
            <ThemedText style={styles.label}>Medicações</ThemedText>
            <TextInput
              style={[styles.input, styles.textArea]}
              value={formData.medications}
              onChangeText={(text) => handleChange('medications', text)}
              placeholder="Medicamentos em uso"
              multiline
              numberOfLines={2}
              textAlignVertical="top"
            />
          </View>

          <View style={styles.fieldContainer}>
            <ThemedText style={styles.label}>Alergias</ThemedText>
            <TextInput
              style={[styles.input, styles.textArea]}
              value={formData.allergies}
              onChangeText={(text) => handleChange('allergies', text)}
              placeholder="Alergias conhecidas"
              multiline
              numberOfLines={2}
              textAlignVertical="top"
            />
          </View>
        </View>

        <View style={styles.buttonsContainer}>
          <TouchableOpacity style={styles.cancelButton} onPress={() => router.back()}>
            <ThemedText style={styles.cancelButtonText}>Cancelar</ThemedText>
          </TouchableOpacity>

          <TouchableOpacity style={styles.submitButton} onPress={handleSubmit}>
            <MaterialIcons name="save" size={20} color="white" />
            <ThemedText style={styles.submitButtonText}>Salvar</ThemedText>
          </TouchableOpacity>
        </View>

        <TouchableOpacity
          style={styles.woundButton}
          onPress={() => {
            if (validate()) {
              // Aqui você enviaria os dados para sua API/Firestore
              console.log('Dados do paciente:', formData);

              // Navegue para a seleção de localização da ferida
              router.push('/wound/select-location');
            }
          }}
        >
          <MaterialIcons name="add" size={20} color="white" />
          <ThemedText style={styles.woundButtonText}>Cadastrar Ferida</ThemedText>
        </TouchableOpacity>
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
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 16,
    color: '#444',
  },
  fieldContainer: {
    marginBottom: 16,
  },
  rowContainer: {
    flexDirection: 'row',
    marginBottom: 16,
  },
  switchFieldContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
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
  pickerContainer: {
    backgroundColor: 'white',
    borderRadius: 5,
    borderWidth: 1,
    borderColor: '#ddd',
    overflow: 'hidden',
  },
  picker: {
    height: Platform.OS === 'ios' ? 150 : 50,
    width: '100%',
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
    minHeight: 60,
    paddingTop: 10,
    textAlignVertical: 'top',
  },
  buttonsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 16,
  },
  cancelButton: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 14,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#ddd',
    marginRight: 8,
    backgroundColor: 'white',
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
  woundButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#4285F4',
    padding: 14,
    borderRadius: 8,
    marginBottom: 30,
  },
  woundButtonText: {
    color: 'white',
    fontWeight: 'bold',
    marginLeft: 8,
  },
});
