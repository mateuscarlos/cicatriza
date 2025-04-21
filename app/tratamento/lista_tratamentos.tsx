import React, { useState, useEffect } from 'react';
import { YStack, XStack, Button, Text, ScrollView, H1, Card, Spinner, View, Separator } from 'tamagui';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, Edit, Calendar, FileText, ChevronRight, Activity, Clock, Check, X } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';

/**
 * Tela de Lista de Tratamentos da aplicação Cicatriza
 * 
 * Esta tela exibe o histórico de tratamentos registrados para uma ferida específica,
 * permitindo visualizar a evolução dos tratamentos ao longo do tempo.
 */
export default function ListaTratamentosScreen() {
  const router = useRouter();
  const { feridaId, pacienteId } = useLocalSearchParams<{ feridaId: string, pacienteId: string }>();
  const [isLoading, setIsLoading] = useState(true);
  const [tratamentos, setTratamentos] = useState([]);
  const [tratamentoAtual, setTratamentoAtual] = useState(null);
  const [ferida, setFerida] = useState(null);

  // Carregar dados da ferida e tratamentos
  useEffect(() => {
    const carregarDados = async () => {
      setIsLoading(true);
      try {
        // Simulação de carregamento de dados - substituir por chamada real ao Firebase
        await new Promise(resolve => setTimeout(resolve, 1000));
        
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
        
        // Dados simulados do tratamento atual
        const tratamentoAtualSimulado = {
          id: 'trat1',
          feridaId: feridaId,
          dataInicio: new Date(2025, 3, 10),
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
          atualizadoEm: new Date(2025, 3, 10)
        };
        
        setTratamentoAtual(tratamentoAtualSimulado);
        
        // Dados simulados do histórico de tratamentos
        const tratamentosSimulados = [
          tratamentoAtualSimulado,
          {
            id: 'trat2',
            feridaId: feridaId,
            dataInicio: new Date(2025, 2, 25),
            dataFim: new Date(2025, 3, 10),
            limpeza: 'Solução fisiológica 0,9%',
            coberturaPrimaria: 'Hidrogel',
            coberturaSecundaria: 'Gaze não aderente',
            frequenciaTroca: 'A cada 2 dias',
            orientacoes: 'Manter o curativo seco. Elevar o membro afetado sempre que possível.',
            proximaAvaliacao: new Date(2025, 3, 10),
            prescricaoMedicamentos: 'Diosmina 450mg + Hesperidina 50mg, 2 comprimidos ao dia',
            cuidadosAdicionais: 'Usar meia de compressão elástica durante o dia.',
            ativo: false,
            criadoEm: new Date(2025, 2, 25),
            atualizadoEm: new Date(2025, 3, 10)
          },
          {
            id: 'trat3',
            feridaId: feridaId,
            dataInicio: new Date(2025, 2, 15),
            dataFim: new Date(2025, 2, 25),
            limpeza: 'Solução fisiológica 0,9%',
            coberturaPrimaria: 'Carvão ativado com prata',
            coberturaSecundaria: 'Gaze não aderente',
            frequenciaTroca: 'A cada 2 dias',
            orientacoes: 'Manter o curativo seco. Elevar o membro afetado sempre que possível.',
            proximaAvaliacao: new Date(2025, 2, 25),
            prescricaoMedicamentos: 'Diosmina 450mg + Hesperidina 50mg, 2 comprimidos ao dia',
            cuidadosAdicionais: 'Repouso com membros elevados por 30 minutos, 3 vezes ao dia.',
            ativo: false,
            criadoEm: new Date(2025, 2, 15),
            atualizadoEm: new Date(2025, 2, 25)
          }
        ];
        
        setTratamentos(tratamentosSimulados);
      } catch (error) {
        console.error('Erro ao carregar dados:', error);
      } finally {
        setIsLoading(false);
      }
    };

    if (feridaId && pacienteId) {
      carregarDados();
    }
  }, [feridaId, pacienteId]);

  /**
   * Formata a data para exibição
   */
  const formatarData = (data) => {
    if (!data) return '';
    return data.toLocaleDateString('pt-BR');
  };

  /**
   * Navega para a tela de detalhes do tratamento
   */
  const navegarParaDetalhesTratamento = (tratamentoId) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.push(`/(app)/pacientes/${pacienteId}/lesoes/${feridaId}/tratamentos/${tratamentoId}`);
  };

  /**
   * Navega para a tela de novo tratamento
   */
  const navegarParaNovoTratamento = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    router.push(`/(app)/pacientes/${pacienteId}/lesoes/${feridaId}/tratamentos/novo`);
  };

  /**
   * Navega para a tela de edição do tratamento atual
   */
  const navegarParaEdicaoTratamento = () => {
    if (tratamentoAtual) {
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
      router.push(`/(app)/pacientes/${pacienteId}/lesoes/${feridaId}/tratamentos/${tratamentoAtual.id}/editar`);
    }
  };

  /**
   * Navega de volta para a tela anterior
   */
  const voltarParaTelaAnterior = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.back();
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
        <Text marginTop="$2">Carregando tratamentos...</Text>
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
            <H1 fontSize="$6" color="$text">Tratamentos</H1>
            <Button
              size="$3"
              backgroundColor="$primary"
              color="white"
              icon={<Edit size={18} color="white" />}
              onPress={navegarParaNovoTratamento}
            >
              Novo
            </Button>
          </XStack>

          {/* Informações da Ferida */}
          {ferida && (
            <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
              <Text fontSize="$6" fontWeight="bold" color="$text" marginBottom="$2">
                {ferida.tipo}
              </Text>
              
              <XStack alignItems="center" space="$2" marginBottom="$2">
                <Activity size={18} color="$textSecondary" />
                <Text fontSize="$4" color="$textSecondary">
                  Localização: {ferida.localizacao}
                </Text>
              </XStack>
              
              <XStack alignItems="center" space="$2">
                <Calendar size={18} color="$textSecondary" />
                <Text fontSize="$4" color="$textSecondary">
                  Data de início: {formatarData(ferida.dataInicio)}
                </Text>
              </XStack>
            </Card>
          )}

          {/* Tratamento Atual */}
          <YStack space="$3">
            <Text fontSize="$5" fontWeight="bold" color="$text">
              Tratamento Atual
            </Text>
            
            {tratamentoAtual ? (
              <Card
                padding="$4"
                backgroundColor="$background"
                borderColor="$primary"
                borderWidth={2}
                borderRadius="$4"
              >
                <XStack justifyContent="space-between" alignItems="center" marginBottom="$2">
                  <XStack alignItems="center" space="$2">
                    <Calendar size={18} color="$primary" />
                    <Text fontSize="$4" fontWeight="bold" color="$text">
                      Iniciado em: {formatarData(tratamentoAtual.dataInicio)}
                    </Text>
                  </XStack>
                  <Button
                    size="$2"
                    backgroundColor="$backgroundSecondary"
                    icon={<Edit size={16} color="$text" />}
                    onPress={navegarParaEdicaoTratamento}
                  >
                    Editar
                  </Button>
                </XStack>
                
                <Separator marginVertical="$2" />
                
                <YStack space="$3">
                  <YStack space="$1">
                    <Text fontSize="$3" fontWeight="bold" color="$textSecondary">Limpeza:</Text>
                    <Text fontSize="$3" color="$text">{tratamentoAtual.limpeza}</Text>
                  </YStack>
                  
                  <YStack space="$1">
                    <Text fontSize="$3" fontWeight="bold" color="$textSecondary">Cobertura Primária:</Text>
                    <Text fontSize="$3" color="$text">{tratamentoAtual.coberturaPrimaria}</Text>
                  </YStack>
                  
                  {tratamentoAtual.coberturaSecundaria && (
                    <YStack space="$1">
                      <Text fontSize="$3" fontWeight="bold" color="$textSecondary">Cobertura Secundária:</Text>
                      <Text fontSize="$3" color="$text">{tratamentoAtual.coberturaSecundaria}</Text>
                    </YStack>
                  )}
                  
                  <YStack space="$1">
                    <Text fontSize="$3" fontWeight="bold" color="$textSecondary">Frequência de Troca:</Text>
                    <Text fontSize="$3" color="$text">{tratamentoAtual.frequenciaTroca}</Text>
                  </YStack>
                  
                  <Separator marginVertical="$2" />
                  
                  <YStack space="$1">
                    <Text fontSize="$3" fontWeight="bold" color="$textSecondary">Próxima Avaliação:</Text>
                    <XStack alignItems="center" space="$2">
                      <Text fontSize="$3" color="$text">{formatarData(tratamentoAtual.proximaAvaliacao)}</Text>
                      {calcularDiasRestantes(tratamentoAtual.proximaAvaliacao) !== null && (
                        <Text
                          fontSize="$2"
                          color={calcularDiasRestantes(tratamentoAtual.proximaAvaliacao) <= 0 ? '$red10' : '$textSecondary'}
                        >
                          ({calcularDiasRestantes(tratamentoAtual.proximaAvaliacao) <= 0 ? 'Hoje' : 
                            calcularDiasRestantes(tratamentoAtual.proximaAvaliacao) === 1 ? 'Amanhã' : 
                            `Em ${calcularDiasRestantes(tratamentoAtual.proximaAvaliacao)} dias`})
                        </Text>
                      )}
                    </XStack>
                  </YStack>
                </YStack>
                
                <Button
                  marginTop="$4"
                  size="$3"
                  backgroundColor="$backgroundSecondary"
                  onPress={() => navegarParaDetalhesTratamento(tratamentoAtual.id)}
                >
                  Ver Detalhes Completos
                </Button>
              </Card>
            ) : (
              <YStack
                padding="$4"
                backgroundColor="$backgroundSecondary"
                borderRadius="$4"
                alignItems="center"
                space="$3"
              >
                <Text color="$textSecondary" textAlign="center">
                  Nenhum tratamento ativo para esta lesão.
                </Text>
                <Button
                  size="$4"
                  backgroundColor="$primary"
                  color="white"
                  icon={<Edit size={18} color="white" />}
                  onPress={navegarParaNovoTratamento}
                >
                  Registrar Tratamento
                </Button>
              </YStack>
            )}
          </YStack>

          {/* Histórico de Tratamentos */}
          <YStack space="$3">
            <Text fontSize="$5" fontWeight="bold" color="$text">
              Histórico de Tratamentos
            </Text>
            
            {tratamentos.length > 1 ? (
              tratamentos.filter(t => !t.ativo).map((tratamento) => (
                <Card
                  key={tratamento.id}
                  padding="$4"
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  borderWidth={1}
                  borderRadius="$4"
                  pressStyle={{ opacity: 0.8, scale: 0.98 }}
                  onPress={() => navegarParaDetalhesTratamento(tratamento.id)}
                >
                  <XStack justifyContent="space-between" alignItems="center" marginBottom="$2">
                    <XStack alignItems="center" space="$2">
                      <Calendar size={18} color="$textSecondary" />
                      <Text fontSize="$4" fontWeight="bold" color="$text">
                        {formatarData(tratamento.dataInicio)} - {formatarData(tratamento.dataFim)}
                      </Text>
                    </XStack>
                    <ChevronRight size={18} color="$textSecondary" />
                  </XStack>
                  
                  <Separator marginVertical="$2" />
                  
                  <YStack space="$2">
                    <XStack justifyContent="space-between">
                      <Text fontSize="$3" color="$textSecondary">Cobertura Primária:</Text>
                      <Text fontSize="$3" color="$text">{tratamento.coberturaPrimaria}</Text>
                    </XStack>
                    
                    <XStack justifyContent="space-between">
                      <Text fontSize="$3" color="$textSecondary">Frequência de Troca:</Text>
                      <Text fontSize="$3" color="$text">{tratamento.frequenciaTroca}</Text>
                    </XStack>
                  </YStack>
                </Card>
              ))
            ) : (
              <YStack
                padding="$4"
                backgroundColor="$backgroundSecondary"
                borderRadius="$4"
                alignItems="center"
              >
                <Text color="$textSecondary" textAlign="center">
                  Nenhum tratamento anterior registrado.
                </Text>
              </YStack>
            )}
          </YStack>
        </YStack>
      </ScrollView>
    </YStack>
  );
}
