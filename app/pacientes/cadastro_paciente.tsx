import React, { useState } from 'react';
import { YStack, XStack, Input, Button, Text, Form, ScrollView, H1, Switch, TextArea, Select, Spinner, KeyboardAvoidingView } from 'tamagui';
import { useRouter } from 'expo-router';
import { ArrowLeft, User, Calendar, Phone, Mail, MapPin, FileText, Camera, Check, X } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';
import { Platform } from 'react-native';

/**
 * Tela de Cadastro de Paciente da aplicação Cicatriza
 * 
 * Esta tela permite cadastrar um novo paciente com informações pessoais,
 * dados de contato e histórico médico. Após o cadastro, o usuário pode
 * optar por retornar à lista de pacientes ou ir diretamente para o
 * cadastro de lesões.
 */
export default function CadastroPacienteScreen() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [fotoSelecionada, setFotoSelecionada] = useState(null);

  // Estado do formulário
  const [form, setForm] = useState({
    nome: '',
    dataNascimento: new Date(),
    genero: 'female',
    telefone: '',
    email: '',
    endereco: '',
    historico: {
      condicoes: '',
      alergias: '',
      medicamentos: '',
      observacoes: ''
    }
  });

  /**
   * Atualiza o estado do formulário
   */
  const atualizarForm = (campo, valor) => {
    // Lógica para atualizar campos aninhados
    const campos = campo.split('.');
    if (campos.length === 1) {
      setForm(prev => ({ ...prev, [campo]: valor }));
    } else {
      setForm(prev => {
        const novoForm = { ...prev };
        let atual = novoForm;
        for (let i = 0; i < campos.length - 1; i++) {
          atual = atual[campos[i]];
        }
        atual[campos[campos.length - 1]] = valor;
        return novoForm;
      });
    }
  };

  /**
   * Seleciona uma foto para o paciente
   */
  const selecionarFoto = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    // Simulação de seleção de foto - substituir pela implementação real
    setFotoSelecionada('https://i.pravatar.cc/150?img=' + Math.floor(Math.random() * 70));
  };

  /**
   * Formata a data para exibição
   */
  const formatarData = (data) => {
    if (!data) return '';
    return data.toLocaleDateString('pt-BR');
  };

  /**
   * Salva o paciente e retorna para a lista
   */
  const salvarPaciente = async () => {
    await handleSalvar(false);
  };

  /**
   * Salva o paciente e navega para cadastro de lesão
   */
  const salvarECadastrarLesao = async () => {
    await handleSalvar(true);
  };

  /**
   * Lógica comum para salvar o paciente
   */
  const handleSalvar = async (irParaLesao) => {
    // Validação básica
    if (!form.nome) {
      setError('O nome do paciente é obrigatório');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
      return;
    }

    try {
      setIsLoading(true);
      setError('');
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
      
      // Simulação de salvamento - substituir pela implementação real com Firebase
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // ID simulado do paciente criado
      const pacienteId = 'p' + Date.now();
      
      // Navegar para a próxima tela
      if (irParaLesao) {
        router.replace(`/(app)/pacientes/${pacienteId}/bodyparts`);
      } else {
        router.replace('/(app)/pacientes');
      }
    } catch (err) {
      setError('Falha ao salvar paciente. Tente novamente.');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
    } finally {
      setIsLoading(false);
    }
  };

  /**
   * Cancela o cadastro e retorna para a tela anterior
   */
  const cancelar = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.back();
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={{ flex: 1 }}
    >
      <ScrollView>
        <YStack flex={1} padding="$4" backgroundColor="$background" space="$4">
          {/* Cabeçalho */}
          <XStack justifyContent="space-between" alignItems="center">
            <Button
              size="$3"
              backgroundColor="$backgroundSecondary"
              icon={<ArrowLeft size={18} color="$text" />}
              onPress={cancelar}
            >
              Voltar
            </Button>
            <H1 fontSize="$6" color="$text">Novo Paciente</H1>
            <Button size="$3" backgroundColor="transparent" />
          </XStack>

          {/* Formulário */}
          <Form space="$4" onSubmit={salvarPaciente}>
            {error ? (
              <Text color="$red10" textAlign="center" marginBottom="$2">
                {error}
              </Text>
            ) : null}

            {/* Foto do Paciente */}
            <YStack alignItems="center" space="$2">
              <Button
                size="$6"
                circular
                backgroundColor={fotoSelecionada ? 'transparent' : '$backgroundSecondary'}
                borderWidth={fotoSelecionada ? 2 : 0}
                borderColor="$primary"
                onPress={selecionarFoto}
                icon={
                  fotoSelecionada ? (
                    <XStack width={100} height={100} borderRadius={50} overflow="hidden">
                      <img src={fotoSelecionada} width="100%" height="100%" style={{ objectFit: 'cover' }} />
                    </XStack>
                  ) : (
                    <Camera size={40} color="$textSecondary" />
                  )
                }
              />
              <Text color="$textSecondary">
                {fotoSelecionada ? 'Alterar foto' : 'Adicionar foto'}
              </Text>
            </YStack>

            {/* Informações Pessoais */}
            <YStack space="$4" backgroundColor="$backgroundSecondary" padding="$4" borderRadius="$4">
              <Text fontSize="$5" fontWeight="bold" color="$text">Informações Pessoais</Text>

              <YStack space="$2">
                <Text color="$textSecondary">Nome Completo *</Text>
                <Input
                  size="$4"
                  placeholder="Nome do paciente"
                  value={form.nome}
                  onChangeText={(text) => atualizarForm('nome', text)}
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                  icon={<User size={18} color="$textSecondary" />}
                />
              </YStack>

              <YStack space="$2">
                <Text color="$textSecondary">Data de Nascimento</Text>
                <Input
                  size="$4"
                  placeholder="DD/MM/AAAA"
                  value={formatarData(form.dataNascimento)}
                  // Na implementação real, usar um DatePicker
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                  icon={<Calendar size={18} color="$textSecondary" />}
                />
              </YStack>

              <YStack space="$2">
                <Text color="$textSecondary">Gênero</Text>
                <Select
                  size="$4"
                  value={form.genero}
                  onValueChange={(value) => atualizarForm('genero', value)}
                  backgroundColor="$background"
                >
                  <Select.Trigger iconAfter={<Select.CaretDown />}>
                    <Select.Value placeholder="Selecione o gênero" />
                  </Select.Trigger>
                  <Select.Content>
                    <Select.Item index={0} value="female">
                      <Select.ItemText>Feminino</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={1} value="male">
                      <Select.ItemText>Masculino</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={2} value="other">
                      <Select.ItemText>Outro</Select.ItemText>
                    </Select.Item>
                  </Select.Content>
                </Select>
              </YStack>
            </YStack>

            {/* Informações de Contato */}
            <YStack space="$4" backgroundColor="$backgroundSecondary" padding="$4" borderRadius="$4">
              <Text fontSize="$5" fontWeight="bold" color="$text">Informações de Contato</Text>

              <YStack space="$2">
                <Text color="$textSecondary">Telefone</Text>
                <Input
                  size="$4"
                  placeholder="(00) 00000-0000"
                  value={form.telefone}
                  onChangeText={(text) => atualizarForm('telefone', text)}
                  keyboardType="phone-pad"
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                  icon={<Phone size={18} color="$textSecondary" />}
                />
              </YStack>

              <YStack space="$2">
                <Text color="$textSecondary">E-mail</Text>
                <Input
                  size="$4"
                  placeholder="email@exemplo.com"
                  value={form.email}
                  onChangeText={(text) => atualizarForm('email', text)}
                  keyboardType="email-address"
                  autoCapitalize="none"
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                  icon={<Mail size={18} color="$textSecondary" />}
                />
              </YStack>

              <YStack space="$2">
                <Text color="$textSecondary">Endereço</Text>
                <Input
                  size="$4"
                  placeholder="Rua, número, bairro, cidade, estado"
                  value={form.endereco}
                  onChangeText={(text) => atualizarForm('endereco', text)}
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                  icon={<MapPin size={18} color="$textSecondary" />}
                />
              </YStack>
            </YStack>

            {/* Histórico Médico */}
            <YStack space="$4" backgroundColor="$backgroundSecondary" padding="$4" borderRadius="$4">
              <Text fontSize="$5" fontWeight="bold" color="$text">Histórico Médico</Text>

              <YStack space="$2">
                <Text color="$textSecondary">Condições Médicas</Text>
                <TextArea
                  size="$4"
                  placeholder="Diabetes, hipertensão, etc. (separar por vírgula)"
                  value={form.historico.condicoes}
                  onChangeText={(text) => atualizarForm('historico.condicoes', text)}
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                  minHeight={80}
                />
              </YStack>

              <YStack space="$2">
                <Text color="$textSecondary">Alergias</Text>
                <TextArea
                  size="$4"
                  placeholder="Medicamentos, alimentos, etc. (separar por vírgula)"
                  value={form.historico.alergias}
                  onChangeText={(text) => atualizarForm('historico.alergias', text)}
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                  minHeight={80}
                />
              </YStack>

              <YStack space="$2">
                <Text color="$textSecondary">Medicamentos em Uso</Text>
                <TextArea
                  size="$4"
                  placeholder="Nome, dosagem, frequência (separar por vírgula)"
                  value={form.historico.medicamentos}
                  onChangeText={(text) => atualizarForm('historico.medicamentos', text)}
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                  minHeight={80}
                />
              </YStack>

              <YStack space="$2">
                <Text color="$textSecondary">Observações</Text>
                <TextArea
                  size="$4"
                  placeholder="Informações adicionais relevantes"
                  value={form.historico.observacoes}
                  onChangeText={(text) => atualizarForm('historico.observacoes', text)}
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                  minHeight={100}
                />
              </YStack>
            </YStack>

            {/* Botões de Ação */}
            <YStack space="$4" marginTop="$4">
              <Button
                size="$4"
                backgroundColor="$primary"
                color="white"
                onPress={salvarPaciente}
                disabled={isLoading}
                icon={isLoading ? undefined : <Check size={18} color="white" />}
              >
                {isLoading ? <Spinner color="white" size="small" /> : 'Cadastrar Paciente'}
              </Button>
              
              <Button
                size="$4"
                backgroundColor="$secondary"
                color="white"
                onPress={salvarECadastrarLesao}
                disabled={isLoading}
              >
                {isLoading ? <Spinner color="white" size="small" /> : 'Cadastrar Lesão'}
              </Button>
              
              <Button
                size="$4"
                backgroundColor="$backgroundSecondary"
                color="$text"
                onPress={cancelar}
                icon={<X size={18} color="$text" />}
              >
                Cancelar
              </Button>
            </YStack>
          </Form>
        </YStack>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}
