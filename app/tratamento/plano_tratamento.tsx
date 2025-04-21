import React, { useState, useEffect } from 'react';
import { YStack, XStack, Input, Button, Text, Form, ScrollView, H1, Switch, TextArea, Select, Spinner, KeyboardAvoidingView } from 'tamagui';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, Check, X, Calendar, Clock, FileText, Edit, Plus } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';
import { Platform } from 'react-native';

/**
 * Tela de Plano de Tratamento da aplicação Cicatriza
 * 
 * Esta tela permite criar ou atualizar o plano de tratamento para uma ferida,
 * incluindo produtos utilizados, frequência de troca, orientações e data da próxima avaliação.
 */
export default function PlanoTratamentoScreen() {
  const router = useRouter();
  const { id, pacienteId } = useLocalSearchParams<{ id: string, pacienteId: string }>();
  const [isLoading, setIsLoading] = useState(false);
  const [isCarregando, setIsCarregando] = useState(true);
  const [error, setError] = useState('');
  const [ferida, setFerida] = useState(null);
  const [tratamentoExistente, setTratamentoExistente] = useState(false);

  // Estado do formulário
  const [form, setForm] = useState({
    limpeza: '',
    coberturaPrimaria: '',
    coberturaSecundaria: '',
    frequenciaTroca: '',
    orientacoes: '',
    proximaAvaliacao: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 dias a partir de hoje
    prescricaoMedicamentos: '',
    cuidadosAdicionais: ''
  });

  // Carregar dados da ferida e tratamento existente
  useEffect(() => {
    const carregarDados = async () => {
      setIsCarregando(true);
      try {
        // Simulação de carregamento de dados - substituir por chamada real ao Firebase
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Dados simulados da ferida
        setFerida({
          id: id,
          pacienteId: pacienteId,
          tipo: 'Úlcera Venosa',
          localizacao: 'Perna Direita',
          regiao: 'leg_right_lower',
          status: 'active'
        });
        
        // Verificar se já existe um tratamento
        const tratamentoAtual = {
          feridaId: id,
          limpeza: 'Solução fisiológica 0,9%',
          coberturaPrimaria: 'Alginato de cálcio',
          coberturaSecundaria: 'Filme transparente',
          frequenciaTroca: 'A cada 3 dias, ou conforme saturação do curativo',
          orientacoes: 'Manter o curativo seco. Não molhar durante o banho. Elevar o membro afetado sempre que possível.',
          proximaAvaliacao: new Date(2025, 3, 25),
          prescricaoMedicamentos: 'Diosmina 450mg + Hesperidina 50mg, 2 comprimidos ao dia',
          cuidadosAdicionais: 'Usar meia de compressão elástica durante o dia. Repouso com membros elevados por 30 minutos, 3 vezes ao dia.'
        };
        
        // Se existir tratamento, preencher o formulário
        if (tratamentoAtual) {
          setForm({
            limpeza: tratamentoAtual.limpeza,
            coberturaPrimaria: tratamentoAtual.coberturaPrimaria,
            coberturaSecundaria: tratamentoAtual.coberturaSecundaria,
            frequenciaTroca: tratamentoAtual.frequenciaTroca,
            orientacoes: tratamentoAtual.orientacoes,
            proximaAvaliacao: tratamentoAtual.proximaAvaliacao,
            prescricaoMedicamentos: tratamentoAtual.prescricaoMedicamentos,
            cuidadosAdicionais: tratamentoAtual.cuidadosAdicionais
          });
          setTratamentoExistente(true);
        }
      } catch (error) {
        console.error('Erro ao carregar dados:', error);
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
    setForm(prev => ({ ...prev, [campo]: valor }));
  };

  /**
   * Formata a data para exibição
   */
  const formatarData = (data) => {
    if (!data) return '';
    return data.toLocaleDateString('pt-BR');
  };

  /**
   * Salva o plano de tratamento
   */
  const salvarTratamento = async () => {
    // Validação básica
    if (!form.limpeza || !form.coberturaPrimaria || !form.frequenciaTroca) {
      setError('Os campos de limpeza, cobertura primária e frequência de troca são obrigatórios');
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
      setError('Falha ao salvar plano de tratamento. Tente novamente.');
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
        <Text marginTop="$2">Carregando informações...</Text>
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
            <H1 fontSize="$6" color="$text">
              {tratamentoExistente ? 'Atualizar Tratamento' : 'Novo Tratamento'}
            </H1>
            <Button size="$3" backgroundColor="transparent" />
          </XStack>

          {/* Informações da Ferida */}
          {ferida && (
            <XStack
              backgroundColor="$backgroundSecondary"
              padding="$3"
              borderRadius="$4"
              alignItems="center"
              space="$2"
            >
              <Text fontWeight="600">{ferida.tipo}</Text>
              <Text size="$2" color="$textSecondary">
                {ferida.localizacao}
              </Text>
            </XStack>
          )}

          {/* Formulário */}
          <Form space="$4" onSubmit={salvarTratamento}>
            {error ? (
              <Text color="$red10" textAlign="center" marginBottom="$2">
                {error}
              </Text>
            ) : null}

            {/* Limpeza */}
            <YStack space="$2">
              <Text color="$textSecondary">Limpeza *</Text>
              <TextArea
                size="$4"
                placeholder="Descreva o método de limpeza (ex: Solução fisiológica 0,9%)"
                value={form.limpeza}
                onChangeText={(text) => atualizarForm('limpeza', text)}
                backgroundColor="$background"
                borderColor="$borderColor"
                focusStyle={{ borderColor: '$primary' }}
                minHeight={80}
              />
            </YStack>

            {/* Cobertura Primária */}
            <YStack space="$2">
              <Text color="$textSecondary">Cobertura Primária *</Text>
              <TextArea
                size="$4"
                placeholder="Descreva a cobertura primária (ex: Alginato de cálcio)"
                value={form.coberturaPrimaria}
                onChangeText={(text) => atualizarForm('coberturaPrimaria', text)}
                backgroundColor="$background"
                borderColor="$borderColor"
                focusStyle={{ borderColor: '$primary' }}
                minHeight={80}
              />
            </YStack>

            {/* Cobertura Secundária */}
            <YStack space="$2">
              <Text color="$textSecondary">Cobertura Secundária</Text>
              <TextArea
                size="$4"
                placeholder="Descreva a cobertura secundária, se houver (ex: Filme transparente)"
                value={form.coberturaSecundaria}
                onChangeText={(text) => atualizarForm('coberturaSecundaria', text)}
                backgroundColor="$background"
                borderColor="$borderColor"
                focusStyle={{ borderColor: '$primary' }}
                minHeight={80}
              />
            </YStack>

            {/* Frequência de Troca */}
            <YStack space="$2">
              <Text color="$textSecondary">Frequência de Troca *</Text>
              <TextArea
                size="$4"
                placeholder="Descreva a frequência de troca do curativo (ex: A cada 3 dias)"
                value={form.frequenciaTroca}
                onChangeText={(text) => atualizarForm('frequenciaTroca', text)}
                backgroundColor="$background"
                borderColor="$borderColor"
                focusStyle={{ borderColor: '$primary' }}
                minHeight={80}
              />
            </YStack>

            {/* Orientações */}
            <YStack space="$2">
              <Text color="$textSecondary">Orientações ao Paciente</Text>
              <TextArea
                size="$4"
                placeholder="Descreva as orientações ao paciente (ex: Manter o curativo seco)"
                value={form.orientacoes}
                onChangeText={(text) => atualizarForm('orientacoes', text)}
                backgroundColor="$background"
                borderColor="$borderColor"
                focusStyle={{ borderColor: '$primary' }}
                minHeight={100}
              />
            </YStack>

            {/* Prescrição de Medicamentos */}
            <YStack space="$2">
              <Text color="$textSecondary">Prescrição de Medicamentos</Text>
              <TextArea
                size="$4"
                placeholder="Descreva os medicamentos prescritos, dosagem e posologia"
                value={form.prescricaoMedicamentos}
                onChangeText={(text) => atualizarForm('prescricaoMedicamentos', text)}
                backgroundColor="$background"
                borderColor="$borderColor"
                focusStyle={{ borderColor: '$primary' }}
                minHeight={100}
              />
            </YStack>

            {/* Cuidados Adicionais */}
            <YStack space="$2">
              <Text color="$textSecondary">Cuidados Adicionais</Text>
              <TextArea
                size="$4"
                placeholder="Descreva cuidados adicionais (ex: Uso de meia compressiva)"
                value={form.cuidadosAdicionais}
                onChangeText={(text) => atualizarForm('cuidadosAdicionais', text)}
                backgroundColor="$background"
                borderColor="$borderColor"
                focusStyle={{ borderColor: '$primary' }}
                minHeight={100}
              />
            </YStack>

            {/* Data da Próxima Avaliação */}
            <YStack space="$2">
              <Text color="$textSecondary">Data da Próxima Avaliação</Text>
              <Input
                size="$4"
                placeholder="DD/MM/AAAA"
                value={formatarData(form.proximaAvaliacao)}
                // Na implementação real, usar um DatePicker
                backgroundColor="$background"
                borderColor="$borderColor"
                focusStyle={{ borderColor: '$primary' }}
                icon={<Calendar size={18} color="$textSecondary" />}
              />
            </YStack>

            {/* Botões de Ação */}
            <YStack space="$4" marginTop="$4">
              <Button
                size="$4"
                backgroundColor="$primary"
                color="white"
                onPress={salvarTratamento}
                disabled={isLoading}
                icon={isLoading ? undefined : <Check size={18} color="white" />}
              >
                {isLoading ? <Spinner color="white" size="small" /> : (
                  tratamentoExistente ? 'Atualizar Tratamento' : 'Salvar Tratamento'
                )}
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
