import React, { useState, useEffect } from 'react';
import { YStack, XStack, Button, Text, ScrollView, H1, Card, Spinner, View, Separator, TextArea } from 'tamagui';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, Edit, Calendar, FileText, ChevronRight, Activity, Clock, Check, X, Download, Share } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';

/**
 * Tela de Detalhes do Tratamento da aplicação Cicatriza
 * 
 * Esta tela exibe informações detalhadas sobre um tratamento específico,
 * incluindo limpeza, coberturas, frequência de troca, orientações e prescrições.
 */
export default function DetalhesTratamentoScreen() {
  const router = useRouter();
  const { id, feridaId, pacienteId } = useLocalSearchParams<{ id: string, feridaId: string, pacienteId: string }>();
  const [isLoading, setIsLoading] = useState(true);
  const [tratamento, setTratamento] = useState(null);
  const [ferida, setFerida] = useState(null);
  const [paciente, setPaciente] = useState(null);

  // Carregar dados do tratamento, ferida e paciente
  useEffect(() => {
    const carregarDados = async () => {
      setIsLoading(true);
      try {
        // Simulação de carregamento de dados - substituir por chamada real ao Firebase
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Dados simulados do paciente
        setPaciente({
          id: pacienteId,
          nome: 'Maria Silva',
          genero: 'female',
          dataNascimento: new Date(1980, 5, 15),
          telefone: '(11) 98765-4321'
        });
        
        // Dados simulados da ferida
        setFerida({
          id: feridaId,
          pacienteId: pacienteId,
          tipo: 'Úlcera Venosa',
          localizacao: 'Perna Direita',
          regiao: 'leg_right_lower',
          status: 'active',
          dataInicio: new Date(2025, 2, 15)
        });
        
        // Dados simulados do tratamento
        const tratamentoSimulado = {
          id: id,
          feridaId: feridaId,
          dataInicio: new Date(2025, 3, 10),
          dataFim: null,
          limpeza: 'Solução fisiológica 0,9%',
          coberturaPrimaria: 'Alginato de cálcio',
          coberturaSecundaria: 'Filme transparente',
          frequenciaTroca: 'A cada 3 dias, ou conforme saturação do curativo',
          orientacoes: 'Manter o curativo seco. Não molhar durante o banho. Elevar o membro afetado sempre que possível.',
          proximaAvaliacao: new Date(2025, 3, 25),
          prescricaoMedicamentos: 'Diosmina 450mg + Hesperidina 50mg, 2 comprimidos ao dia',
          cuidadosAdicionais: 'Usar meia de compressão elástica durante o dia. Repouso com membros elevados por 30 minutos, 3 vezes ao dia.',
          ativo: true,
          criadoEm: new Date(2025, 3, 10),
          atualizadoEm: new Date(2025, 3, 10),
          criadoPor: 'Dr. João Silva',
          observacoes: 'Paciente apresentou boa resposta ao tratamento anterior. Mudança para alginato de cálcio devido ao aumento do tecido de granulação e redução do exsudato.'
        };
        
        setTratamento(tratamentoSimulado);
      } catch (error) {
        console.error('Erro ao carregar dados:', error);
      } finally {
        setIsLoading(false);
      }
    };

    if (id && feridaId && pacienteId) {
      carregarDados();
    }
  }, [id, feridaId, pacienteId]);

  /**
   * Formata a data para exibição
   */
  const formatarData = (data) => {
    if (!data) return '';
    return data.toLocaleDateString('pt-BR');
  };

  /**
   * Navega para a tela de edição do tratamento
   */
  const navegarParaEdicaoTratamento = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    router.push(`/(app)/pacientes/${pacienteId}/lesoes/${feridaId}/tratamentos/${id}/editar`);
  };

  /**
   * Navega de volta para a tela anterior
   */
  const voltarParaTelaAnterior = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.back();
  };

  /**
   * Gera uma prescrição para o paciente
   */
  const gerarPrescricao = async () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    // Simulação de geração de prescrição - substituir pela implementação real
    await new Promise(resolve => setTimeout(resolve, 1000));
    alert('Prescrição gerada com sucesso!');
  };

  /**
   * Compartilha o tratamento com outros profissionais
   */
  const compartilharTratamento = async () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    // Simulação de compartilhamento - substituir pela implementação real
    await new Promise(resolve => setTimeout(resolve, 1000));
    alert('Tratamento compartilhado com sucesso!');
  };

  /**
   * Calcula os dias restantes até a próxima avaliação
   */
  const calcularDiasRestantes = (dataProximaAvaliacao) => {
    if (!dataProximaAvaliacao) return null;
    
    const hoje = new Date();
    const proxima = new Date(dataProximaAvaliacao);
    const diffTempo = proxima.getTime() - hoje.getTime();
    const diffDias = Math.ceil(diffTempo / (1000 * 3600 * 24));
    
    return diffDias;
  };

  if (isLoading) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center" backgroundColor="$background">
        <Spinner size="large" color="$primary" />
        <Text marginTop="$2">Carregando informações do tratamento...</Text>
      </YStack>
    );
  }

  if (!tratamento) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center" backgroundColor="$background" padding="$4">
        <Text color="$textSecondary" textAlign="center">
          Tratamento não encontrado.
        </Text>
        <Button
          marginTop="$4"
          size="$4"
          backgroundColor="$primary"
          color="white"
          icon={<ArrowLeft size={18} color="white" />}
          onPress={voltarParaTelaAnterior}
        >
          Voltar
        </Button>
      </YStack>
    );
  }

  return (
    <YStack flex={1} backgroundColor="$background">
      <ScrollView>
        <YStack padding="$4" space="$4">
          {/* Cabeçalho */}
          <XStack justifyContent="space-between" alignItems="center">
            <Button
              size="$3"
              backgroundColor="$backgroundSecondary"
              icon={<ArrowLeft size={18} color="$text" />}
              onPress={voltarParaTelaAnterior}
            >
              Voltar
            </Button>
            <H1 fontSize="$6" color="$text">Tratamento</H1>
            <Button
              size="$3"
              backgroundColor="$backgroundSecondary"
              icon={<Edit size={18} color="$text" />}
              onPress={navegarParaEdicaoTratamento}
            >
              Editar
            </Button>
          </XStack>

          {/* Informações do Paciente e Ferida */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            {paciente && (
              <XStack alignItems="center" space="$2" marginBottom="$2">
                <Text fontSize="$5" fontWeight="bold" color="$text">
                  {paciente.nome}
                </Text>
              </XStack>
            )}
            
            {ferida && (
              <>
                <Text fontSize="$4" color="$text" marginBottom="$2">
                  {ferida.tipo} - {ferida.localizacao}
                </Text>
                
                <XStack alignItems="center" space="$2">
                  <Calendar size={18} color="$textSecondary" />
                  <Text fontSize="$3" color="$textSecondary">
                    Lesão iniciada em: {formatarData(ferida.dataInicio)}
                  </Text>
                </XStack>
              </>
            )}
          </Card>

          {/* Status do Tratamento */}
          <Card padding="$4" backgroundColor={tratamento.ativo ? '$green2' : '$backgroundSecondary'} borderRadius="$4">
            <XStack justifyContent="space-between" alignItems="center">
              <Text fontSize="$5" fontWeight="bold" color={tratamento.ativo ? '$green10' : '$textSecondary'}>
                {tratamento.ativo ? 'Tratamento Ativo' : 'Tratamento Encerrado'}
              </Text>
              {tratamento.ativo && (
                <View
                  width={12}
                  height={12}
                  borderRadius={6}
                  backgroundColor="$green10"
                />
              )}
            </XStack>
            
            <XStack alignItems="center" space="$2" marginTop="$2">
              <Calendar size={18} color="$textSecondary" />
              <Text fontSize="$4" color="$text">
                Iniciado em: {formatarData(tratamento.dataInicio)}
              </Text>
            </XStack>
            
            {tratamento.dataFim && (
              <XStack alignItems="center" space="$2" marginTop="$2">
                <Calendar size={18} color="$textSecondary" />
                <Text fontSize="$4" color="$text">
                  Encerrado em: {formatarData(tratamento.dataFim)}
                </Text>
              </XStack>
            )}
            
            {tratamento.ativo && tratamento.proximaAvaliacao && (
              <XStack alignItems="center" space="$2" marginTop="$2">
                <Clock size={18} color="$textSecondary" />
                <Text fontSize="$4" color="$text">
                  Próxima avaliação: {formatarData(tratamento.proximaAvaliacao)}
                  {calcularDiasRestantes(tratamento.proximaAvaliacao) !== null && (
                    <Text
                      fontSize="$3"
                      color={calcularDiasRestantes(tratamento.proximaAvaliacao) <= 0 ? '$red10' : '$textSecondary'}
                    >
                      {' '}({calcularDiasRestantes(tratamento.proximaAvaliacao) <= 0 ? 'Hoje' : 
                        calcularDiasRestantes(tratamento.proximaAvaliacao) === 1 ? 'Amanhã' : 
                        `Em ${calcularDiasRestantes(tratamento.proximaAvaliacao)} dias`})
                    </Text>
                  )}
                </Text>
              </XStack>
            )}
          </Card>

          {/* Detalhes do Tratamento */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Detalhes do Tratamento
            </Text>
            
            <YStack space="$3">
              <YStack space="$1">
                <Text fontSize="$4" fontWeight="bold" color="$textSecondary">Limpeza:</Text>
                <Text fontSize="$4" color="$text">{tratamento.limpeza}</Text>
              </YStack>
              
              <Separator marginVertical="$1" />
              
              <YStack space="$1">
                <Text fontSize="$4" fontWeight="bold" color="$textSecondary">Cobertura Primária:</Text>
                <Text fontSize="$4" color="$text">{tratamento.coberturaPrimaria}</Text>
              </YStack>
              
              {tratamento.coberturaSecundaria && (
                <>
                  <Separator marginVertical="$1" />
                  
                  <YStack space="$1">
                    <Text fontSize="$4" fontWeight="bold" color="$textSecondary">Cobertura Secundária:</Text>
                    <Text fontSize="$4" color="$text">{tratamento.coberturaSecundaria}</Text>
                  </YStack>
                </>
              )}
              
              <Separator marginVertical="$1" />
              
              <YStack space="$1">
                <Text fontSize="$4" fontWeight="bold" color="$textSecondary">Frequência de Troca:</Text>
                <Text fontSize="$4" color="$text">{tratamento.frequenciaTroca}</Text>
              </YStack>
            </YStack>
          </Card>

          {/* Orientações e Cuidados */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Orientações e Cuidados
            </Text>
            
            <YStack space="$3">
              <YStack space="$1">
                <Text fontSize="$4" fontWeight="bold" color="$textSecondary">Orientações ao Paciente:</Text>
                <Text fontSize="$4" color="$text">{tratamento.orientacoes}</Text>
              </YStack>
              
              {tratamento.cuidadosAdicionais && (
                <>
                  <Separator marginVertical="$1" />
                  
                  <YStack space="$1">
                    <Text fontSize="$4" fontWeight="bold" color="$textSecondary">Cuidados Adicionais:</Text>
                    <Text fontSize="$4" color="$text">{tratamento.cuidadosAdicionais}</Text>
                  </YStack>
                </>
              )}
            </YStack>
          </Card>

          {/* Prescrição de Medicamentos */}
          {tratamento.prescricaoMedicamentos && (
            <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
              <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
                Prescrição de Medicamentos
              </Text>
              
              <Text fontSize="$4" color="$text">{tratamento.prescricaoMedicamentos}</Text>
              
              <Button
                marginTop="$4"
                size="$4"
                backgroundColor="$primary"
                color="white"
                icon={<Download size={18} color="white" />}
                onPress={gerarPrescricao}
              >
                Gerar Prescrição
              </Button>
            </Card>
          )}

          {/* Observações */}
          {tratamento.observacoes && (
            <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
              <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
                Observações
              </Text>
              
              <Text fontSize="$4" color="$text">{tratamento.observacoes}</Text>
            </Card>
          )}

          {/* Informações Adicionais */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Informações Adicionais
            </Text>
            
            <YStack space="$2">
              <XStack justifyContent="space-between">
                <Text fontSize="$3" color="$textSecondary">Criado por:</Text>
                <Text fontSize="$3" color="$text">{tratamento.criadoPor}</Text>
              </XStack>
              
              <XStack justifyContent="space-between">
                <Text fontSize="$3" color="$textSecondary">Criado em:</Text>
                <Text fontSize="$3" color="$text">{formatarData(tratamento.criadoEm)}</Text>
              </XStack>
              
              <XStack justifyContent="space-between">
                <Text fontSize="$3" color="$textSecondary">Última atualização:</Text>
                <Text fontSize="$3" color="$text">{formatarData(tratamento.atualizadoEm)}</Text>
              </XStack>
            </YStack>
          </Card>

          {/* Botões de Ação */}
          <YStack space="$3" marginTop="$2">
            <Button
              size="$4"
              backgroundColor="$backgroundSecondary"
              icon={<Share size={18} color="$text" />}
              onPress={compartilharTratamento}
            >
              Compartilhar Tratamento
            </Button>
          </YStack>
        </YStack>
      </ScrollView>
    </YStack>
  );
}
