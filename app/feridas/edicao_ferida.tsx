import React, { useState, useEffect } from 'react';
import { YStack, XStack, Input, Button, Text, Form, ScrollView, H1, Switch, TextArea, Select, Spinner, KeyboardAvoidingView } from 'tamagui';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, MapPin, FileText, Camera, Check, X, Calendar, Trash2 } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';
import { Platform, SafeAreaView } from 'react-native';
import { bodyRegionNames } from '../../constants/bodyRegions';

/**
 * Tela de Edição de Ferida da aplicação Cicatriza
 * 
 * Esta tela permite editar as informações de uma ferida existente,
 * incluindo tipo, localização, dimensões, descrição e imagem.
 */
export default function EdicaoFeridaScreen() {
  const router = useRouter();
  const { id, pacienteId } = useLocalSearchParams<{ id: string, pacienteId: string }>();
  const [isLoading, setIsLoading] = useState(false);
  const [isCarregando, setIsCarregando] = useState(true);
  const [error, setError] = useState('');
  const [imagemSelecionada, setImagemSelecionada] = useState(null);
  const [paciente, setPaciente] = useState(null);

  // Estado do formulário
  const [form, setForm] = useState({
    tipo: '',
    localizacao: '',
    regiao: '',
    dimensoes: {
      comprimento: '',
      largura: '',
      profundidade: '',
      unidade: 'cm'
    },
    descricao: '',
    status: 'active'
  });

  // Carregar dados da ferida e do paciente
  useEffect(() => {
    const carregarDados = async () => {
      setIsCarregando(true);
      try {
        // Simulação de carregamento de dados - substituir por chamada real ao Firebase
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Dados simulados do paciente
        setPaciente({
          id: pacienteId,
          nome: 'Maria Silva',
          genero: 'female',
          dataNascimento: new Date(1980, 5, 15),
        });
        
        // Dados simulados da ferida
        const ferida = {
          id: id,
          pacienteId: pacienteId,
          tipo: 'Úlcera Venosa',
          dimensoes: {
            comprimento: '5.2',
            largura: '3.8',
            profundidade: '0.5',
            unidade: 'cm'
          },
          regiao: 'leg_right_lower',
          localizacao: 'Perna Direita',
          descricao: 'Úlcera venosa na região medial da perna direita, com bordas irregulares e tecido de granulação presente.',
          imagemUrl: 'https://example.com/images/wound1.jpg',
          status: 'active',
          dataInicio: new Date(2025, 2, 15),
          ultimaAvaliacao: new Date(2025, 3, 10),
          criadoEm: new Date(2025, 2, 15),
          atualizadoEm: new Date(2025, 3, 10)
        };
        
        setForm({
          tipo: ferida.tipo,
          localizacao: ferida.localizacao,
          regiao: ferida.regiao,
          dimensoes: {
            comprimento: ferida.dimensoes.comprimento,
            largura: ferida.dimensoes.largura,
            profundidade: ferida.dimensoes.profundidade,
            unidade: ferida.dimensoes.unidade
          },
          descricao: ferida.descricao,
          status: ferida.status
        });
        
        setImagemSelecionada(ferida.imagemUrl);
      } catch (error) {
        console.error('Erro ao carregar dados:', error);
        setError('Erro ao carregar dados da lesão');
      } finally {
        setIsCarregando(false);
      }
    };

    if (id && pacienteId) {
      carregarDados();
    }
  }, [id, pacienteId]);

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
    setImagemSelecionada('https://example.com/images/wound_updated.jpg');
  };

  /**
   * Salva as alterações da ferida
   */
  const salvarAlteracoes = async () => {
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
      
      // Navegar de volta para a tela de detalhes da ferida
      router.replace(`/(app)/pacientes/${pacienteId}/lesoes/${id}`);
    } catch (err) {
      setError('Falha ao salvar alterações. Tente novamente.');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
    } finally {
      setIsLoading(false);
    }
  };

  /**
   * Exclui a ferida
   */
  const excluirFerida = async () => {
    // Implementação real usaria um modal de confirmação
    try {
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Heavy);
      
      // Simulação de exclusão - substituir pela implementação real com Firebase
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      // Navegar de volta para a tela de detalhes do paciente
      router.replace(`/(app)/pacientes/${pacienteId}`);
    } catch (error) {
      console.error('Erro ao excluir ferida:', error);
    }
  };

  /**
   * Cancela a edição e retorna para a tela anterior
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

  if (isCarregando) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center" backgroundColor="$background">
        <Spinner size="large" color="$primary" />
        <Text marginTop="$2">Carregando informações da lesão...</Text>
      </YStack>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1 }}>
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
              <H1 fontSize="$6" color="$text">Editar Lesão</H1>
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
            <Form space="$4" onSubmit={salvarAlteracoes}>
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
                    <Select.Item index={3} value="healed">
                      <Select.ItemText>Cicatrizada</Select.ItemText>
                    </Select.Item>
                  </Select.Content>
                </Select>
              </YStack>

              {/* Descrição */}
              <YStack space="$2">
                <Text color="$textSecondary">Descrição</Text>
                <TextArea
                  size="$4"
                  placeholder="Descreva a lesão"
                  value={form.descricao}
                  onChangeText={(text) => atualizarForm('descricao', text)}
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                />
              </YStack>

            </Form>
          </YStack>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}