import { createTamagui } from 'tamagui';

// Define tokens first
const tokens = {
  space: {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
  },
  fonts: {
    body: 'Arial, sans-serif',
    heading: 'Roboto, sans-serif',
  },
}

// Theme colors need to be directly on the theme object
const medicalTheme = {
  background: '#F5F9FF', // Fundo suave
  primary: '#4CAF50', // Verde para botões e destaques
  secondary: '#2196F3', // Azul para links e ações secundárias
  text: '#333333', // Texto principal
  muted: '#666666', // Texto secundário
  error: '#FF5252', // Vermelho para erros
  success: '#4CAF50', // Verde para sucesso
  border: '#E0E0E0', // Bordas suaves
};

export const tamaguiConfig = createTamagui({
  tokens,
  themes: {
    light: medicalTheme,
  },
});