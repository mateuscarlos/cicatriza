export type BodyRegion = {
  id: string;
  name: string;
  path: string;
  cx: number;
  cy: number;
};

export type BodyRegionsMap = {
  front: BodyRegion[];
  back: BodyRegion[];
};

/**
 * Definição das regiões anatômicas para a silhueta humana
 * 
 * Este arquivo contém as coordenadas SVG para cada região anatômica,
 * tanto na vista frontal quanto posterior, com pontos centrais para
 * facilitar a interação.
 */
export const bodyRegions: BodyRegionsMap = {
  front: [
    // Cabeça e pescoço
    { id: 'head_front', name: 'Cabeça', path: 'M120,40 C150,40 180,70 180,100 C180,130 150,160 120,160 C90,160 60,130 60,100 C60,70 90,40 120,40 Z', cx: 120, cy: 100 },
    { id: 'neck_front', name: 'Pescoço', path: 'M100,160 L140,160 L140,180 L100,180 Z', cx: 120, cy: 170 },
    
    // Tronco
    { id: 'chest_right', name: 'Tórax Direito', path: 'M100,180 L80,250 L120,250 L140,180 Z', cx: 110, cy: 215 },
    { id: 'chest_left', name: 'Tórax Esquerdo', path: 'M140,180 L160,250 L120,250 L100,180 Z', cx: 130, cy: 215 },
    { id: 'abdomen', name: 'Abdômen', path: 'M80,250 L160,250 L170,320 L70,320 Z', cx: 120, cy: 285 },
    
    // Membros superiores
    { id: 'arm_right_upper', name: 'Braço Direito Superior', path: 'M80,180 L60,180 L40,250 L60,250 L80,250 Z', cx: 60, cy: 215 },
    { id: 'arm_left_upper', name: 'Braço Esquerdo Superior', path: 'M160,180 L180,180 L200,250 L180,250 L160,250 Z', cx: 180, cy: 215 },
    { id: 'arm_right_lower', name: 'Antebraço Direito', path: 'M40,250 L60,250 L60,320 L40,320 Z', cx: 50, cy: 285 },
    { id: 'arm_left_lower', name: 'Antebraço Esquerdo', path: 'M180,250 L200,250 L200,320 L180,320 Z', cx: 190, cy: 285 },
    { id: 'hand_right', name: 'Mão Direita', path: 'M40,320 L60,320 L60,350 L40,350 Z', cx: 50, cy: 335 },
    { id: 'hand_left', name: 'Mão Esquerda', path: 'M180,320 L200,320 L200,350 L180,350 Z', cx: 190, cy: 335 },
    
    // Membros inferiores
    { id: 'leg_right_upper', name: 'Coxa Direita', path: 'M70,320 L120,320 L120,400 L90,400 Z', cx: 95, cy: 360 },
    { id: 'leg_left_upper', name: 'Coxa Esquerda', path: 'M120,320 L170,320 L150,400 L120,400 Z', cx: 145, cy: 360 },
    { id: 'leg_right_lower', name: 'Perna Direita', path: 'M90,400 L120,400 L120,480 L90,480 Z', cx: 105, cy: 440 },
    { id: 'leg_left_lower', name: 'Perna Esquerda', path: 'M120,400 L150,400 L150,480 L120,480 Z', cx: 135, cy: 440 },
    { id: 'foot_right', name: 'Pé Direito', path: 'M90,480 L120,480 L120,510 L90,510 Z', cx: 105, cy: 495 },
    { id: 'foot_left', name: 'Pé Esquerdo', path: 'M120,480 L150,480 L150,510 L120,510 Z', cx: 135, cy: 495 },
  ],
  back: [
    // Cabeça e pescoço
    { id: 'head_back', name: 'Cabeça (Posterior)', path: 'M120,40 C150,40 180,70 180,100 C180,130 150,160 120,160 C90,160 60,130 60,100 C60,70 90,40 120,40 Z', cx: 120, cy: 100 },
    { id: 'neck_back', name: 'Nuca', path: 'M100,160 L140,160 L140,180 L100,180 Z', cx: 120, cy: 170 },
    
    // Tronco
    { id: 'back_upper', name: 'Costas Superior', path: 'M80,180 L160,180 L160,250 L80,250 Z', cx: 120, cy: 215 },
    { id: 'back_lower', name: 'Costas Inferior', path: 'M80,250 L160,250 L170,320 L70,320 Z', cx: 120, cy: 285 },
    
    // Membros superiores
    { id: 'arm_right_upper_back', name: 'Braço Direito Superior (Posterior)', path: 'M80,180 L60,180 L40,250 L60,250 L80,250 Z', cx: 60, cy: 215 },
    { id: 'arm_left_upper_back', name: 'Braço Esquerdo Superior (Posterior)', path: 'M160,180 L180,180 L200,250 L180,250 L160,250 Z', cx: 180, cy: 215 },
    { id: 'arm_right_lower_back', name: 'Antebraço Direito (Posterior)', path: 'M40,250 L60,250 L60,320 L40,320 Z', cx: 50, cy: 285 },
    { id: 'arm_left_lower_back', name: 'Antebraço Esquerdo (Posterior)', path: 'M180,250 L200,250 L200,320 L180,320 Z', cx: 190, cy: 285 },
    { id: 'hand_right_back', name: 'Mão Direita (Posterior)', path: 'M40,320 L60,320 L60,350 L40,350 Z', cx: 50, cy: 335 },
    { id: 'hand_left_back', name: 'Mão Esquerda (Posterior)', path: 'M180,320 L200,320 L200,350 L180,350 Z', cx: 190, cy: 335 },
    
    // Membros inferiores
    { id: 'buttock_right', name: 'Glúteo Direito', path: 'M70,320 L120,320 L120,360 L90,360 Z', cx: 95, cy: 340 },
    { id: 'buttock_left', name: 'Glúteo Esquerdo', path: 'M120,320 L170,320 L150,360 L120,360 Z', cx: 145, cy: 340 },
    { id: 'leg_right_upper_back', name: 'Coxa Direita (Posterior)', path: 'M90,360 L120,360 L120,400 L90,400 Z', cx: 105, cy: 380 },
    { id: 'leg_left_upper_back', name: 'Coxa Esquerda (Posterior)', path: 'M120,360 L150,360 L150,400 L120,400 Z', cx: 135, cy: 380 },
    { id: 'leg_right_lower_back', name: 'Panturrilha Direita', path: 'M90,400 L120,400 L120,480 L90,480 Z', cx: 105, cy: 440 },
    { id: 'leg_left_lower_back', name: 'Panturrilha Esquerda', path: 'M120,400 L150,400 L150,480 L120,480 Z', cx: 135, cy: 440 },
    { id: 'foot_right_back', name: 'Pé Direito (Posterior)', path: 'M90,480 L120,480 L120,510 L90,510 Z', cx: 105, cy: 495 },
    { id: 'foot_left_back', name: 'Pé Esquerdo (Posterior)', path: 'M120,480 L150,480 L150,510 L120,510 Z', cx: 135, cy: 495 },
  ]
};

/**
 * Mapeamento de IDs para nomes amigáveis
 * 
 * Este objeto facilita a exibição de nomes amigáveis para as regiões
 * anatômicas a partir de seus IDs.
 */
export const bodyRegionNames: Record<string, string> = Object.entries(bodyRegions).reduce(
  (acc, [_, regions]) => {
    regions.forEach(region => {
      acc[region.id] = region.name;
    });
    return acc;
  },
  {} as Record<string, string>
);
