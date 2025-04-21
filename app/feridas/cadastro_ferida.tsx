import React, { useState, useEffect } from 'react';
import { YStack, XStack, Input, Button, Text, Form, ScrollView, H1, Switch, TextArea, Select, Spinner, KeyboardAvoidingView } from 'tamagui';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, MapPin, FileText, Camera, Check, X, Calendar } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';
import { Platform } from 'react-native';
import { bodyRegionNames } from '../../constants/bodyRegions';

/**
 * Tela de Cadastro de Ferida da aplicação Cicatriza
 * 
 * Esta tela permite cadastrar uma nova ferida para um paciente,
 * incluindo tipo, localização, dimensões, descrição e imagem.
 */
export default function CadastroFeridaScreen() {
  const router = useRouter();
  const { pacienteId, regiao } = useLocalSearchParams<{ pacienteId: string, regiao?: string }>();
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [imagemSelecionada, setImagemSelecionada] = useState(null);
  const [paciente, setPaciente] = useState(null);

  // Estado do formulário
  const [form, setForm] = useState({
    tipo: '',
    localizacao: '',
    regiao: regiao || '',
    dimensoes: {
      comprimento: '',
      largura: '',
      profundidade: '',
      unidade: 'cm'
    },
    descricao: '',
    status: 'active'
  });

  // Carregar dados do paciente
  useEffect(() => {
    const carregarPaciente = async () => {
      try {
        // Simulação de carregamento de dados - substituir por chamada real ao Firebase
        await new Promise(resolve => setTimeout(resolve, 500));
        
        // Dados simulados do paciente
        setPaciente({
          id: pacienteId,
          nome: 'Maria Silva',
          genero: 'female',
          dataNascimento: new Date(1980, 5, 15),
        });
        
        // Se a região foi fornecida, preencher o campo de localização
        if (regiao && bodyRegionNames[regiao]) {
          setForm(prev => ({
            ...prev,
            regiao: regiao,
            localizacao: bodyRegionNames[regiao]
          }));
        }
      } catch (error) {
        console.error('Erro ao carregar paciente:', error);
      }
    };

    if (pacienteId) {
      carregarPaciente();
    }
  }, [pacienteId, regiao]);

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
   * Seleciona uma imagem para a ferida
   */
  const selecionarImagem = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    // Simulação de seleção de imagem - substituir pela implementação real
    setImagemSelecionada('https://example.com/images/wound_sample.jpg');
  };

  /**
   * Salva a ferida
   */
  const salvarFerida = async () => {
    // Validação básica
    if (!form.tipo) {
      setError('O tipo da lesão é obrigatório');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
      return;
    }

    if (!form.localizacao) {
      setError('A localização da lesão é obrigatória');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
      return;
    }

    if (!form.dimensoes.comprimento || !form.dimensoes.largura) {
      setError('As dimensões da lesão são obrigatórias');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
      return;
    }

    try {
      setIsLoading(true);
      setError('');
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
      
      // Simulação de salvamento - substituir pela implementação real com Firebase
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // ID simulado da ferida criada
      const feridaId = 'f' + Date.now();
      
      // Navegar para a tela de detalhes da ferida ou para a tela Bodyparts
      if (regiao) {
        // Se veio da tela Bodyparts, voltar para ela
        router.replace(`/(app)/pacientes/${pacienteId}/bodyparts`);
      } else {
        // Caso contrário, ir para os detalhes da ferida
        router.replace(`/(app)/pacientes/${pacienteId}/lesoes/${feridaId}`);
      }
    } catch (err) {
      setError('Falha ao salvar lesão. Tente novamente.');
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

  /**
   * Calcula a idade com base na data de nascimento
   */
  const calcularIdade = (dataNascimento) => {
    if (!dataNascimento) return '';
    
    const hoje = new Date();
    const nascimento = new Date(dataNascimento);
    let idade = hoje.getFullYear() - nascimento.getFullYear();
    const m = hoje.getMonth() - nascimento.getMonth();
    if (m < 0 || (m === 0 && hoje.getDate() < nascimento.getDate())) {
      idade--;
    }
    return idade;
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
            <H1 fontSize="$6" color="$text">Nova Lesão</H1>
            <Button size="$3" backgroundColor="transparent" />
          </XStack>

          {/* Informações do Paciente */}
          {paciente && (
            <XStack
              backgroundColor="$backgroundSecondary"
              padding="$3"
              borderRadius="$4"
              alignItems="center"
              space="$2"
            >
              <Text fontWeight="600">{paciente.nome}</Text>
              <Text size="$2" color="$textSecondary">
                {paciente.genero === 'male' ? 'Masculino' : 'Feminino'} • 
                {calcularIdade(paciente.dataNascimento)} anos
              </Text>
            </XStack>
          )}

          {/* Formulário */}
          <Form space="$4" onSubmit={salvarFerida}>
            {error ? (
              <Text color="$red10" textAlign="center" marginBottom="$2">
                {error}
              </Text>
            ) : null}

            {/* Tipo de Lesão */}
            <YStack space="$2">
              <Text color="$textSecondary">Tipo de Lesão *</Text>
              <Select
                size="$4"
                value={form.tipo}
                onValueChange={(value) => atualizarForm('tipo', value)}
                backgroundColor="$background"
              >
                <Select.Trigger iconAfter={<Select.CaretDown />}>
                  <Select.Value placeholder="Selecione o tipo de lesão" />
                </Select.Trigger>
                <Select.Content>
                  <Select.Item index={0} value="Úlcera Venosa">
                    <Select.ItemText>Úlcera Venosa</Select.ItemText>
                  </Select.Item>
                  <Select.Item index={1} value="Úlcera Arterial">
                    <Select.ItemText>Úlcera Arterial</Select.ItemText>
                  </Select.Item>
                  <Select.Item index={2} value="Lesão por Pressão">
                    <Select.ItemText>Lesão por Pressão</Select.ItemText>
                  </Select.Item>
                  <Select.Item index={3} value="Queimadura">
                    <Select.ItemText>Queimadura</Select.ItemText>
                  </Select.Item>
                  <Select.Item index={4} value="Ferida Cirúrgica">
                    <Select.ItemText>Ferida Cirúrgica</Select.ItemText>
                  </Select.Item>
                  <Select.Item index={5} value="Ferida Traumática">
                    <Select.ItemText>Ferida Traumática</Select.ItemText>
                  </Select.Item>
                  <Select.Item index={6} value="Pé Diabético">
                    <Select.ItemText>Pé Diabético</Select.ItemText>
                  </Select.Item>
                  <Select.Item index={7} value="Outro">
                    <Select.ItemText>Outro</Select.ItemText>
                  </Select.Item>
                </Select.Content>
              </Select>
            </YStack>

            {/* Localização */}
            <YStack space="$2">
              <Text color="$textSecondary">Localização *</Text>
              <Input
                size="$4"
                placeholder="Localização da lesão"
                value={form.localizacao}
                onChangeText={(text) => atualizarForm('localizacao', text)}
                backgroundColor="$background"
                borderColor="$borderColor"
                focusStyle={{ borderColor: '$primary' }}
                icon={<MapPin size={18} color="$textSecondary" />}
              />
              <Text fontSize="$2" color="$textSecondary">
                {form.regiao ? `Região selecionada: ${bodyRegionNames[form.regiao]}` : 'Nenhuma região específica selecionada'}
              </Text>
            </YStack>

            {/* Dimensões */}
            <YStack space="$4" backgroundColor="$backgroundSecondary" padding="$4" borderRadius="$4">
              <Text fontSize="$5" fontWeight="bold" color="$text">Dimensões *</Text>

              <XStack space="$2">
                <YStack flex={1} space="$2">
                  <Text color="$textSecondary">Comprimento</Text>
                  <Input
                    size="$4"
                    placeholder="0.0"
                    value={form.dimensoes.comprimento}
                    onChangeText={(text) => atualizarForm('dimensoes.comprimento', text)}
                    keyboardType="numeric"
                    backgroundColor="$background"
                    borderColor="$borderColor"
                    focusStyle={{ borderColor: '$primary' }}
                  />
                </YStack>
                
                <YStack flex={1} space="$2">
                  <Text color="$textSecondary">Largura</Text>
                  <Input
                    size="$4"
                    placeholder="0.0"
                    value={form.dimensoes.largura}
                    onChangeText={(text) => atualizarForm('dimensoes.largura', text)}
                    keyboardType="numeric"
                    backgroundColor="$background"
                    borderColor="$borderColor"
                    focusStyle={{ borderColor: '$primary' }}
                  />
                </YStack>
              </XStack>

              <YStack space="$2">
                <Text color="$textSecondary">Profundidade (opcional)</Text>
                <Input
                  size="$4"
                  placeholder="0.0"
                  value={form.dimensoes.profundidade}
                  onChangeText={(text) => atualizarForm('dimensoes.profundidade', text)}
                  keyboardType="numeric"
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                />
              </YStack>

              <YStack space="$2">
                <Text color="$textSecondary">Unidade de Medida</Text>
                <Select
                  size="$4"
                  value={form.dimensoes.unidade}
                  onValueChange={(value) => atualizarForm('dimensoes.unidade', value)}
                  backgroundColor="$background"
                >
                  <Select.Trigger iconAfter={<Select.CaretDown />}>
                    <Select.Value placeholder="Selecione a unidade" />
                  </Select.Trigger>
                  <Select.Content>
                    <Select.Item index={0} value="cm">
                      <Select.ItemText>Centímetros (cm)</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={1} value="mm">
                      <Select.ItemText>Milímetros (mm)</Select.ItemText>
                    </Select.Item>
                  </Select.Content>
                </Select>
              </YStack>
            </YStack>

            {/* Status da Lesão */}
            <YStack space="$2">
              <Text color="$textSecondary">Status da Lesão</Text>
              <Select
                size="$4"
                value={form.status}
                onValueChange={(value) => atualizarForm('status', value)}
                backgroundColor="$background"
              >
                <Select.Trigger iconAfter={<Select.CaretDown />}>
                  <Select.Value placeholder="Selecione o status" />
                </Select.Trigger>
                <Select.Content>
                  <Select.Item index={0} value="active">
                    <Select.ItemText>Ativa</Select.ItemText>
                  </Select.Item>
                  <Select.Item index={1} value="healing">
                    <Select.ItemText>Em cicatrização</Select.ItemText>
                  </Select.Item>
                  <Select.Item index={2} value="infected">
                    <Select.ItemText>Infectada</Select.ItemText>
                  </Select.Item>
                </Select.Content>
              </Select>
            </YStack>

            {/* Data de Início */}
            <YStack space="$2">
              <Text color="$textSecondary">Data de Início</Text>
              <Input
                size="$4"
                placeholder="DD/MM/AAAA"
                value={new Date().toLocaleDateString('pt-BR')}
                // Na implementação real, usar um DatePicker
                backgroundColor="$background"
                borderColor="$borderColor"
                focusStyle={{ borderColor: '$primary' }}
                icon={<Calendar size={18} color="$textSecondary" />}
              />
            </YStack>

            {/* Descrição */}
            <YStack space="$2">
              <Text color="$textSecondary">Descrição</Text>
              <TextArea
                size="$4"
                placeholder="Descreva as características da lesão"
                value={form.descricao}
                onChangeText={(text) => atualizarForm('descricao', text)}
                backgroundColor="$background"
                borderColor="$borderColor"
                focusStyle={{ borderColor: '$primary' }}
                minHeight={100}
              />
            </YStack>

            {/* Imagem da Lesão */}
            <YStack space="$2" alignItems="center">
              <Text color="$textSecondary">Imagem da Lesão</Text>
              <Button
                size="$5"
                backgroundColor={imagemSelecionada ? 'transparent' : '$backgroundSecondary'}
                borderWidth={imagemSelecionada ? 2 : 0}
                borderColor="$primary"
                onPress={selecionarImagem}
                icon={
                  imagemSelecionada ? (
                    <XStack width={200} height={150} borderRadius={8} overflow="hidden">
                      <img src={imagemSelecionada} width="100%" height="100%" style={{ objectFit: 'cover' }} />
                    </XStack>
                  ) : (
                    <Camera size={40} color="$textSecondary" />
                  )
                }
              />
              <Text color="$textSecondary" marginTop="$2">
                {imagemSelecionada ? 'Clique para alterar a imagem' : 'Clique para adicionar uma imagem'}
              </Text>
            </YStack>

            {/* Botões de Ação */}
            <XStack space="$4" justifyContent="space-between" marginTop="$4">
              <Button
                size="$4"
                flex={1}
                backgroundColor="$backgroundSecondary"
                color="$text"
                onPress={cancelar}
              >
                Cancelar
              </Button>
              <Button
                size="$4"
                flex={1}
                backgroundColor="$primary"
                color="white"
                onPress={() => salvarFerida()}
                icon={isLoading ? null : <Check size={18} />}
                disabled={isLoading}
              >
                {isLoading ? <Spinner color="white" /> : 'Salvar'}
              </Button>
            </XStack>
          </Form>
        </YStack>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}