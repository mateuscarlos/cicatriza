import React, { useState } from 'react';
import { View, StyleSheet, Text, ScrollView, TextInput, TouchableOpacity, Switch } from 'react-native';
import { Input, Button, CheckBox, Slider, Card, Select, SelectItem } from '@ui-kitten/components';

/**
 * Componente de formulário para avaliação do leito da ferida
 * 
 * Este componente implementa o formulário de avaliação do leito da ferida
 * baseado na metodologia do Triângulo de Avaliação de Feridas.
 * 
 * @param {Object} initialData - Dados iniciais para o formulário (opcional)
 * @param {Function} onSave - Função chamada quando o formulário é salvo
 * @returns {React.Component} Componente de formulário
 */
const WoundBedAssessmentForm = ({ initialData = {}, onSave }) => {
  // Estado para armazenar os dados do formulário
  const [formData, setFormData] = useState({
    tissueType: {
      granulation: initialData.tissueType?.granulation || 0,
      necrotic: initialData.tissueType?.necrotic || 0,
      slough: initialData.tissueType?.slough || 0,
      epithelialization: initialData.tissueType?.epithelialization || 0,
    },
    exudate: {
      type: initialData.exudate?.type || '',
      level: initialData.exudate?.level || '',
      accumulation: initialData.exudate?.accumulation || false,
    },
    infection: {
      local: initialData.infection?.local || [],
      systemic: initialData.infection?.systemic || [],
      biofilm: initialData.infection?.biofilm || false,
    }
  });

  // Opções para tipo de exsudato
  const exudateTypeOptions = [
    { text: 'Fino/aquoso', value: 'thin_watery' },
    { text: 'Espesso', value: 'thick' },
    { text: 'Claro', value: 'clear' },
    { text: 'Turvo', value: 'cloudy' },
    { text: 'Rosa/vermelho', value: 'pink_red' },
    { text: 'Purulento', value: 'purulent' },
  ];

  // Opções para nível de exsudato
  const exudateLevelOptions = [
    { text: 'Seco', value: 'dry' },
    { text: 'Baixo', value: 'low' },
    { text: 'Médio', value: 'medium' },
    { text: 'Alto', value: 'high' },
  ];

  // Opções para sinais de infecção local
  const localInfectionSigns = [
    { text: 'Aumento da dor', value: 'increased_pain' },
    { text: 'Eritema', value: 'erythema' },
    { text: 'Calor local', value: 'local_warmth' },
    { text: 'Edema', value: 'edema' },
    { text: 'Aumento do exsudato', value: 'increased_exudate' },
    { text: 'Atraso na cicatrização', value: 'delayed_healing' },
    { text: 'Tecido de granulação friável', value: 'friable_granulation' },
    { text: 'Odor fétido', value: 'malodour' },
    { text: 'Tecido de granulação irregular/hipergranulação', value: 'pocketing' },
  ];

  // Opções para sinais de infecção sistêmica
  const systemicInfectionSigns = [
    { text: 'Aumento do eritema', value: 'increased_erythema' },
    { text: 'Febre (Pirexia)', value: 'pyrexia' },
    { text: 'Abscesso/pus', value: 'abscess_pus' },
    { text: 'Ruptura da ferida', value: 'wound_breakdown' },
    { text: 'Celulite', value: 'cellulitis' },
    { text: 'Mal-estar geral', value: 'general_malaise' },
    { text: 'Contagem de leucócitos elevada', value: 'raised_wbc' },
    { text: 'Linfangite', value: 'lymphangitis' },
  ];

  // Função para atualizar os dados do tipo de tecido
  const updateTissueType = (field, value) => {
    setFormData({
      ...formData,
      tissueType: {
        ...formData.tissueType,
        [field]: value
      }
    });
  };

  // Função para atualizar os dados do exsudato
  const updateExudate = (field, value) => {
    setFormData({
      ...formData,
      exudate: {
        ...formData.exudate,
        [field]: value
      }
    });
  };

  // Função para atualizar os dados de infecção
  const updateInfection = (field, value) => {
    setFormData({
      ...formData,
      infection: {
        ...formData.infection,
        [field]: value
      }
    });
  };

  // Função para alternar um item em uma lista
  const toggleListItem = (list, item) => {
    if (list.includes(item)) {
      return list.filter(i => i !== item);
    } else {
      return [...list, item];
    }
  };

  // Função para lidar com a seleção de sinais de infecção local
  const handleLocalInfectionToggle = (item) => {
    const updatedList = toggleListItem(formData.infection.local, item);
    updateInfection('local', updatedList);
  };

  // Função para lidar com a seleção de sinais de infecção sistêmica
  const handleSystemicInfectionToggle = (item) => {
    const updatedList = toggleListItem(formData.infection.systemic, item);
    updateInfection('systemic', updatedList);
  };

  // Função para validar se a soma dos percentuais de tipo de tecido é 100%
  const validateTissuePercentages = () => {
    const { granulation, necrotic, slough, epithelialization } = formData.tissueType;
    const sum = granulation + necrotic + slough + epithelialization;
    return sum === 100;
  };

  // Função para salvar o formulário
  const handleSave = () => {
    if (!validateTissuePercentages()) {
      alert('A soma dos percentuais de tipo de tecido deve ser 100%');
      return;
    }
    
    if (onSave) {
      onSave(formData);
    }
  };

  return (
    <ScrollView style={styles.container}>
      <Card style={styles.card}>
        <Text style={styles.sectionTitle}>Avaliação do Leito da Ferida</Text>
        
        {/* Tipo de Tecido */}
        <View style={styles.section}>
          <Text style={styles.subSectionTitle}>Tipo de Tecido (%)</Text>
          <Text style={styles.helperText}>A soma dos percentuais deve ser 100%</Text>
          
          <View style={styles.tissueTypeContainer}>
            <View style={styles.tissueTypeItem}>
              <Text>Granulação</Text>
              <TextInput
                style={styles.percentageInput}
                keyboardType="numeric"
                value={formData.tissueType.granulation.toString()}
                onChangeText={(value) => updateTissueType('granulation', parseInt(value) || 0)}
              />
              <Text>%</Text>
            </View>
            
            <View style={styles.tissueTypeItem}>
              <Text>Necrótico</Text>
              <TextInput
                style={styles.percentageInput}
                keyboardType="numeric"
                value={formData.tissueType.necrotic.toString()}
                onChangeText={(value) => updateTissueType('necrotic', parseInt(value) || 0)}
              />
              <Text>%</Text>
            </View>
            
            <View style={styles.tissueTypeItem}>
              <Text>Esfacelo</Text>
              <TextInput
                style={styles.percentageInput}
                keyboardType="numeric"
                value={formData.tissueType.slough.toString()}
                onChangeText={(value) => updateTissueType('slough', parseInt(value) || 0)}
              />
              <Text>%</Text>
            </View>
            
            <View style={styles.tissueTypeItem}>
              <Text>Epitelização</Text>
              <TextInput
                style={styles.percentageInput}
                keyboardType="numeric"
                value={formData.tissueType.epithelialization.toString()}
                onChangeText={(value) => updateTissueType('epithelialization', parseInt(value) || 0)}
              />
              <Text>%</Text>
            </View>
          </View>
          
          <View style={styles.totalContainer}>
            <Text>Total: {Object.values(formData.tissueType).reduce((a, b) => a + b, 0)}%</Text>
            {!validateTissuePercentages() && (
              <Text style={styles.errorText}>A soma deve ser 100%</Text>
            )}
          </View>
        </View>
        
        {/* Exsudato */}
        <View style={styles.section}>
          <Text style={styles.subSectionTitle}>Exsudato</Text>
          
          <Text style={styles.label}>Tipo</Text>
          <View style={styles.checkboxGroup}>
            {exudateTypeOptions.map((option) => (
              <CheckBox
                key={option.value}
                style={styles.checkbox}
                checked={formData.exudate.type === option.value}
                onChange={() => updateExudate('type', option.value)}
              >
                {option.text}
              </CheckBox>
            ))}
          </View>
          
          <Text style={styles.label}>Nível</Text>
          <View style={styles.checkboxGroup}>
            {exudateLevelOptions.map((option) => (
              <CheckBox
                key={option.value}
                style={styles.checkbox}
                checked={formData.exudate.level === option.value}
                onChange={() => updateExudate('level', option.value)}
              >
                {option.text}
              </CheckBox>
            ))}
          </View>
          
          <View style={styles.switchContainer}>
            <Text style={styles.label}>Acúmulo de exsudato no leito da ferida</Text>
            <Switch
              value={formData.exudate.accumulation}
              onValueChange={(value) => updateExudate('accumulation', value)}
            />
          </View>
        </View>
        
        {/* Infecção */}
        <View style={styles.section}>
          <Text style={styles.subSectionTitle}>Infecção</Text>
          
          <Text style={styles.label}>Sinais de Infecção Local</Text>
          <View style={styles.checkboxGroup}>
            {localInfectionSigns.map((sign) => (
              <CheckBox
                key={sign.value}
                style={styles.checkbox}
                checked={formData.infection.local.includes(sign.value)}
                onChange={() => handleLocalInfectionToggle(sign.value)}
              >
                {sign.text}
              </CheckBox>
            ))}
          </View>
          
          <Text style={styles.label}>Sinais de Infecção Disseminada/Sistêmica</Text>
          <View style={styles.checkboxGroup}>
            {systemicInfectionSigns.map((sign) => (
              <CheckBox
                key={sign.value}
                style={styles.checkbox}
                checked={formData.infection.systemic.includes(sign.value)}
                onChange={() => handleSystemicInfectionToggle(sign.value)}
              >
                {sign.text}
              </CheckBox>
            ))}
          </View>
          
          <View style={styles.switchContainer}>
            <Text style={styles.label}>Suspeita de Biofilme</Text>
            <Text style={styles.helperText}>(Sinais clínicos que indicam a presença de Biofilme)</Text>
            <Switch
              value={formData.infection.biofilm}
              onValueChange={(value) => updateInfection('biofilm', value)}
            />
          </View>
        </View>
        
        <Button style={styles.saveButton} onPress={handleSave}>
          Salvar e Continuar
        </Button>
      </Card>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 10,
  },
  card: {
    marginBottom: 20,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 15,
    textAlign: 'center',
  },
  section: {
    marginBottom: 20,
  },
  subSectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#3366FF',
  },
  label: {
    fontSize: 16,
    marginBottom: 5,
    fontWeight: '500',
  },
  helperText: {
    fontSize: 14,
    color: '#666',
    marginBottom: 10,
    fontStyle: 'italic',
  },
  tissueTypeContainer: {
    marginBottom: 10,
  },
  tissueTypeItem: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 10,
  },
  percentageInput: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 5,
    padding: 8,
    width: 60,
    textAlign: 'center',
  },
  totalContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: 10,
  },
  errorText: {
    color: 'red',
    fontWeight: 'bold',
  },
  checkboxGroup: {
    marginBottom: 15,
  },
  checkbox: {
    marginBottom: 10,
  },
  switchContainer: {
    flexDirection: 'column',
    marginBottom: 15,
  },
  saveButton: {
    marginTop: 20,
  },
});

export default WoundBedAssessmentForm;
