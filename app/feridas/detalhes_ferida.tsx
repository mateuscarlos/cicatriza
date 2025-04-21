import React, { useState, useEffect } from 'react';
import { YStack, XStack, Button, Text, ScrollView, H1, Card, Spinner, View, Image, Tabs, TabsContent } from 'tamagui';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, Edit, Trash2, Calendar, MapPin, FileText, Activity, Clock, Plus, Camera } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';
import { bodyRegionNames } from '../../constants/bodyRegions';

/**
 * Tela de Detalhes da Ferida da aplicação Cicatriza
 * 
 * Esta tela exibe informações detalhadas sobre uma ferida específica,
 * incluindo dados básicos, histórico de avaliações e plano de tratamento.
 */
export default function DetalhesFerida() {
  const router = useRouter();
  const { id, pacienteId } = useLocalSearchParams<{ id: string, pacienteId: string }>();
  const [isLoading, setIsLoading] = useState(true);
  const [ferida, setFerida] = useState(null);
  const [avaliacoes, setAvaliacoes] = useState([]);

  // Carregar dados da ferida
  useEffect(() => {
    const carregarFerida = async () => {
      setIsLoading(true);
      try {
        // Simulação de carregamento de dados - substituir por chamada real ao Firebase
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Dados simulados da ferida
        setFerida({
          id: id,
          pacienteId: pacienteId,
          tipo: 'Úlcera Venosa',
          dimensoes: {
            comprimento: 5.2,
            largura: 3.8,
            profundidade: 0.5,
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
        });
        
        // Dados simulados de avaliações
        setAvaliacoes([
          {
            id: 'a1',
            data: new Date(2025, 2, 15),
            dimensoes: {
              comprimento: 6.0,
              largura: 4.2,
              profundidade: 0.7,
              unidade: 'cm'
            },
            exsudato: {
              tipo: 'Seroso',
              quantidade: 'Moderado'
            },
            tecidos: {
              granulacao: 60,
              fibrina: 30,
              necrose: 10
            },
            bordas: 'Irregulares, maceradas',
            pele: 'Hiperemiada, edemaciada',
            dor: 7,
            odor: 'Leve',
            sinaisInfeccao: true,
            observacoes: 'Paciente relata dor intensa durante a troca de curativo.'
          },
          {
            id: 'a2',
            data: new Date(2025, 3, 1),
            dimensoes: {
              comprimento: 5.5,
              largura: 4.0,
              profundidade: 0.6,
              unidade: 'cm'
            },
            exsudato: {
              tipo: 'Seroso',
              quantidade: 'Pequeno'
            },
            tecidos: {
              granulacao: 70,
              fibrina: 25,
              necrose: 5
            },
            bordas: 'Irregulares, menos maceradas',
            pele: 'Hiperemiada, menos edemaciada',
            dor: 5,
            odor: 'Ausente',
            sinaisInfeccao: false,
            observacoes: 'Melhora significativa na aparência da ferida. Paciente relata menos dor.'
          },
          {
            id: 'a3',
            data: new Date(2025, 3, 10),
            dimensoes: {
              comprimento: 5.2,
              largura: 3.8,
              profundidade: 0.5,
              unidade: 'cm'
            },
            exsudato: {
              tipo: 'Seroso',
              quantidade: 'Pequeno'
            },
            tecidos: {
              granulacao: 80,
              fibrina: 20,
              necrose: 0
            },
            bordas: 'Regulares, epitelizadas',
            pele: 'Levemente hiperemiada',
            dor: 3,
            odor: 'Ausente',
            sinaisInfeccao: false,
            observacoes: 'Continua apresentando melhora. Tecido de granulação saudável.'
          }
        ]);
      } catch (error) {
        console.error('Erro ao carregar ferida:', error);
      } finally {
        setIsLoading(false);
      }
    };

    if (id && pacienteId) {
      carregarFerida();
    }
  }, [id, pacienteId]);

  /**
   * Formata a data para exibição
   */
  const formatarData = (data) => {
    if (!data) return '';
    return data.toLocaleDateString('pt-BR');
  };

  /**
   * Navega para a tela de edição da ferida
   */
  const navegarParaEdicaoFerida = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    router.push(`/(app)/pacientes/${pacienteId}/lesoes/${id}/editar`);
  };

  /**
   * Navega para a tela de nova avaliação
   */
  const navegarParaNovaAvaliacao = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    router.push(`/(app)/pacientes/${pacienteId}/lesoes/${id}/avaliacoes/nova`);
  };

  /**
   * Navega para a tela de detalhes da avaliação
   */
  const navegarParaDetalhesAvaliacao = (avaliacaoId) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.push(`/(app)/pacientes/${pacienteId}/lesoes/${id}/avaliacoes/${avaliacaoId}`);
  };

  /**
   * Navega de volta para a tela anterior
   */
  const voltarParaTelaAnterior = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.back();
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

  // Renderiza o status da ferida com cor apropriada
  const renderizarStatusFerida = (status) => {
    let cor = '';
    let texto = '';
    
    switch (status) {
      case 'active':
        cor = '$red10';
        texto = 'Ativa';
        break;
      case 'healing':
        cor = '$yellow10';
        texto = 'Em cicatrização';
        break;
      case 'healed':
        cor = '$green10';
        texto = 'Cicatrizada';
        break;
      case 'infected':
        cor = '$purple10';
        texto = 'Infectada';
        break;
      default:
        cor = '$gray10';
        texto = 'Desconhecido';
    }
    
    return (
      <View
        backgroundColor={cor.replace('10', '2')}
        paddingHorizontal="$2"
        paddingVertical="$1"
        borderRadius="$2"
      >
        <Text fontSize="$2" color={cor} fontWeight="bold">
          {texto}
        </Text>
      </View>
    );
  };

  if (isLoading) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center" backgroundColor="$background">
        <Spinner size="large" color="$primary" />
        <Text marginTop="$2">Carregando informações da ferida...</Text>
      </YStack>
    );
  }

  if (!ferida) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center" backgroundColor="$background" padding="$4">
        <Text color="$textSecondary" textAlign="center">
          Ferida não encontrada.
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
            <H1 fontSize="$6" color="$text">Detalhes da Lesão</H1>
            <Button
              size="$3"
              backgroundColor="$backgroundSecondary"
              icon={<Edit size={18} color="$text" />}
              onPress={navegarParaEdicaoFerida}
            >
              Editar
            </Button>
          </XStack>

          {/* Informações Básicas da Ferida */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <XStack justifyContent="space-between" alignItems="center" marginBottom="$3">
              <Text fontSize="$6" fontWeight="bold" color="$text">
                {ferida.tipo}
              </Text>
              {renderizarStatusFerida(ferida.status)}
            </XStack>
            
            <XStack alignItems="center" space="$2" marginBottom="$2">
              <MapPin size={18} color="$textSecondary" />
              <Text fontSize="$4" color="$text">
                {ferida.localizacao} ({bodyRegionNames[ferida.regiao] || 'Região não especificada'})
              </Text>
            </XStack>
            
            <XStack alignItems="center" space="$2" marginBottom="$2">
              <Calendar size={18} color="$textSecondary" />
              <Text fontSize="$4" color="$textSecondary">
                Início: {formatarData(ferida.dataInicio)}
              </Text>
            </XStack>
            
            <XStack alignItems="center" space="$2">
              <Activity size={18} color="$textSecondary" />
              <Text fontSize="$4" color="$textSecondary">
                Última avaliação: {formatarData(ferida.ultimaAvaliacao)}
              </Text>
            </XStack>
          </Card>

          {/* Imagem da Ferida */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Imagem da Lesão
            </Text>
            
            {ferida.imagemUrl ? (
              <YStack alignItems="center">
                <Image
                  source={{ uri: ferida.imagemUrl }}
                  width={300}
                  height={200}
                  borderRadius="$2"
                  resizeMode="cover"
                />
                <Text fontSize="$3" color="$textSecondary" marginTop="$2">
                  Última atualização: {formatarData(ferida.atualizadoEm)}
                </Text>
              </YStack>
            ) : (
              <YStack
                width="100%"
                height={200}
                backgroundColor="$background"
                borderRadius="$2"
                justifyContent="center"
                alignItems="center"
                borderWidth={1}
                borderColor="$border"
                borderStyle="dashed"
              >
                <Camera size={40} color="$textSecondary" />
                <Text marginTop="$2" color="$textSecondary">Nenhuma imagem disponível</Text>
              </YStack>
            )}
          </Card>

          {/* Dimensões da Ferida */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Dimensões
            </Text>
            
            <XStack justifyContent="space-between" marginBottom="$2">
              <Text fontSize="$4" color="$textSecondary">Comprimento:</Text>
              <Text fontSize="$4" color="$text">{ferida.dimensoes.comprimento} {ferida.dimensoes.unidade}</Text>
            </XStack>
            
            <XStack justifyContent="space-between" marginBottom="$2">
              <Text fontSize="$4" color="$textSecondary">Largura:</Text>
              <Text fontSize="$4" color="$text">{ferida.dimensoes.largura} {ferida.dimensoes.unidade}</Text>
            </XStack>
            
            {ferida.dimensoes.profundidade && (
              <XStack justifyContent="space-between" marginBottom="$2">
                <Text fontSize="$4" color="$textSecondary">Profundidade:</Text>
                <Text fontSize="$4" color="$text">{ferida.dimensoes.profundidade} {ferida.dimensoes.unidade}</Text>
              </XStack>
            )}
            
            <XStack justifyContent="space-between">
              <Text fontSize="$4" color="$textSecondary">Área aproximada:</Text>
              <Text fontSize="$4" color="$text">
                {(ferida.dimensoes.comprimento * ferida.dimensoes.largura).toFixed(1)} {ferida.dimensoes.unidade}²
              </Text>
            </XStack>
          </Card>

          {/* Descrição da Ferida */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Descrição
            </Text>
            
            <Text fontSize="$4" color="$text">
              {ferida.descricao}
            </Text>
          </Card>

          {/* Abas de Avaliações e Tratamento */}
          <Tabs
            defaultValue="avaliacoes"
            orientation="horizontal"
            flexDirection="column"
            backgroundColor="$backgroundSecondary"
            borderRadius="$4"
          >
            <Tabs.List>
              <Tabs.Tab value="avaliacoes" flex={1}>
                <Text>Avaliações</Text>
              </Tabs.Tab>
              <Tabs.Tab value="tratamento" flex={1}>
                <Text>Tratamento</Text>
              </Tabs.Tab>
            </Tabs.List>

            {/* Aba de Avaliações */}
            <TabsContent value="avaliacoes" padding="$4">
              <YStack space="$4">
                <XStack justifyContent="space-between" alignItems="center">
                  <Text fontSize="$5" fontWeight="bold" color="$text">
                    Histórico de Avaliações
                  </Text>
                  <Button
                    size="$3"
                    backgroundColor="$primary"
                    color="white"
                    icon={<Plus size={16} color="white" />}
                    onPress={navegarParaNovaAvaliacao}
                  >
                    Nova Avaliação
                  </Button>
                </XStack>

                {avaliacoes.length > 0 ? (
                  <YStack space="$3">
                    {avaliacoes.map((avaliacao, index) => (
                      <Card
                        key={avaliacao.id}
                        padding="$3"
                        backgroundColor="$background"
                        borderRadius="$4"
                        pressStyle={{ opacity: 0.8, scale: 0.98 }}
                        animation="bouncy"
                        onPress={() => navegarParaDetalhesAvaliacao(avaliacao.id)}
                      >
                        <XStack justifyContent="space-between" alignItems="center" marginBottom="$2">
                          <XStack alignItems="center" space="$2">
                            <Calendar size={16} color="$textSecondary" />
                            <Text fontSize="$4" fontWeight="bold" color="$text">
                              {formatarData(avaliacao.data)}
                            </Text>
                          </XStack>
                          <Text fontSize="$3" color="$textSecondary">
                            {index === 0 ? 'Avaliação Inicial' : `Avaliação #${index + 1}`}
                          </Text>
                        </XStack>
                      </Card>
                    ))}
                  </YStack>
                ) : (
                  <Text fontSize="$4" color="$textSecondary" textAlign="center">
                    Nenhuma avaliação registrada.
                  </Text>
                )}
              </YStack>
            </TabsContent>

            {/* Aba de Tratamento */}
            <TabsContent value="tratamento" padding="$4">
              <YStack space="$4">
                <Text fontSize="$5" fontWeight="bold" color="$text">
                  Plano de Tratamento
                </Text>
                <Text fontSize="$4" color="$text">
                  {/* Simulação de plano de tratamento - substituir por dados reais */}
                  O plano de tratamento inclui limpeza diária da ferida, aplicação de pomada antibiótica e troca de curativos a cada 48 horas.
                </Text>
              </YStack>
            </TabsContent>
          </Tabs>
        </YStack>
      </ScrollView>
    </YStack>
  );
}