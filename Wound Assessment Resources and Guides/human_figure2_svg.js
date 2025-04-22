import React, { useState } from 'react';
import { View, StyleSheet, TouchableOpacity, Text } from 'react-native';
import Svg, { Path } from 'react-native-svg';

/**
 * Componente de silhueta humana interativa para seleção de áreas do corpo
 * 
 * Este componente permite a visualização de uma silhueta humana (frente e costas)
 * e a seleção de áreas específicas do corpo para registro de feridas.
 * 
 * @param {Function} onSelectArea - Função chamada quando uma área é selecionada
 * @returns {React.Component} Componente de silhueta humana
 */
const HumanFigureSvg = ({ onSelectArea }) => {
  // Estado para controlar qual lado está sendo exibido (frente ou costas)
  const [viewSide, setViewSide] = useState('front');
  
  // Estado para armazenar a área selecionada
  const [selectedArea, setSelectedArea] = useState(null);

  // Definição das áreas do corpo (frente)
  const frontAreas = [
    { id: 'head_front', name: 'Cabeça (Frente)', d: 'M100,30 C120,30 140,50 140,70 C140,90 120,110 100,110 C80,110 60,90 60,70 C60,50 80,30 100,30 Z' },
    { id: 'chest', name: 'Tórax', d: 'M70,110 L130,110 L130,180 L70,180 Z' },
    { id: 'abdomen', name: 'Abdômen', d: 'M70,180 L130,180 L130,230 L70,230 Z' },
    { id: 'right_arm', name: 'Braço Direito', d: 'M70,110 L50,110 L30,180 L50,180 L70,150 Z' },
    { id: 'left_arm', name: 'Braço Esquerdo', d: 'M130,110 L150,110 L170,180 L150,180 L130,150 Z' },
    { id: 'right_forearm', name: 'Antebraço Direito', d: 'M30,180 L50,180 L50,240 L30,240 Z' },
    { id: 'left_forearm', name: 'Antebraço Esquerdo', d: 'M150,180 L170,180 L170,240 L150,240 Z' },
    { id: 'right_hand', name: 'Mão Direita', d: 'M30,240 L50,240 L50,270 L30,270 Z' },
    { id: 'left_hand', name: 'Mão Esquerda', d: 'M150,240 L170,240 L170,270 L150,270 Z' },
    { id: 'pelvis', name: 'Pelve', d: 'M70,230 L130,230 L130,270 L70,270 Z' },
    { id: 'right_thigh', name: 'Coxa Direita', d: 'M70,270 L100,270 L100,350 L70,350 Z' },
    { id: 'left_thigh', name: 'Coxa Esquerda', d: 'M100,270 L130,270 L130,350 L100,350 Z' },
    { id: 'right_knee', name: 'Joelho Direito', d: 'M70,350 L100,350 L100,370 L70,370 Z' },
    { id: 'left_knee', name: 'Joelho Esquerdo', d: 'M100,350 L130,350 L130,370 L100,370 Z' },
    { id: 'right_leg', name: 'Perna Direita', d: 'M70,370 L100,370 L100,450 L70,450 Z' },
    { id: 'left_leg', name: 'Perna Esquerda', d: 'M100,370 L130,370 L130,450 L100,450 Z' },
    { id: 'right_foot', name: 'Pé Direito', d: 'M70,450 L100,450 L100,480 L70,480 Z' },
    { id: 'left_foot', name: 'Pé Esquerdo', d: 'M100,450 L130,450 L130,480 L100,480 Z' },
  ];

  // Definição das áreas do corpo (costas)
  const backAreas = [
    { id: 'head_back', name: 'Cabeça (Costas)', d: 'M100,30 C120,30 140,50 140,70 C140,90 120,110 100,110 C80,110 60,90 60,70 C60,50 80,30 100,30 Z' },
    { id: 'upper_back', name: 'Costas Superior', d: 'M70,110 L130,110 L130,160 L70,160 Z' },
    { id: 'lower_back', name: 'Costas Inferior', d: 'M70,160 L130,160 L130,230 L70,230 Z' },
    { id: 'right_shoulder_back', name: 'Ombro Direito (Costas)', d: 'M70,110 L50,110 L50,130 L70,130 Z' },
    { id: 'left_shoulder_back', name: 'Ombro Esquerdo (Costas)', d: 'M130,110 L150,110 L150,130 L130,130 Z' },
    { id: 'right_arm_back', name: 'Braço Direito (Costas)', d: 'M50,130 L30,180 L50,180 L70,130 Z' },
    { id: 'left_arm_back', name: 'Braço Esquerdo (Costas)', d: 'M150,130 L170,180 L150,180 L130,130 Z' },
    { id: 'right_forearm_back', name: 'Antebraço Direito (Costas)', d: 'M30,180 L50,180 L50,240 L30,240 Z' },
    { id: 'left_forearm_back', name: 'Antebraço Esquerdo (Costas)', d: 'M150,180 L170,180 L170,240 L150,240 Z' },
    { id: 'right_hand_back', name: 'Mão Direita (Costas)', d: 'M30,240 L50,240 L50,270 L30,270 Z' },
    { id: 'left_hand_back', name: 'Mão Esquerda (Costas)', d: 'M150,240 L170,240 L170,270 L150,270 Z' },
    { id: 'buttocks', name: 'Glúteos', d: 'M70,230 L130,230 L130,270 L70,270 Z' },
    { id: 'right_thigh_back', name: 'Coxa Direita (Costas)', d: 'M70,270 L100,270 L100,350 L70,350 Z' },
    { id: 'left_thigh_back', name: 'Coxa Esquerda (Costas)', d: 'M100,270 L130,270 L130,350 L100,350 Z' },
    { id: 'right_knee_back', name: 'Joelho Direito (Costas)', d: 'M70,350 L100,350 L100,370 L70,370 Z' },
    { id: 'left_knee_back', name: 'Joelho Esquerdo (Costas)', d: 'M100,350 L130,350 L130,370 L100,370 Z' },
    { id: 'right_leg_back', name: 'Perna Direita (Costas)', d: 'M70,370 L100,370 L100,450 L70,450 Z' },
    { id: 'left_leg_back', name: 'Perna Esquerda (Costas)', d: 'M100,370 L130,370 L130,450 L100,450 Z' },
    { id: 'right_foot_back', name: 'Calcanhar Direito', d: 'M70,450 L100,450 L100,480 L70,480 Z' },
    { id: 'left_foot_back', name: 'Calcanhar Esquerdo', d: 'M100,450 L130,450 L130,480 L100,480 Z' },
  ];

  // Função para alternar entre frente e costas
  const toggleViewSide = () => {
    setViewSide(viewSide === 'front' ? 'back' : 'front');
    setSelectedArea(null);
  };

  // Função para lidar com a seleção de uma área
  const handleAreaSelect = (area) => {
    setSelectedArea(area);
    if (onSelectArea) {
      onSelectArea({
        id: area.id,
        name: area.name,
        side: viewSide
      });
    }
  };

  // Determina quais áreas exibir com base no lado selecionado
  const areasToDisplay = viewSide === 'front' ? frontAreas : backAreas;

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Selecione a área da ferida</Text>
        <TouchableOpacity 
          style={styles.toggleButton} 
          onPress={toggleViewSide}
        >
          <Text style={styles.toggleButtonText}>
            {viewSide === 'front' ? 'Mostrar Costas' : 'Mostrar Frente'}
          </Text>
        </TouchableOpacity>
      </View>

      <View style={styles.svgContainer}>
        <Svg height="500" width="200" viewBox="0 0 200 500">
          {/* Contorno da silhueta */}
          <Path
            d="M100,30 C120,30 140,50 140,70 C140,90 120,110 100,110 C80,110 60,90 60,70 C60,50 80,30 100,30 Z
               M70,110 L130,110 L130,230 L70,230 Z
               M70,110 L50,110 L30,180 L50,240 L30,270 L50,270 L50,240 L50,180 Z
               M130,110 L150,110 L170,180 L150,240 L170,270 L150,270 L150,240 L150,180 Z
               M70,230 L130,230 L130,270 L70,270 Z
               M70,270 L100,270 L100,480 L70,480 L70,270 Z
               M100,270 L130,270 L130,480 L100,480 L100,270 Z"
            fill="none"
            stroke="#000"
            strokeWidth="2"
          />

          {/* Áreas selecionáveis */}
          {areasToDisplay.map((area) => (
            <Path
              key={area.id}
              d={area.d}
              fill={selectedArea && selectedArea.id === area.id ? "#ff6b6b" : "transparent"}
              stroke="#666"
              strokeWidth="1"
              onPress={() => handleAreaSelect(area)}
            />
          ))}
        </Svg>
      </View>

      {selectedArea && (
        <View style={styles.selectedAreaInfo}>
          <Text style={styles.selectedAreaText}>
            Área selecionada: {selectedArea.name}
          </Text>
        </View>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  header: {
    width: '100%',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  title: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  toggleButton: {
    backgroundColor: '#4dabf7',
    paddingHorizontal: 15,
    paddingVertical: 8,
    borderRadius: 5,
  },
  toggleButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  svgContainer: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 10,
    padding: 10,
    backgroundColor: '#f8f9fa',
  },
  selectedAreaInfo: {
    marginTop: 20,
    padding: 10,
    backgroundColor: '#e9ecef',
    borderRadius: 5,
    width: '100%',
    alignItems: 'center',
  },
  selectedAreaText: {
    fontSize: 16,
    fontWeight: 'bold',
  },
});

export default HumanFigureSvg;
