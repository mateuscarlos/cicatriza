import React from 'react';
import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';
import { useFonts } from 'expo-font';
import { Stack, useRouter, useSegments } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import { StatusBar } from 'expo-status-bar';
import { useEffect } from 'react';
import 'react-native-reanimated';
import * as eva from '@eva-design/eva';
import { ApplicationProvider } from '@ui-kitten/components';
import { EvaIconsPack } from '@ui-kitten/eva-icons';
import { IconRegistry } from '@ui-kitten/components';
import { GestureHandlerRootView } from 'react-native-gesture-handler';

import { useColorScheme } from '../hooks/useColorScheme';

// Prevent the splash screen from auto-hiding before asset loading is complete.
SplashScreen.preventAutoHideAsync();

// Componente para lidar com a lógica de autenticação
function AuthenticationGuard({ children }) {
  const segments = useSegments();
  const router = useRouter();

  useEffect(() => {
    // Define a lógica de redirecionamento
    const inAuthGroup = segments[0] === '(auth)';
    const isLoggedIn = global.loggedInUser; // Verificar se usuário está logado

    // Se não estiver em tela de auth e não estiver logado, redirecionar
    if (!isLoggedIn && segments[0] !== 'login' && segments[0] !== '(auth)') {
      router.replace('/login');
    }
  }, [segments]);

  return <>{children}</>;
}

export default function RootLayout() {
  const colorScheme = useColorScheme();
  const [loaded] = useFonts({
    SpaceMono: require('../assets/fonts/SpaceMono-Regular.ttf'),
  });

  useEffect(() => {
    if (loaded) {
      SplashScreen.hideAsync();
    }
  }, [loaded]);

  if (!loaded) {
    return null;
  }

  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <IconRegistry icons={EvaIconsPack} />
      <ApplicationProvider 
        {...eva} 
        theme={colorScheme === 'dark' ? eva.dark : eva.light}
      >
        <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
          <AuthenticationGuard>
            <Stack>
              <Stack.Screen name="index" options={{ 
                headerShown: false 
              }} />
              <Stack.Screen name="login" options={{ 
                headerShown: false 
              }} />
              <Stack.Screen name="patient/patient" options={{ 
                title: "Pacientes"
              }} />
              <Stack.Screen name="patient/register" options={{ 
                title: "Cadastrar Paciente"
              }} />
              <Stack.Screen name="+not-found" />
            </Stack>
            <StatusBar style="auto" />
          </AuthenticationGuard>
        </ThemeProvider>
      </ApplicationProvider>
    </GestureHandlerRootView>
  );
}
