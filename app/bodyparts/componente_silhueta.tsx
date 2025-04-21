import React, { useMemo } from 'react';
import { View, StyleSheet, useWindowDimensions } from 'react-native';
import Svg, { Path, G, Circle } from 'react-native-svg';
import * as Haptics from 'expo-haptics';
import { bodyRegions } from '../../constants/bodyRegions';

/**
 * Componente BodySilhouette
 * 
 * Este componente renderiza uma silhueta humana interativa que permite
 * selecionar regiões anatômicas e destaca áreas com lesões cadastradas.
 * 
 * @param view - Vista da silhueta ('front' ou 'back')
 * @param regionsWithWounds - Array de IDs das regiões com lesões cadastradas
 * @param onRegionPress - Callback chamado quando uma região é pressionada
 * @param highlightColor - Cor para destacar regiões com lesões
 * @param baseColor - Cor base para regiões sem lesões
 */
type BodySilhouetteProps = {
  view: 'front' | 'back';
  regionsWithWounds: string[];
  onRegionPress: (regionId: string) => void;
  highlightColor?: string;
  baseColor?: string;
};

export const BodySilhouette: React.FC<BodySilhouetteProps> = ({
  view,
  regionsWithWounds,
  onRegionPress,
  highlightColor = '#FF3B30',
  baseColor = '#E5E5EA',
}) => {
  const { width } = useWindowDimensions();
  const svgWidth = Math.min(width - 40, 300);
  const svgHeight = svgWidth * 2.17; // Manter proporção
  const scale = svgWidth / 240; // Fator de escala baseado na largura original de 240

  /**
   * Manipula o evento de pressionar uma região
   */
  const handleRegionPress = (regionId: string) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    onRegionPress(regionId);
  };

  /**
   * Renderiza as regiões da silhueta (memoizado para otimização)
   */
  const regions = useMemo(() => {
    return bodyRegions[view].map((region) => (
      <React.Fragment key={region.id}>
        <Path
          d={region.path}
          fill={regionsWithWounds.includes(region.id) ? highlightColor : baseColor}
          stroke="#333333"
          strokeWidth={1 / scale}
          onPress={() => handleRegionPress(region.id)}
        />
        {/* Círculos invisíveis para facilitar o toque em áreas pequenas */}
        <Circle
          cx={region.cx}
          cy={region.cy}
          r={10 / scale}
          fill="transparent"
          onPress={() => handleRegionPress(region.id)}
        />
      </React.Fragment>
    ));
  }, [view, regionsWithWounds, highlightColor, baseColor, scale]);

  return (
    <View style={styles.container}>
      <Svg width={svgWidth} height={svgHeight} viewBox="0 0 240 520">
        <G>{regions}</G>
      </Svg>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'white',
    borderRadius: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
    padding: 10,
  },
});
