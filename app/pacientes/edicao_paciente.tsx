import React, { useState, useEffect } from 'react';
import { YStack, XStack, Input, Button, Text, Form, ScrollView, H1, Switch, TextArea, Select, Spinner, KeyboardAvoidingView } from 'tamagui';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, User, Calendar, Phone, Mail, MapPin, FileText, Camera, Check, X } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';
import { Platform } from 'react-native';

/**
 * Tela de Edição de Paciente da aplicação Cicatriza
 * 
 * Esta tela permite editar as informações de um paciente existente,
 * incluindo dados pessoais, contato e histórico médico.
 */
export default function EdicaoPacienteScreen() {
  const router = useRouter();
  const { id } = useLocalSearchParams<{ id: string }>();
  const [isLoading, setIsLoading] = useState(false);
  const [isCarregando, setIsCarregando] = useState(true);
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

  // Carregar dados do paciente
  useEffect(() => {
    const carregarPaciente = async () => {
      setIsCarregando(true);
      try {
        // Simulação de carregamento de dados - substituir por chamada real ao Firebase
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Dados simulados do paciente
        const paciente = {
          id: id,
          nome: 'Maria Silva',
          dataNascimento: new Date(1980, 5, 15),
          genero: 'female',
          telefone: '(11) 98765-4321',
          email: 'maria.silva@email.com',
          endereco: 'Rua das Flores, 123 - São Paulo, SP',
          historico: {
            condicoes: 'Diabetes Tipo 2, Hipertensão',
            alergias: 'Penicilina, Látex',
            medicamentos: 'Metformina 500mg, Losartana 50mg',
            observacoes: 'Paciente com histórico de cicatrização lenta.'
          }
        };
        
        setForm({
          nome: paciente.nome,
          dataNascimento: paciente.dataNascimento,
          genero: paciente.genero,
          telefone: paciente.telefone,
          email: paciente.email,
          endereco: paciente.endereco,
          historico: {
            condicoes: paciente.historico.condicoes,
            alergias: paciente.historico.alergias,
            medicamentos: paciente.historico.medicamentos,
            observacoes: paciente.historico.observacoes
          }
        });
        
        setFotoSelecionada(`https://i.pravatar.cc/150?u=${id}`);
      } catch (error) {
        console.error('Erro ao carregar paciente:', error);
        setError('Erro ao carregar dados do paciente');
      } finally {
        setIsCarregando(false);
      }
    };

    if (id) {
      carregarPaciente();
    }
  }, [id]);

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
   * Salva as alterações do paciente
   */
  const salvarAlteracoes = async () => {
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
      
      // Navegar de volta para a tela de detalhes
      router.replace(`/(app)/pacientes/${id}`);
    } catch (err) {
      setError('Falha ao salvar alterações. Tente novamente.');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
    } finally {
      setIsLoading(false);
    }
  };

  /**
   * Cancela a edição e retorna para a tela anterior
   */
  const cancelar = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.back();
  };

  if (isCarregando) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center" backgroundColor="$background">
        <Spinner size="large" color="$primary" />
        <Text marginTop="$2">Carregando informações do paciente...</Text>
      </YStack>
    );
  }

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
            <H1 fontSize="$6" color="$text">Editar Paciente</H1>
            <Button size="$3" backgroundColor="transparent" />
          </XStack>

          {/* Formulário */}
          <Form space="$4" onSubmit={salvarAlteracoes}>
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
                onPress={salvarAlteracoes}
                disabled={isLoading}
                icon={isLoading ? undefined : <Check size={18} color="white" />}
              >
                {isLoading ? <Spinner color="white" size="small" /> : 'Salvar Alterações'}
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
