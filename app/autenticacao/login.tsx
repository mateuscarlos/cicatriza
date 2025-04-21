import React, { useState } from 'react';
import { YStack, XStack, Input, Button, Text, Form, Image, Spinner, H1, Paragraph } from 'tamagui';
import { useRouter } from 'expo-router';
import { Mail, Lock, Eye, EyeOff } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';

/**
 * Tela de Login da aplicação Cicatriza
 * 
 * Esta tela permite que os profissionais estomaterapeutas façam login na aplicação
 * usando seu e-mail e senha. Também oferece opções para recuperação de senha e
 * navegação para a tela de registro.
 */
export default function LoginScreen() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  /**
   * Manipula o processo de login
   */
  const handleLogin = async () => {
    // Validação básica
    if (!email || !password) {
      setError('Por favor, preencha todos os campos');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
      return;
    }

    try {
      setIsLoading(true);
      setError('');
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
      
      // Simulação de login - substituir pela autenticação real do Firebase
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // Navegar para a tela principal após login bem-sucedido
      router.replace('/(app)/(tabs)');
    } catch (err) {
      setError('Falha no login. Verifique suas credenciais.');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
    } finally {
      setIsLoading(false);
    }
  };

  /**
   * Navega para a tela de recuperação de senha
   */
  const handleForgotPassword = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.push('/recuperar-senha');
  };

  /**
   * Navega para a tela de registro
   */
  const handleRegister = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.push('/registro');
  };

  return (
    <YStack flex={1} padding="$6" backgroundColor="$background" justifyContent="center" space="$4">
      {/* Logo e Título */}
      <YStack alignItems="center" space="$4" marginBottom="$6">
        <Image
          source={require('../../assets/images/logo.png')}
          width={120}
          height={120}
          alt="Cicatriza Logo"
        />
        <H1 color="$primary" textAlign="center">Cicatriza</H1>
        <Paragraph color="$textSecondary" textAlign="center">
          Gerenciamento de Lesões para Estomaterapeutas
        </Paragraph>
      </YStack>

      {/* Formulário de Login */}
      <Form
        space="$4"
        onSubmit={handleLogin}
        backgroundColor="$backgroundSecondary"
        padding="$4"
        borderRadius="$4"
      >
        {error ? (
          <Text color="$red10" textAlign="center" marginBottom="$2">
            {error}
          </Text>
        ) : null}

        {/* Campo de E-mail */}
        <YStack space="$2">
          <Text color="$textSecondary">E-mail</Text>
          <Input
            size="$4"
            placeholder="seu@email.com"
            keyboardType="email-address"
            autoCapitalize="none"
            value={email}
            onChangeText={setEmail}
            backgroundColor="$background"
            borderColor="$borderColor"
            focusStyle={{ borderColor: '$primary' }}
            icon={<Mail size={18} color="$textSecondary" />}
          />
        </YStack>

        {/* Campo de Senha */}
        <YStack space="$2">
          <Text color="$textSecondary">Senha</Text>
          <Input
            size="$4"
            placeholder="Sua senha"
            secureTextEntry={!showPassword}
            value={password}
            onChangeText={setPassword}
            backgroundColor="$background"
            borderColor="$borderColor"
            focusStyle={{ borderColor: '$primary' }}
            icon={<Lock size={18} color="$textSecondary" />}
            rightIcon={
              <Button
                size="$2"
                backgroundColor="transparent"
                onPress={() => setShowPassword(!showPassword)}
              >
                {showPassword ? (
                  <EyeOff size={18} color="$textSecondary" />
                ) : (
                  <Eye size={18} color="$textSecondary" />
                )}
              </Button>
            }
          />
        </YStack>

        {/* Link para Recuperação de Senha */}
        <Button
          alignSelf="flex-end"
          size="$2"
          backgroundColor="transparent"
          color="$primary"
          onPress={handleForgotPassword}
        >
          Esqueceu sua senha?
        </Button>

        {/* Botão de Login */}
        <Button
          size="$4"
          backgroundColor="$primary"
          color="white"
          onPress={handleLogin}
          disabled={isLoading}
          marginTop="$2"
        >
          {isLoading ? <Spinner color="white" size="small" /> : 'Entrar'}
        </Button>
      </Form>

      {/* Link para Registro */}
      <XStack justifyContent="center" space="$2" marginTop="$4">
        <Text color="$textSecondary">Não tem uma conta?</Text>
        <Button
          size="$2"
          backgroundColor="transparent"
          color="$primary"
          onPress={handleRegister}
        >
          Registre-se
        </Button>
      </XStack>
    </YStack>
  );
}
