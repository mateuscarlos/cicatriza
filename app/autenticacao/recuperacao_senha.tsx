import React, { useState } from 'react';
import { YStack, XStack, Input, Button, Text, Form, Image, Spinner, H1, Paragraph } from 'tamagui';
import { useRouter } from 'expo-router';
import { Mail, ArrowLeft, Send } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';

/**
 * Tela de Recuperação de Senha da aplicação Cicatriza
 * 
 * Esta tela permite que os profissionais estomaterapeutas solicitem
 * a recuperação de senha através do e-mail cadastrado.
 */
export default function RecuperacaoSenhaScreen() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);

  /**
   * Manipula o processo de recuperação de senha
   */
  const handleRecuperarSenha = async () => {
    // Validação básica
    if (!email) {
      setError('Por favor, informe seu e-mail');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
      return;
    }

    try {
      setIsLoading(true);
      setError('');
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
      
      // Simulação de envio de e-mail - substituir pela recuperação real do Firebase
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // Mostrar mensagem de sucesso
      setSuccess(true);
    } catch (err) {
      setError('Falha ao enviar e-mail de recuperação. Tente novamente.');
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
        <H1 fontSize="$6" color="$text">Recuperar Senha</H1>
      </XStack>

      {/* Logo */}
      <YStack alignItems="center" marginBottom="$6">
        <Image
          source={require('../../assets/images/logo.png')}
          width={100}
          height={100}
          alt="Cicatriza Logo"
        />
        <Paragraph color="$textSecondary" textAlign="center" marginTop="$2">
          Informe seu e-mail para receber instruções de recuperação de senha
        </Paragraph>
      </YStack>

      {/* Formulário de Recuperação de Senha */}
      {!success ? (
        <Form
          space="$4"
          onSubmit={handleRecuperarSenha}
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

          {/* Botão de Enviar */}
          <Button
            size="$4"
            backgroundColor="$primary"
            color="white"
            onPress={handleRecuperarSenha}
            disabled={isLoading}
            marginTop="$4"
            icon={isLoading ? undefined : <Send size={18} color="white" />}
          >
            {isLoading ? <Spinner color="white" size="small" /> : 'Enviar Instruções'}
          </Button>
        </Form>
      ) : (
        <YStack
          backgroundColor="$green2"
          padding="$4"
          borderRadius="$4"
          space="$4"
          alignItems="center"
        >
          <Text color="$green10" fontSize="$5" fontWeight="bold" textAlign="center">
            E-mail Enviado!
          </Text>
          <Paragraph color="$green10" textAlign="center">
            Enviamos instruções para recuperar sua senha para {email}.
            Verifique sua caixa de entrada e siga as instruções no e-mail.
          </Paragraph>
          <Button
            size="$4"
            backgroundColor="$green10"
            color="white"
            onPress={handleBackToLogin}
            marginTop="$2"
          >
            Voltar para Login
          </Button>
        </YStack>
      )}

      {/* Link para Login */}
      {!success && (
        <XStack justifyContent="center" space="$2" marginTop="$4">
          <Text color="$textSecondary">Lembrou sua senha?</Text>
          <Button
            size="$2"
            backgroundColor="transparent"
            color="$primary"
            onPress={handleBackToLogin}
          >
            Voltar para Login
          </Button>
        </XStack>
      )}
    </YStack>
  );
}
