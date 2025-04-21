import React, { useState, useEffect } from 'react';
import { YStack, XStack, Button, Text, ScrollView, H1, Card, Spinner, View, Image, Tabs, TabsContent } from 'tamagui';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, Edit, Calendar, Thermometer, Droplet, FileText, Activity, Clock } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';

/**
 * Tela de Detalhes da Avaliação da aplicação Cicatriza
 * 
 * Esta tela exibe informações detalhadas sobre uma avaliação específica de ferida,
 * incluindo dimensões, características do tecido, exsudato, bordas, pele perilesional,
 * dor, odor, sinais de infecção e observações.
 */
export default function DetalhesAvaliacaoScreen() {
  const router = useRouter();
  const { id, feridaId, pacienteId } = useLocalSearchParams<{ id: string, feridaId: string, pacienteId: string }>();
  const [isLoading, setIsLoading] = useState(true);
  const [avaliacao, setAvaliacao] = useState(null);
  const [ferida, setFerida] = useState(null);

  // Carregar dados da avaliação
  useEffect(() => {
    const carregarAvaliacao = async () => {
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
          regiao: 'leg_right_lower'
        });
        
        // Dados simulados da avaliação
        setAvaliacao({
          id: id,
          feridaId: feridaId,
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
          observacoes: 'Continua apresentando melhora. Tecido de granulação saudável.',
          imagemUrl: 'https://example.com/images/wound_assessment.jpg',
          criadoEm: new Date(2025, 3, 10),
          atualizadoEm: new Date(2025, 3, 10)
        });
      } catch (error) {
        console.error('Erro ao carregar avaliação:', error);
      } finally {
        setIsLoading(false);
      }
    };

    if (id && feridaId && pacienteId) {
      carregarAvaliacao();
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
   * Navega para a tela de edição da avaliação
   */
  const navegarParaEdicaoAvaliacao = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    router.push(`/(app)/pacientes/${pacienteId}/lesoes/${feridaId}/avaliacoes/${id}/editar`);
  };

  /**
   * Navega de volta para a tela anterior
   */
  const voltarParaTelaAnterior = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.back();
  };

  if (isLoading) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center" backgroundColor="$background">
        <Spinner size="large" color="$primary" />
        <Text marginTop="$2">Carregando informações da avaliação...</Text>
      </YStack>
    );
  }

  if (!avaliacao) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center" backgroundColor="$background" padding="$4">
        <Text color="$textSecondary" textAlign="center">
          Avaliação não encontrada.
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
            <H1 fontSize="$6" color="$text">Detalhes da Avaliação</H1>
            <Button
              size="$3"
              backgroundColor="$backgroundSecondary"
              icon={<Edit size={18} color="$text" />}
              onPress={navegarParaEdicaoAvaliacao}
            >
              Editar
            </Button>
          </XStack>

          {/* Informações Básicas */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <XStack justifyContent="space-between" alignItems="center" marginBottom="$3">
              <Text fontSize="$6" fontWeight="bold" color="$text">
                {ferida?.tipo}
              </Text>
            </XStack>
            
            <XStack alignItems="center" space="$2" marginBottom="$2">
              <Calendar size={18} color="$textSecondary" />
              <Text fontSize="$4" color="$text">
                Data da Avaliação: {formatarData(avaliacao.data)}
              </Text>
            </XStack>
            
            <XStack alignItems="center" space="$2">
              <Activity size={18} color="$textSecondary" />
              <Text fontSize="$4" color="$textSecondary">
                Localização: {ferida?.localizacao}
              </Text>
            </XStack>
          </Card>

          {/* Imagem da Avaliação */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Imagem da Avaliação
            </Text>
            
            {avaliacao.imagemUrl ? (
              <YStack alignItems="center">
                <Image
                  source={{ uri: avaliacao.imagemUrl }}
                  width={300}
                  height={200}
                  borderRadius="$2"
                  resizeMode="cover"
                />
                <Text fontSize="$3" color="$textSecondary" marginTop="$2">
                  Registrada em: {formatarData(avaliacao.criadoEm)}
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
                <Text color="$textSecondary">Nenhuma imagem disponível</Text>
              </YStack>
            )}
          </Card>

          {/* Dimensões */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Dimensões
            </Text>
            
            <XStack justifyContent="space-between" marginBottom="$2">
              <Text fontSize="$4" color="$textSecondary">Comprimento:</Text>
              <Text fontSize="$4" color="$text">{avaliacao.dimensoes.comprimento} {avaliacao.dimensoes.unidade}</Text>
            </XStack>
            
            <XStack justifyContent="space-between" marginBottom="$2">
              <Text fontSize="$4" color="$textSecondary">Largura:</Text>
              <Text fontSize="$4" color="$text">{avaliacao.dimensoes.largura} {avaliacao.dimensoes.unidade}</Text>
            </XStack>
            
            {avaliacao.dimensoes.profundidade && (
              <XStack justifyContent="space-between" marginBottom="$2">
                <Text fontSize="$4" color="$textSecondary">Profundidade:</Text>
                <Text fontSize="$4" color="$text">{avaliacao.dimensoes.profundidade} {avaliacao.dimensoes.unidade}</Text>
              </XStack>
            )}
            
            <XStack justifyContent="space-between">
              <Text fontSize="$4" color="$textSecondary">Área aproximada:</Text>
              <Text fontSize="$4" color="$text">
                {(avaliacao.dimensoes.comprimento * avaliacao.dimensoes.largura).toFixed(1)} {avaliacao.dimensoes.unidade}²
              </Text>
            </XStack>
          </Card>

          {/* Tecidos */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Tecidos
            </Text>
            
            <YStack space="$3">
              <XStack justifyContent="space-between">
                <Text fontSize="$4" color="$textSecondary">Tecido de Granulação:</Text>
                <Text fontSize="$4" color="$text">{avaliacao.tecidos.granulacao}%</Text>
              </XStack>
              
              <View
                width="100%"
                height={20}
                backgroundColor="$background"
                borderRadius="$2"
                overflow="hidden"
              >
                <View
                  width={`${avaliacao.tecidos.granulacao}%`}
                  height="100%"
                  backgroundColor="$green10"
                />
              </View>
            </YStack>
            
            <YStack space="$3" marginTop="$3">
              <XStack justifyContent="space-between">
                <Text fontSize="$4" color="$textSecondary">Tecido de Fibrina:</Text>
                <Text fontSize="$4" color="$text">{avaliacao.tecidos.fibrina}%</Text>
              </XStack>
              
              <View
                width="100%"
                height={20}
                backgroundColor="$background"
                borderRadius="$2"
                overflow="hidden"
              >
                <View
                  width={`${avaliacao.tecidos.fibrina}%`}
                  height="100%"
                  backgroundColor="$yellow10"
                />
              </View>
            </YStack>
            
            <YStack space="$3" marginTop="$3">
              <XStack justifyContent="space-between">
                <Text fontSize="$4" color="$textSecondary">Tecido Necrótico:</Text>
                <Text fontSize="$4" color="$text">{avaliacao.tecidos.necrose}%</Text>
              </XStack>
              
              <View
                width="100%"
                height={20}
                backgroundColor="$background"
                borderRadius="$2"
                overflow="hidden"
              >
                <View
                  width={`${avaliacao.tecidos.necrose}%`}
                  height="100%"
                  backgroundColor="$gray10"
                />
              </View>
            </YStack>
          </Card>

          {/* Exsudato */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Exsudato
            </Text>
            
            <XStack justifyContent="space-between" marginBottom="$2">
              <Text fontSize="$4" color="$textSecondary">Tipo:</Text>
              <Text fontSize="$4" color="$text">{avaliacao.exsudato.tipo}</Text>
            </XStack>
            
            <XStack justifyContent="space-between">
              <Text fontSize="$4" color="$textSecondary">Quantidade:</Text>
              <Text fontSize="$4" color="$text">{avaliacao.exsudato.quantidade}</Text>
            </XStack>
          </Card>

          {/* Bordas e Pele */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Bordas e Pele Perilesional
            </Text>
            
            <YStack space="$3">
              <Text fontSize="$4" color="$textSecondary">Bordas:</Text>
              <Text fontSize="$4" color="$text">{avaliacao.bordas}</Text>
            </YStack>
            
            <YStack space="$3" marginTop="$3">
              <Text fontSize="$4" color="$textSecondary">Pele Perilesional:</Text>
              <Text fontSize="$4" color="$text">{avaliacao.pele}</Text>
            </YStack>
          </Card>

          {/* Sinais e Sintomas */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Sinais e Sintomas
            </Text>
            
            <YStack space="$3">
              <XStack justifyContent="space-between">
                <Text fontSize="$4" color="$textSecondary">Nível de Dor (0-10):</Text>
                <Text fontSize="$4" color="$text">{avaliacao.dor}</Text>
              </XStack>
              
              <View
                width="100%"
                height={20}
                backgroundColor="$background"
                borderRadius="$2"
                overflow="hidden"
              >
                <View
                  width={`${avaliacao.dor * 10}%`}
                  height="100%"
                  backgroundColor="$red10"
                />
              </View>
            </YStack>
            
            <XStack justifyContent="space-between" marginTop="$3">
              <Text fontSize="$4" color="$textSecondary">Odor:</Text>
              <Text fontSize="$4" color="$text">{avaliacao.odor}</Text>
            </XStack>
            
            <XStack justifyContent="space-between" marginTop="$3">
              <Text fontSize="$4" color="$textSecondary">Sinais de Infecção:</Text>
              <Text fontSize="$4" color="$text">{avaliacao.sinaisInfeccao ? 'Sim' : 'Não'}</Text>
            </XStack>
          </Card>

          {/* Observações */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Observações
            </Text>
            
            <Text fontSize="$4" color="$text">
              {avaliacao.observacoes || 'Nenhuma observação registrada.'}
            </Text>
          </Card>
        </YStack>
      </ScrollView>
    </YStack>
  );
}
