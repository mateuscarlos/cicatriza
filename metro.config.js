// Learn more https://docs.expo.io/guides/customizing-metro
const { getDefaultConfig } = require('expo/metro-config');
const { tamaguiMetroPlugin } = require('@tamagui/metro-plugin');

const config = getDefaultConfig(__dirname);

module.exports = tamaguiMetroPlugin(config, {
  config: './tamagui.config.ts', // Caminho para o arquivo de configuração do Tamagui
  components: ['tamagui'], // Componentes a serem processados
  useReactNativeWebLite: true, // Opcional: otimização para web
});