import React, { useState } from 'react';
import { View, StyleSheet, TouchableOpacity, Text } from 'react-native';
import Svg, { Path, G, Circle } from 'react-native-svg';

/**
 * Interface para a área do corpo
 */
interface AreaCorpo {
  id: string;
  nome: string;
  d: string;
}

/**
 * Interface para a área selecionada
 */
interface AreaSelecionada {
  id: string;
  nome: string;
  lado: 'frente' | 'costas';
}

/**
 * Interface para as props do componente
 */
interface SilhuetaHumanaSvgProps {
  aoSelecionarArea?: (area: AreaSelecionada) => void;
}

/**
 * Componente de silhueta humana interativa para seleção de áreas do corpo
 * 
 * Este componente permite a visualização de uma silhueta humana (frente e costas)
 * e a seleção de áreas específicas do corpo para registro de feridas.
 * 
 * @param aoSelecionarArea - Função chamada quando uma área é selecionada
 * @returns Componente de silhueta humana
 */
const SilhuetaHumanaSvg: React.FC<SilhuetaHumanaSvgProps> = ({ aoSelecionarArea }) => {
  // Estado para controlar qual lado está sendo exibido (frente ou costas)
  const [ladoVisivel, setLadoVisivel] = useState<'frente' | 'costas'>('frente');
  
  // Estado para armazenar a área selecionada
  const [areaSelecionada, setAreaSelecionada] = useState<AreaCorpo | null>(null);

  // Definição das áreas do corpo (frente)
  const areasFrente: AreaCorpo[] = [
    { id: 'cabeca_frente', nome: 'Cabeça (Frente)', d: 'M100,30 C120,30 140,50 140,70 C140,90 120,110 100,110 C80,110 60,90 60,70 C60,50 80,30 100,30 Z' },
    { id: 'face', nome: 'Face', d: 'M100,50 C110,50 120,60 120,70 C120,80 110,90 100,90 C90,90 80,80 80,70 C80,60 90,50 100,50 Z' },
    { id: 'pescoco', nome: 'Pescoço', d: 'M85,90 L115,90 L115,110 L85,110 Z' },
    { id: 'torax', nome: 'Tórax', d: 'M70,110 L130,110 L130,160 L70,160 Z' },
    { id: 'abdomen', nome: 'Abdômen', d: 'M70,160 L130,160 L130,210 L70,210 Z' },
    { id: 'genital', nome: 'Região Genital', d: 'M85,210 L115,210 L115,230 L85,230 Z' },
    { id: 'ombro_direito', nome: 'Ombro Direito', d: 'M70,110 L50,110 L50,130 L70,130 Z' },
    { id: 'ombro_esquerdo', nome: 'Ombro Esquerdo', d: 'M130,110 L150,110 L150,130 L130,130 Z' },
    { id: 'braco_direito', nome: 'Braço Direito', d: 'M50,130 L30,180 L50,180 L70,130 Z' },
    { id: 'braco_esquerdo', nome: 'Braço Esquerdo', d: 'M150,130 L170,180 L150,180 L130,130 Z' },
    { id: 'cotovelo_direito', nome: 'Cotovelo Direito', d: 'M30,180 L50,180 L50,190 L30,190 Z' },
    { id: 'cotovelo_esquerdo', nome: 'Cotovelo Esquerdo', d: 'M150,180 L170,180 L170,190 L150,190 Z' },
    { id: 'antebraco_direito', nome: 'Antebraço Direito', d: 'M30,190 L50,190 L50,230 L30,230 Z' },
    { id: 'antebraco_esquerdo', nome: 'Antebraço Esquerdo', d: 'M150,190 L170,190 L170,230 L150,230 Z' },
    { id: 'mao_direita', nome: 'Mão Direita', d: 'M30,230 L50,230 L50,260 L30,260 Z' },
    { id: 'mao_esquerda', nome: 'Mão Esquerda', d: 'M150,230 L170,230 L170,260 L150,260 Z' },
    { id: 'quadril', nome: 'Quadril', d: 'M70,210 L130,210 L130,240 L70,240 Z' },
    { id: 'coxa_direita', nome: 'Coxa Direita', d: 'M70,240 L100,240 L100,320 L70,320 Z' },
    { id: 'coxa_esquerda', nome: 'Coxa Esquerda', d: 'M100,240 L130,240 L130,320 L100,320 Z' },
    { id: 'joelho_direito', nome: 'Joelho Direito', d: 'M70,320 L100,320 L100,340 L70,340 Z' },
    { id: 'joelho_esquerdo', nome: 'Joelho Esquerdo', d: 'M100,320 L130,320 L130,340 L100,340 Z' },
    { id: 'perna_direita', nome: 'Perna Direita', d: 'M70,340 L100,340 L100,420 L70,420 Z' },
    { id: 'perna_esquerda', nome: 'Perna Esquerda', d: 'M100,340 L130,340 L130,420 L100,420 Z' },
    { id: 'tornozelo_direito', nome: 'Tornozelo Direito', d: 'M70,420 L100,420 L100,440 L70,440 Z' },
    { id: 'tornozelo_esquerdo', nome: 'Tornozelo Esquerdo', d: 'M100,420 L130,420 L130,440 L100,440 Z' },
    { id: 'pe_direito', nome: 'Pé Direito', d: 'M70,440 L100,440 L100,470 L70,470 Z' },
    { id: 'pe_esquerdo', nome: 'Pé Esquerdo', d: 'M100,440 L130,440 L130,470 L100,470 Z' },
  ];

  // Definição das áreas do corpo (costas)
  const areasCostas: AreaCorpo[] = [
    { id: 'cabeca_costas', nome: 'Cabeça (Costas)', d: 'M100,30 C120,30 140,50 140,70 C140,90 120,110 100,110 C80,110 60,90 60,70 C60,50 80,30 100,30 Z' },
    { id: 'nuca', nome: 'Nuca', d: 'M85,90 L115,90 L115,110 L85,110 Z' },
    { id: 'costas_superior', nome: 'Costas Superior', d: 'M70,110 L130,110 L130,140 L70,140 Z' },
    { id: 'costas_media', nome: 'Costas Média', d: 'M70,140 L130,140 L130,170 L70,170 Z' },
    { id: 'lombar', nome: 'Região Lombar', d: 'M70,170 L130,170 L130,200 L70,200 Z' },
    { id: 'coccix', nome: 'Região do Cóccix', d: 'M90,200 L110,200 L110,220 L90,220 Z' },
    { id: 'ombro_direito_costas', nome: 'Ombro Direito (Costas)', d: 'M70,110 L50,110 L50,130 L70,130 Z' },
    { id: 'ombro_esquerdo_costas', nome: 'Ombro Esquerdo (Costas)', d: 'M130,110 L150,110 L150,130 L130,130 Z' },
    { id: 'braco_direito_costas', nome: 'Braço Direito (Costas)', d: 'M50,130 L30,180 L50,180 L70,130 Z' },
    { id: 'braco_esquerdo_costas', nome: 'Braço Esquerdo (Costas)', d: 'M150,130 L170,180 L150,180 L130,130 Z' },
    { id: 'cotovelo_direito_costas', nome: 'Cotovelo Direito (Costas)', d: 'M30,180 L50,180 L50,190 L30,190 Z' },
    { id: 'cotovelo_esquerdo_costas', nome: 'Cotovelo Esquerdo (Costas)', d: 'M150,180 L170,180 L170,190 L150,190 Z' },
    { id: 'antebraco_direito_costas', nome: 'Antebraço Direito (Costas)', d: 'M30,190 L50,190 L50,230 L30,230 Z' },
    { id: 'antebraco_esquerdo_costas', nome: 'Antebraço Esquerdo (Costas)', d: 'M150,190 L170,190 L170,230 L150,230 Z' },
    { id: 'mao_direita_costas', nome: 'Mão Direita (Costas)', d: 'M30,230 L50,230 L50,260 L30,260 Z' },
    { id: 'mao_esquerda_costas', nome: 'Mão Esquerda (Costas)', d: 'M150,230 L170,230 L170,260 L150,260 Z' },
    { id: 'gluteo_direito', nome: 'Glúteo Direito', d: 'M70,200 L100,200 L100,240 L70,240 Z' },
    { id: 'gluteo_esquerdo', nome: 'Glúteo Esquerdo', d: 'M100,200 L130,200 L130,240 L100,240 Z' },
    { id: 'coxa_direita_costas', nome: 'Coxa Direita (Costas)', d: 'M70,240 L100,240 L100,320 L70,320 Z' },
    { id: 'coxa_esquerda_costas', nome: 'Coxa Esquerda (Costas)', d: 'M100,240 L130,240 L130,320 L100,320 Z' },
    { id: 'joelho_direito_costas', nome: 'Joelho Direito (Costas)', d: 'M70,320 L100,320 L100,340 L70,340 Z' },
    { id: 'joelho_esquerdo_costas', nome: 'Joelho Esquerdo (Costas)', d: 'M100,320 L130,320 L130,340 L100,340 Z' },
    { id: 'perna_direita_costas', nome: 'Perna Direita (Costas)', d: 'M70,340 L100,340 L100,420 L70,420 Z' },
    { id: 'perna_esquerda_costas', nome: 'Perna Esquerda (Costas)', d: 'M100,340 L130,340 L130,420 L100,420 Z' },
    { id: 'tornozelo_direito_costas', nome: 'Tornozelo Direito (Costas)', d: 'M70,420 L100,420 L100,440 L70,440 Z' },
    { id: 'tornozelo_esquerdo_costas', nome: 'Tornozelo Esquerdo (Costas)', d: 'M100,420 L130,420 L130,440 L100,440 Z' },
    { id: 'calcanhar_direito', nome: 'Calcanhar Direito', d: 'M70,440 L100,440 L100,470 L70,470 Z' },
    { id: 'calcanhar_esquerdo', nome: 'Calcanhar Esquerdo', d: 'M100,440 L130,440 L130,470 L100,470 Z' },
  ];

  // Função para alternar entre frente e costas
  const alternarLadoVisivel = (): void => {
    setLadoVisivel(ladoVisivel === 'frente' ? 'costas' : 'frente');
    setAreaSelecionada(null);
  };

  // Função para lidar com a seleção de uma área
  const tratarSelecaoArea = (area: AreaCorpo): void => {
    setAreaSelecionada(area);
    if (aoSelecionarArea) {
      aoSelecionarArea({
        id: area.id,
        nome: area.nome,
        lado: ladoVisivel
      });
    }
  };

  // Determina quais áreas exibir com base no lado selecionado
  const areasParaExibir = ladoVisivel === 'frente' ? areasFrente : areasCostas;

  return (
    <View style={estilos.container}>
      <View style={estilos.cabecalho}>
        <Text style={estilos.titulo}>Selecione a área da ferida</Text>
        <TouchableOpacity 
          style={estilos.botaoAlternar} 
          onPress={alternarLadoVisivel}
        >
          <Text style={estilos.textoBotaoAlternar}>
            {ladoVisivel === 'frente' ? 'Mostrar Costas' : 'Mostrar Frente'}
          </Text>
        </TouchableOpacity>
      </View>

      <View style={estilos.containerSvg}>
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
          {areasParaExibir.map((area) => (
            <Path
              key={area.id}
              d={area.d}
              fill={areaSelecionada && areaSelecionada.id === area.id ? "#ff6b6b" : "transparent"}
              stroke="#666"
              strokeWidth="1"
              onPress={() => tratarSelecaoArea(area)}
            />
          ))}
        </Svg>
      </View>

      {areaSelecionada && (
        <View style={estilos.infoAreaSelecionada}>
          <Text style={estilos.textoAreaSelecionada}>
            Área selecionada: {areaSelecionada.nome}
          </Text>
        </View>
      )}
    </View>
  );
};

const estilos = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  cabecalho: {
    width: '100%',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  titulo: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  botaoAlternar: {
    backgroundColor: '#4dabf7',
    paddingHorizontal: 15,
    paddingVertical: 8,
    borderRadius: 5,
  },
  textoBotaoAlternar: {
    color: 'white',
    fontWeight: 'bold',
  },
  containerSvg: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 10,
    padding: 10,
    backgroundColor: '#f8f9fa',
  },
  infoAreaSelecionada: {
    marginTop: 20,
    padding: 10,
    backgroundColor: '#e9ecef',
    borderRadius: 5,
    width: '100%',
    alignItems: 'center',
  },
  textoAreaSelecionada: {
    fontSize: 16,
    fontWeight: 'bold',
  },
});

export default SilhuetaHumanaSvg;
