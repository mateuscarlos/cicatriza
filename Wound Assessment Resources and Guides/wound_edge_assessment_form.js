import React, { useState } from 'react';
import { View, StyleSheet, Text, ScrollView, TextInput, TouchableOpacity, Switch } from 'react-native';
import { Input, Button, CheckBox, Card } from '@ui-kitten/components';

/**
 * Componente de formulário para avaliação da borda da ferida
 * 
 * Este componente implementa o formulário de avaliação da borda da ferida
 * baseado na metodologia do Triângulo de Avaliação de Feridas.
 * 
 * @param {Object} initialData - Dados iniciais para o formulário (opcional)
 * @param {Function} onSave - Função chamada quando o formulário é salvo
 * @returns {React.Component} Componente de formulário
 */
const WoundEdgeAssessmentForm = ({ initialData = {}, onSave }) => {
  // Estado para armazenar os dados do formulário
  const [formData, setFormData] = useState({
    maceration: initialData.maceration || false,
    dehydration: initialData.dehydration || false,
    undermining: {
      present: initialData.undermining?.present || false,
      position: initialData.undermining?.position || '',
      extension: initialData.undermining?.extension || 0,
    },
    epibole: initialData.epibole || false,
  });

  // Função para atualizar os dados do formulário
  const updateFormData = (field, value) => {
    setFormData({
      ...formData,
      [field]: value
    });
  };

  // Função para atualizar os dados de descolamento
  const updateUndermining = (field, value) => {
    setFormData({
      ...formData,
      undermining: {
        ...formData.undermining,
        [field]: value
      }
    });
  };

  // Função para salvar o formulário
  const handleSave = () => {
    if (onSave) {
      onSave(formData);
    }
  };

  return (
    <ScrollView style={styles.container}>
      <Card style={styles.card}>
        <Text style={styles.sectionTitle}>Avaliação da Borda da Ferida</Text>
        
        {/* Maceração */}
        <View style={styles.section}>
          <View style={styles.switchContainer}>
            <Text style={styles.label}>Maceração</Text>
            <Text style={styles.helperText}>
              Amolecimento e ruptura do tecido na borda da ferida resultante da exposição prolongada à umidade e exsudato. Frequentemente com aspecto esbranquiçado.
            </Text>
            <Switch
              value={formData.maceration}
              onValueChange={(value) => updateFormData('maceration', value)}
            />
          </View>
        </View>
        
        {/* Desidratação */}
        <View style={styles.section}>
          <View style={styles.switchContainer}>
            <Text style={styles.label}>Desidratação</Text>
            <Text style={styles.helperText}>
              Baixa umidade prejudicando o desenvolvimento celular e a migração necessária para o crescimento de novos tecidos.
            </Text>
            <Switch
              value={formData.dehydration}
              onValueChange={(value) => updateFormData('dehydration', value)}
            />
          </View>
        </View>
        
        {/* Descolamento */}
        <View style={styles.section}>
          <View style={styles.switchContainer}>
            <Text style={styles.label}>Descolamento</Text>
            <Text style={styles.helperText}>
              A destruição do tecido ou ulceração que se estende sob a borda da ferida de modo que a lesão é maior em sua base do que na superfície da pele.
            </Text>
            <Switch
              value={formData.undermining.present}
              onValueChange={(value) => updateUndermining('present', value)}
            />
          </View>
          
          {formData.undermining.present && (
            <View style={styles.underminingSectionContainer}>
              <Text style={styles.label}>Posição do descolamento</Text>
              <Text style={styles.helperText}>Use posições do relógio para registrar localização (ex: 1h, 3h, 6h)</Text>
              <TextInput
                style={styles.textInput}
                value={formData.undermining.position}
                onChangeText={(value) => updateUndermining('position', value)}
                placeholder="Ex: 3h-6h"
              />
              
              <Text style={styles.label}>Extensão do descolamento (cm)</Text>
              <TextInput
                style={styles.textInput}
                keyboardType="numeric"
                value={formData.undermining.extension.toString()}
                onChangeText={(value) => updateUndermining('extension', parseFloat(value) || 0)}
                placeholder="Ex: 2.5"
              />
            </View>
          )}
        </View>
        
        {/* Epíbole */}
        <View style={styles.section}>
          <View style={styles.switchContainer}>
            <Text style={styles.label}>Epíbole (borda enrolada)</Text>
            <Text style={styles.helperText}>
              O enrolamento das bordas ocorre quando o tecido epitelial migra para os lados da ferida ao invés de cruzá-lo. Pode se apresentar em feridas com origem inflamatória, inclusive no câncer, e pode resultar em cicatrização insatisfatória se não tratada de forma adequada.
            </Text>
            <Switch
              value={formData.epibole}
              onValueChange={(value) => updateFormData('epibole', value)}
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
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
    paddingBottom: 15,
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
  switchContainer: {
    flexDirection: 'column',
    marginBottom: 10,
  },
  underminingSectionContainer: {
    marginTop: 10,
    paddingLeft: 15,
    borderLeftWidth: 2,
    borderLeftColor: '#3366FF',
  },
  textInput: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 5,
    padding: 10,
    marginBottom: 15,
  },
  saveButton: {
    marginTop: 20,
  },
});

export default WoundEdgeAssessmentForm;
