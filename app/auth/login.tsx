import React from 'react';
import { useRouter } from 'expo-router';
import { YStack, Input, Button, H1, Separator } from 'tamagui';

export default function LoginScreen() {
  const router = useRouter();

  return (
    <YStack flex={1} justifyContent="center" alignItems="center" padding="$4" space="$4">
      <H1>Login</H1>
      <Separator />
      <Input placeholder="Email" />
      <Input placeholder="Senha" secureTextEntry />
      <Button onPress={() => router.push('/dashboard')}>Entrar</Button>
    </YStack>
  );
}