import React, { useState } from 'react';
import { YStack, XStack, Input, Button, Text, Form, Image, Spinner, H1, Paragraph, ScrollView } from 'tamagui';
import { useRouter } from 'expo-router';
import { Mail, Lock, Eye, EyeOff, User, ArrowLeft, Check } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';

/**
 * Tela de Registro da aplicação Cicatriza
 * 
 * Esta tela permite que novos profissionais estomaterapeutas se registrem na aplicação
 * fornecendo nome, e-mail, senha e confirmação de senha.
 */
export default function RegistroScreen() {
  const router = useRouter();
  const [nome, setNome] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  /**
   * Manipula o processo de registro
   */
  const handleRegister = async () => {
    // Validação básica
    if (!nome || !email || !password || !confirmPassword) {
      setError('Por favor, preencha todos os campos');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
      return;
    }

    if (password !== confirmPassword) {
      setError('As senhas não coincidem');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
      return;
    }

    try {
      setIsLoading(true);
      setError('');
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
      
      // Simulação de registro - substituir pelo registro real do Firebase
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // Navegar para a tela principal após registro bem-sucedido
      router.replace('/(app)/(tabs)');
    } catch (err) {
      setError('Falha no registro. Tente novamente.');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
    } finally {
      setIsLoading(false);
    }
  };

  /**
   * Navega de volta para a tela de login
   */
  const handleBackToLogin = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.back();
  };

  return (
    <ScrollView>
      <YStack flex={1} padding="$6" backgroundColor="$background" space="$4">
        {/* Cabeçalho */}
        <XStack alignItems="center" space="$4" marginBottom="$4">
          <Button
            size="$3"
            backgroundColor="$backgroundSecondary"
            icon={<ArrowLeft size={18} color="$text" />}
            onPress={handleBackToLogin}
          >
            Voltar
          </Button>
          <H1 fontSize="$6" color="$text">Criar Conta</H1>
        </XStack>

        {/* Logo */}
        <YStack alignItems="center" marginBottom="$4">
          <Image
            source={require('../../assets/images/logo.png')}
            width={100}
            height={100}
            alt="Cicatriza Logo"
          />
          <Paragraph color="$textSecondary" textAlign="center" marginTop="$2">
            Preencha os dados abaixo para criar sua conta
          </Paragraph>
        </YStack>

        {/* Formulário de Registro */}
        <Form
          space="$4"
          onSubmit={handleRegister}
          backgroundColor="$backgroundSecondary"
          padding="$4"
          borderRadius="$4"
        >
          {error ? (
            <Text color="$red10" textAlign="center" marginBottom="$2">
              {error}
            </Text>
          ) : null}

          {/* Campo de Nome */}
          <YStack space="$2">
            <Text color="$textSecondary">Nome Completo</Text>
            <Input
              size="$4"
              placeholder="Seu nome completo"
              value={nome}
              onChangeText={setNome}
              backgroundColor="$background"
              borderColor="$borderColor"
              focusStyle={{ borderColor: '$primary' }}
              icon={<User size={18} color="$textSecondary" />}
            />
          </YStack>

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

          {/* Campo de Confirmação de Senha */}
          <YStack space="$2">
            <Text color="$textSecondary">Confirmar Senha</Text>
            <Input
              size="$4"
              placeholder="Confirme sua senha"
              secureTextEntry={!showPassword}
              value={confirmPassword}
              onChangeText={setConfirmPassword}
              backgroundColor="$background"
              borderColor="$borderColor"
              focusStyle={{ borderColor: '$primary' }}
              icon={<Lock size={18} color="$textSecondary" />}
            />
          </YStack>

          {/* Botão de Registro */}
          <Button
            size="$4"
            backgroundColor="$primary"
            color="white"
            onPress={handleRegister}
            disabled={isLoading}
            marginTop="$4"
            icon={isLoading ? undefined : <Check size={18} color="white" />}
          >
            {isLoading ? <Spinner color="white" size="small" /> : 'Criar Conta'}
          </Button>
        </Form>

        {/* Link para Login */}
        <XStack justifyContent="center" space="$2" marginTop="$4" marginBottom="$6">
          <Text color="$textSecondary">Já tem uma conta?</Text>
          <Button
            size="$2"
            backgroundColor="transparent"
            color="$primary"
            onPress={handleBackToLogin}
          >
            Faça login
          </Button>
        </XStack>
      </YStack>
    </ScrollView>
  );
}
