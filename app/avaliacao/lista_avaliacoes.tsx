import React, { useState, useEffect } from 'react';
import { YStack, XStack, Button, Text, ScrollView, H1, Card, Spinner, View, Separator } from 'tamagui';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, Plus, Calendar, FileText, ChevronRight, Activity } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';

/**
 * Tela de Lista de Avaliações da aplicação Cicatriza
 * 
 * Esta tela exibe todas as avaliações registradas para uma ferida específica,
 * permitindo visualizar o histórico de evolução e acessar os detalhes de cada avaliação.
 */
export default function ListaAvaliacoesScreen() {
  const router = useRouter();
  const { feridaId, pacienteId } = useLocalSearchParams<{ feridaId: string, pacienteId: string }>();
  const [isLoading, setIsLoading] = useState(true);
  const [avaliacoes, setAvaliacoes] = useState([]);
  const [ferida, setFerida] = useState(null);

  // Carregar dados da ferida e avaliações
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
        
        // Dados simulados das avaliações
        const avaliacoesSimuladas = [
          {
            id: 'aval1',
            feridaId: feridaId,
            data: new Date(2025, 3, 10),
            dimensoes: {
              comprimento: 5.2,
              largura: 3.8,
              profundidade: 0.5,
              unidade: 'cm'
            },
            tecidos: {
              granulacao: 80,
              fibrina: 20,
              necrose: 0
            },
            exsudato: {
              tipo: 'Seroso',
              quantidade: 'Pequeno'
            },
            criadoEm: new Date(2025, 3, 10)
          },
          {
            id: 'aval2',
            feridaId: feridaId,
            data: new Date(2025, 3, 3),
            dimensoes: {
              comprimento: 5.5,
              largura: 4.0,
              profundidade: 0.7,
              unidade: 'cm'
            },
            tecidos: {
              granulacao: 70,
              fibrina: 25,
              necrose: 5
            },
            exsudato: {
              tipo: 'Serosanguinolento',
              quantidade: 'Moderado'
            },
            criadoEm: new Date(2025, 3, 3)
          },
          {
            id: 'aval3',
            feridaId: feridaId,
            data: new Date(2025, 2, 25),
            dimensoes: {
              comprimento: 6.0,
              largura: 4.5,
              profundidade: 1.0,
              unidade: 'cm'
            },
            tecidos: {
              granulacao: 60,
              fibrina: 30,
              necrose: 10
            },
            exsudato: {
              tipo: 'Serosanguinolento',
              quantidade: 'Grande'
            },
            criadoEm: new Date(2025, 2, 25)
          }
        ];
        
        setAvaliacoes(avaliacoesSimuladas);
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
   * Navega para a tela de detalhes da avaliação
   */
  const navegarParaDetalhesAvaliacao = (avaliacaoId) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.push(`/(app)/pacientes/${pacienteId}/lesoes/${feridaId}/avaliacoes/${avaliacaoId}`);
  };

  /**
   * Navega para a tela de nova avaliação
   */
  const navegarParaNovaAvaliacao = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    router.push(`/(app)/pacientes/${pacienteId}/lesoes/${feridaId}/avaliacoes/nova`);
  };

  /**
   * Navega de volta para a tela anterior
   */
  const voltarParaTelaAnterior = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.back();
  };

  /**
   * Calcula a área da ferida
   */
  const calcularArea = (comprimento, largura) => {
    return (comprimento * largura).toFixed(1);
  };

  /**
   * Determina a tendência da ferida (melhorando, piorando, estável)
   */
  const determinarTendencia = (avaliacaoAtual, avaliacaoAnterior) => {
    if (!avaliacaoAnterior) return null;
    
    const areaAtual = avaliacaoAtual.dimensoes.comprimento * avaliacaoAtual.dimensoes.largura;
    const areaAnterior = avaliacaoAnterior.dimensoes.comprimento * avaliacaoAnterior.dimensoes.largura;
    
    const diferencaPercentual = ((areaAtual - areaAnterior) / areaAnterior) * 100;
    
    if (diferencaPercentual <= -5) {
      return { texto: 'Melhorando', cor: '$green10' };
    } else if (diferencaPercentual >= 5) {
      return { texto: 'Piorando', cor: '$red10' };
    } else {
      return { texto: 'Estável', cor: '$yellow10' };
    }
  };

  if (isLoading) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center" backgroundColor="$background">
        <Spinner size="large" color="$primary" />
        <Text marginTop="$2">Carregando avaliações...</Text>
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
            <H1 fontSize="$6" color="$text">Avaliações</H1>
            <Button
              size="$3"
              backgroundColor="$primary"
              color="white"
              icon={<Plus size={18} color="white" />}
              onPress={navegarParaNovaAvaliacao}
            >
              Nova
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

          {/* Resumo da Evolução */}
          {avaliacoes.length >= 2 && (
            <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
              <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
                Evolução da Lesão
              </Text>
              
              <YStack space="$3">
                {/* Área */}
                <YStack space="$1">
                  <Text fontSize="$4" color="$textSecondary">Área:</Text>
                  <XStack space="$2" alignItems="center">
                    <Text fontSize="$4" color="$text">
                      {calcularArea(avaliacoes[0].dimensoes.comprimento, avaliacoes[0].dimensoes.largura)} {avaliacoes[0].dimensoes.unidade}²
                    </Text>
                    <Text fontSize="$3" color="$textSecondary">
                      (Inicial: {calcularArea(avaliacoes[avaliacoes.length - 1].dimensoes.comprimento, avaliacoes[avaliacoes.length - 1].dimensoes.largura)} {avaliacoes[avaliacoes.length - 1].dimensoes.unidade}²)
                    </Text>
                  </XStack>
                </YStack>
                
                {/* Tendência */}
                {determinarTendencia(avaliacoes[0], avaliacoes[1]) && (
                  <YStack space="$1">
                    <Text fontSize="$4" color="$textSecondary">Tendência:</Text>
                    <Text fontSize="$4" color={determinarTendencia(avaliacoes[0], avaliacoes[1]).cor}>
                      {determinarTendencia(avaliacoes[0], avaliacoes[1]).texto}
                    </Text>
                  </YStack>
                )}
                
                {/* Tecido de Granulação */}
                <YStack space="$1">
                  <Text fontSize="$4" color="$textSecondary">Tecido de Granulação:</Text>
                  <XStack space="$2" alignItems="center">
                    <Text fontSize="$4" color="$text">
                      {avaliacoes[0].tecidos.granulacao}%
                    </Text>
                    <Text fontSize="$3" color="$textSecondary">
                      (Inicial: {avaliacoes[avaliacoes.length - 1].tecidos.granulacao}%)
                    </Text>
                  </XStack>
                </YStack>
              </YStack>
            </Card>
          )}

          {/* Lista de Avaliações */}
          <YStack space="$3">
            <Text fontSize="$5" fontWeight="bold" color="$text">
              Histórico de Avaliações
            </Text>
            
            {avaliacoes.length > 0 ? (
              avaliacoes.map((avaliacao, index) => (
                <Card
                  key={avaliacao.id}
                  padding="$4"
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  borderWidth={1}
                  borderRadius="$4"
                  pressStyle={{ opacity: 0.8, scale: 0.98 }}
                  onPress={() => navegarParaDetalhesAvaliacao(avaliacao.id)}
                >
                  <XStack justifyContent="space-between" alignItems="center" marginBottom="$2">
                    <XStack alignItems="center" space="$2">
                      <Calendar size={18} color="$primary" />
                      <Text fontSize="$4" fontWeight="bold" color="$text">
                        {formatarData(avaliacao.data)}
                      </Text>
                    </XStack>
                    <ChevronRight size={18} color="$textSecondary" />
                  </XStack>
                  
                  <Separator marginVertical="$2" />
                  
                  <YStack space="$2">
                    <XStack justifyContent="space-between">
                      <Text fontSize="$3" color="$textSecondary">Dimensões:</Text>
                      <Text fontSize="$3" color="$text">
                        {avaliacao.dimensoes.comprimento} × {avaliacao.dimensoes.largura} {avaliacao.dimensoes.unidade}
                        {avaliacao.dimensoes.profundidade ? ` × ${avaliacao.dimensoes.profundidade} ${avaliacao.dimensoes.unidade}` : ''}
                      </Text>
                    </XStack>
                    
                    <XStack justifyContent="space-between">
                      <Text fontSize="$3" color="$textSecondary">Área:</Text>
                      <Text fontSize="$3" color="$text">
                        {calcularArea(avaliacao.dimensoes.comprimento, avaliacao.dimensoes.largura)} {avaliacao.dimensoes.unidade}²
                      </Text>
                    </XStack>
                    
                    <XStack justifyContent="space-between">
                      <Text fontSize="$3" color="$textSecondary">Exsudato:</Text>
                      <Text fontSize="$3" color="$text">
                        {avaliacao.exsudato.tipo}, {avaliacao.exsudato.quantidade}
                      </Text>
                    </XStack>
                    
                    <XStack justifyContent="space-between">
                      <Text fontSize="$3" color="$textSecondary">Tecido de Granulação:</Text>
                      <Text fontSize="$3" color="$text">{avaliacao.tecidos.granulacao}%</Text>
                    </XStack>
                    
                    {index > 0 && (
                      <XStack justifyContent="space-between">
                        <Text fontSize="$3" color="$textSecondary">Comparação:</Text>
                        <Text
                          fontSize="$3"
                          color={determinarTendencia(avaliacao, avaliacoes[index - 1])?.cor || '$textSecondary'}
                        >
                          {determinarTendencia(avaliacao, avaliacoes[index - 1])?.texto || 'N/A'}
                        </Text>
                      </XStack>
                    )}
                  </YStack>
                </Card>
              ))
            ) : (
              <YStack
                padding="$4"
                backgroundColor="$backgroundSecondary"
                borderRadius="$4"
                alignItems="center"
                space="$3"
              >
                <Text color="$textSecondary" textAlign="center">
                  Nenhuma avaliação registrada para esta lesão.
                </Text>
                <Button
                  size="$4"
                  backgroundColor="$primary"
                  color="white"
                  icon={<Plus size={18} color="white" />}
                  onPress={navegarParaNovaAvaliacao}
                >
                  Registrar Primeira Avaliação
                </Button>
              </YStack>
            )}
          </YStack>
        </YStack>
      </ScrollView>
    </YStack>
  );
}
