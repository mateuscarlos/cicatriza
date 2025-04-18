import { createTamagui } from 'tamagui';
import { Themes, Tokens } from '@tamagui/core';

const themes = {
  light: {
    background: '#FFFFFF',
    text: '#000000',
  },
  dark: {
    background: '#000000',
    text: '#FFFFFF',
  },
};

const tokens = {
  color: {
    primary: '#0080ff',
    secondary: '#00bfff',
    background: '#f0f0f0',
  },
  space: {
    0: 0,
    1: 4,
    2: 8,
    3: 16,
    4: 32,
  },
  size: {
    0: 0,
    1: 4,
    2: 8,
    3: 16,
    4: 32,
  },
};

const config = createTamagui({
  themes,
  tokens,
  fonts: {
    body: {
      family: 'Arial, sans-serif',
      size: {
        1: 12,
        2: 14,
        3: 16,
        4: 18,
        5: 20,
      },
      weight: {
        1: '400',
        2: '600',
      },
      lineHeight: {
        1: 16,
        2: 20,
      },
    },
  },
});

export type AppConfig = typeof config;

export default config;