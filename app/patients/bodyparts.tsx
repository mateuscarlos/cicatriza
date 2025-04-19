import React, { useState } from 'react';
import { View, Text, Button, StyleSheet, Alert } from 'react-native';
import Svg, { Path } from 'react-native-svg';
import { useRouter, useLocalSearchParams } from 'expo-router';

export default function BodyPartsScreen() {
  const { id } = useLocalSearchParams();
  const router = useRouter();
  const [selectedPart, setSelectedPart] = useState<string | null>(null);
  const [lesions, setLesions] = useState<{ [key: string]: boolean }>({
    head: false,
    neck: false,
    chest: false,
    leftArm: false,
    rightArm: false,
    abdomen: false,
    leftLeg: false,
    rightLeg: false,
    leftFoot: false,
    rightFoot: false,
  });

  const handlePartClick = (part: string) => {
    console.log(`Parte clicada: ${part}`); // Verifica se o clique está funcionando
    setSelectedPart(part); // Atualiza a parte selecionada
  };

  const handleAddLesion = () => {
    if (selectedPart) {
      setLesions({ ...lesions, [selectedPart]: true }); // Marca a parte como tendo lesão
      Alert.alert('Sucesso', `Lesão cadastrada na parte: ${selectedPart}`);
      router.push(`/patients/add-wound?id=${id}&part=${selectedPart}`);
    }
  };

  const handleViewLesion = () => {
    Alert.alert('Acompanhamento', `Visualizando lesão na parte: ${selectedPart}`);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Selecione a Parte do Corpo</Text>
      <Svg
        width={300}
        height={600}
        viewBox="0 0 300 600"
        style={styles.svg}
      >
        {/* Cabeça */}
        <Path
          d="M140 10 C120 10, 120 50, 140 50 C160 50, 160 10, 140 10 Z"
          fill={lesions.head ? 'red' : 'gray'}
          onPress={() => {
            console.log('Cabeça clicada');
            handlePartClick('head');
          }}
        />
        {/* Pescoço */}
        <Path
          d="M130 50 L150 50 L150 70 L130 70 Z"
          fill={lesions.neck ? 'red' : 'gray'}
          onPress={() => {
            console.log('Pescoço clicado');
            handlePartClick('neck');
          }}
        />
        {/* Tórax */}
        <Path
          d="M110 70 L170 70 L170 150 L110 150 Z"
          fill={lesions.chest ? 'red' : 'gray'}
          onPress={() => {
            console.log('Tórax clicado');
            handlePartClick('chest');
          }}
        />
        {/* Braço Esquerdo */}
        <Path
          d="M80 70 L110 70 L110 150 L80 150 Z"
          fill={lesions.leftArm ? 'red' : 'gray'}
          onPress={() => {
            console.log('Braço Esquerdo clicado');
            handlePartClick('leftArm');
          }}
        />
        {/* Braço Direito */}
        <Path
          d="M170 70 L200 70 L200 150 L170 150 Z"
          fill={lesions.rightArm ? 'red' : 'gray'}
          onPress={() => {
            console.log('Braço Direito clicado');
            handlePartClick('rightArm');
          }}
        />
        {/* Abdômen */}
        <Path
          d="M110 150 L170 150 L170 250 L110 250 Z"
          fill={lesions.abdomen ? 'red' : 'gray'}
          onPress={() => {
            console.log('Abdômen clicado');
            handlePartClick('abdomen');
          }}
        />
        {/* Perna Esquerda */}
        <Path
          d="M110 250 L130 250 L130 400 L110 400 Z"
          fill={lesions.leftLeg ? 'red' : 'gray'}
          onPress={() => {
            console.log('Perna Esquerda clicada');
            handlePartClick('leftLeg');
          }}
        />
        {/* Perna Direita */}
        <Path
          d="M150 250 L170 250 L170 400 L150 400 Z"
          fill={lesions.rightLeg ? 'red' : 'gray'}
          onPress={() => {
            console.log('Perna Direita clicada');
            handlePartClick('rightLeg');
          }}
        />
        {/* Pé Esquerdo */}
        <Path
          d="M110 400 L130 400 L130 430 L110 430 Z"
          fill={lesions.leftFoot ? 'red' : 'gray'}
          onPress={() => {
            console.log('Pé Esquerdo clicado');
            handlePartClick('leftFoot');
          }}
        />
        {/* Pé Direito */}
        <Path
          d="M150 400 L170 400 L170 430 L150 430 Z"
          fill={lesions.rightFoot ? 'red' : 'gray'}
          onPress={() => {
            console.log('Pé Direito clicado');
            handlePartClick('rightFoot');
          }}
        />
      </Svg>

      {/* Exibe os botões com base na parte selecionada */}
      {selectedPart && (
        <View style={styles.buttonContainer}>
          {!lesions[selectedPart] ? (
            <Button title="Cadastrar Lesão" onPress={handleAddLesion} />
          ) : (
            <>
              <Button title="Acompanhar Lesão" onPress={handleViewLesion} />
              <Button title="Cadastrar Nova Lesão" onPress={handleAddLesion} />
            </>
          )}
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
    backgroundColor: '#f5f5f5',
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
    color: '#333',
  },
  svg: {
    marginVertical: 16,
    borderWidth: 1, // Adiciona uma borda para verificar o tamanho do SVG
    borderColor: 'black',
  },
  buttonContainer: {
    marginTop: 16,
  },
});