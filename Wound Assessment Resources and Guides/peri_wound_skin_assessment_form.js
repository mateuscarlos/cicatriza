import React, { useState } from 'react';
import { View, StyleSheet, Text, ScrollView, TextInput, Switch } from 'react-native';
import { Button, Card } from '@ui-kitten/components';

/**
 * Componente de formulário para avaliação da pele perilesão
 * 
 * Este componente implementa o formulário de avaliação da pele perilesão
 * baseado na metodologia do Triângulo de Avaliação de Feridas.
 * 
 * @param {Object} initialData - Dados iniciais para o formulário (opcional)
 * @param {Function} onSave - Função chamada quando o formulário é salvo
 * @returns {React.Component} Componente de formulário
 */
const PeriWoundSkinAssessmentForm = ({ initialData = {}, onSave }) => {
  // Estado para armazenar os dados do formulário
  const [formData, setFormData] = useState({
    maceration: {
      present: initialData.maceration?.present || false,
      extension: initialData.maceration?.extension || 0,
    },
    excoriation: {
      present: initialData.excoriation?.present || false,
      extension: initialData.excoriation?.extension || 0,
    },
    drySkin: {
      present: initialData.drySkin?.present || false,
      extension: initialData.drySkin?.extension || 0,
    },
    hyperkeratosis: {
      present: initialData.hyperkeratosis?.present || false,
      extension: initialData.hyperkeratosis?.extension || 0,
    },
    callus: {
      present: initialData.callus?.present || false,
      extension: initialData.callus?.extension || 0,
    },
    eczema: {
      present: initialData.eczema?.present || false,
      extension: initialData.eczema?.extension || 0,
    },
  });

  // Função para atualizar os dados de uma condição específica
  const updateCondition = (condition, field, value) => {
    setFormData({
      ...formData,
      [condition]: {
        ...formData[condition],
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

  // Renderiza um item de condição da pele
  const renderConditionItem = (condition, title, description) => {
    const conditionData = formData[condition];
    
    return (
      <View style={styles.section}>
        <View style={styles.switchContainer}>
          <Text style={styles.label}>{title}</Text>
          <Text style={styles.helperText}>{description}</Text>
          <Switch
            value={conditionData.present}
            onValueChange={(value) => updateCondition(condition, 'present', value)}
          />
        </View>
        
        {conditionData.present && (
          <View style={styles.extensionContainer}>
            <Text style={styles.label}>Extensão (cm)</Text>
            <Text style={styles.helperText}>
              Distância da borda da ferida até onde a condição se estende (até 4cm)
            </Text>
            <TextInput
              style={styles.textInput}
              keyboardType="numeric"
              value={conditionData.extension.toString()}
              onChangeText={(value) => updateCondition(condition, 'extension', parseFloat(value) || 0)}
              placeholder="Ex: 2.5"
            />
          </View>
        )}
      </View>
    );
  };

  return (
    <ScrollView style={styles.container}>
      <Card style={styles.card}>
        <Text style={styles.sectionTitle}>Avaliação da Pele Perilesão</Text>
        <Text style={styles.helperText}>
          A pele perilesão é definida como a pele dentro de 4 cm da borda da ferida, 
          ou qualquer pele sob o curativo. Problemas na pele perilesão podem atrasar a cicatrização, 
          causar dor e desconforto para o paciente.
        </Text>
        
        {/* Maceração */}
        {renderConditionItem(
          'maceration',
          'Maceração',
          'Amolecimento da pele como resultado do contato prolongado com a umidade. Pele macerada de aspecto esbranquiçado.'
        )}
        
        {/* Escoriação */}
        {renderConditionItem(
          'excoriation',
          'Escoriação',
          'Causada por lesões repetidas na superfície da pele causada por trauma, por exemplo, arranhões, abrasão, reações a medicamentos ou irritantes.'
        )}
        
        {/* Pele Seca */}
        {renderConditionItem(
          'drySkin',
          'Pele Seca (Xerose)',
          'As células de queratina tornam-se planas e escamosas. A pele fica áspera e pode haver descamação visível.'
        )}
        
        {/* Hiperqueratose */}
        {renderConditionItem(
          'hyperkeratosis',
          'Hiperqueratose',
          'Acúmulo excessivo de pele seca (queratina), muitas vezes nas mãos, calcanhares e solas dos pés.'
        )}
        
        {/* Calo */}
        {renderConditionItem(
          'callus',
          'Calo',
          'Parte da pele ou tecido mole engrossado e endurecido, especialmente em uma área que foi submetida a fricção ou pressão.'
        )}
        
        {/* Eczema */}
        {renderConditionItem(
          'eczema',
          'Eczema',
          'Inflamação da pele, caracterizada por coceira, pele vermelha e erupção na pele.'
        )}
        
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
  extensionContainer: {
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

export default PeriWoundSkinAssessmentForm;
