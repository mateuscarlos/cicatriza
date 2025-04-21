import { createTamagui } from 'tamagui';
import { createInterFont } from '@tamagui/font-inter';
import { shorthands } from '@tamagui/shorthands';
import { tokens } from '@tamagui/themes';

// Skip importing themes from @tamagui/themes to avoid the ./light/mint issue
const interFont = createInterFont();

// Define all theme colors directly
const themes = {
  // Light theme
  light: {
    background: '#FFFFFF',
    backgroundHover: '#F5F5F5',
    backgroundPress: '#EEEEEE',
    backgroundFocus: '#F5F5F5',
    color: '#000000',
    colorHover: '#111111',
    colorPress: '#222222',
    colorFocus: '#111111',
    shadowColor: 'rgba(0, 0, 0, 0.2)',
    shadowColorHover: 'rgba(0, 0, 0, 0.3)',
    borderColor: '#DDDDDD',
    borderColorHover: '#CCCCCC',
    borderColorFocus: '#AAAAAA',
    borderColorPress: '#BBBBBB',
    placeholderColor: '#999999',
  },
  
  // Dark theme
  dark: {
    background: '#111111',
    backgroundHover: '#1F1F1F',
    backgroundPress: '#2A2A2A',
    backgroundFocus: '#1F1F1F',
    color: '#FFFFFF',
    colorHover: '#EEEEEE',
    colorPress: '#DDDDDD',
    colorFocus: '#EEEEEE',
    shadowColor: 'rgba(0, 0, 0, 0.5)',
    shadowColorHover: 'rgba(0, 0, 0, 0.6)',
    borderColor: '#333333',
    borderColorHover: '#444444',
    borderColorFocus: '#555555',
    borderColorPress: '#444444',
    placeholderColor: '#666666',
  },
  
  // Custom mint themes
  light_mint: { 
    background: '#E0FFE0', 
    backgroundHover: '#C0FFC0',
    color: '#003300',
    colorHover: '#004400',
    borderColor: '#90EE90',
    shadowColor: 'rgba(0, 51, 0, 0.2)',
  },
  
  dark_mint: { 
    background: '#004D00', 
    backgroundHover: '#003300',
    color: '#E0FFE0',
    colorHover: '#C0FFC0',
    borderColor: '#006400',
    shadowColor: 'rgba(0, 77, 0, 0.5)',
  },
};

const appConfig = createTamagui({
  fonts: {
    heading: interFont,
    body: interFont,
  },
  tokens,
  themes,
  shorthands,
});

export type AppConfig = typeof appConfig;

declare module 'tamagui' {
  interface TamaguiCustomConfig extends AppConfig {}
}

export default appConfig;