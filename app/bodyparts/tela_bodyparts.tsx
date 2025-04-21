import React, { useState, useEffect } from 'react';
import { YStack, XStack, Button, Text, ScrollView, H1, Card, Spinner, View } from 'tamagui';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, RotateCcw, Check, Plus, MapPin } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';
import { BodySilhouette } from './componente_silhueta';
import { bodyRegionNames } from '../../constants/bodyRegions';

/**
 * Tela Bodyparts da aplicação Cicatriza
 * 
 * Esta tela exibe uma silhueta humana interativa que permite selecionar
 * regiões anatômicas para visualizar ou cadastrar lesões. Regiões com
 * lesões já cadastradas são destacadas em vermelho.
 */
export default function BodypartsScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(true);
  const [paciente, setPaciente] = useState(null);
  const [lesoes, setLesoes] = useState([]);
  
  const [view, setView] = useState<'front' | 'back'>('front');
  const [selectedRegion, setSelectedRegion] = useState<string | null>(null);
  const [regionsWithWounds, setRegionsWithWounds] = useState<string[]>([]);
  
  // Carregar dados do paciente e lesões
  useEffect(() => {
    const carregarDados = async () => {
      setIsLoading(true);
      try {
        // Simulação de carregamento de dados - substituir por chamada real ao Firebase
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Dados simulados do paciente
        setPaciente({
          id: id,
          nome: 'Maria Silva',
          genero: 'female',
          dataNascimento: new Date(1980, 5, 15),
        });
        
        // Dados simulados de lesões
        const lesoesSimuladas = [
          {
            id: 'l1',
            tipo: 'Úlcera Venosa',
            localizacao: 'Perna Direita',
            regiao: 'leg_right_lower',
            dataInicio: new Date(2025, 2, 15),
            status: 'active',
          },
          {
            id: 'l2',
            tipo: 'Lesão por Pressão',
            localizacao: 'Calcanhar Esquerdo',
            regiao: 'foot_left',
            dataInicio: new Date(2025, 3, 1),
            status: 'healing',
          }
        ];
        
        setLesoes(lesoesSimuladas);
        
        // Mapear regiões com lesões
        const regioes = lesoesSimuladas.map(lesao => lesao.regiao);
        setRegionsWithWounds([...new Set(regioes)]); // Remover duplicatas
      } catch (error) {
        console.error('Erro ao carregar dados:', error);
      } finally {
        setIsLoading(false);
      }
    };

    if (id) {
      carregarDados();
    }
  }, [id]);

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
  
  /**
   * Manipula o evento de pressionar uma região da silhueta
   */
  const handleRegionPress = (regionId: string) => {
    setSelectedRegion(regionId);
    
    // Se a região já tem uma lesão cadastrada, navegar para os detalhes
    if (regionsWithWounds.includes(regionId)) {
      const lesao = lesoes.find(l => l.regiao === regionId);
      if (lesao) {
        router.push(`/(app)/pacientes/${id}/lesoes/${lesao.id}`);
        return;
      }
    }
    
    // Caso contrário, navegar para o cadastro de nova lesão
    router.push(`/(app)/pacientes/${id}/lesoes/nova?regiao=${regionId}`);
  };
  
  /**
   * Alterna entre as vistas frontal e posterior da silhueta
   */
  const toggleView = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    setView(view === 'front' ? 'back' : 'front');
    setSelectedRegion(null);
  };
  
  /**
   * Conclui o fluxo e retorna para a tela de detalhes do paciente
   */
  const handleComplete = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    router.replace(`/(app)/pacientes/${id}`);
  };
  
  /**
   * Navega para a tela de cadastro de nova lesão sem selecionar região
   */
  const navegarParaCadastroLesao = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    router.push(`/(app)/pacientes/${id}/lesoes/nova`);
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
        <Text marginTop="$2">Carregando...</Text>
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
            
            <H1 fontSize="$6" color="$text">Localização da Lesão</H1>
            
            <Button
              size="$3"
              backgroundColor="$primary"
              color="white"
              icon={<Check size={18} color="white" />}
              onPress={handleComplete}
            >
              Concluir
            </Button>
          </XStack>
          
          {/* Informações do Paciente */}
          {paciente && (
            <Card bordered padding="$3">
              <Text fontWeight="600">{paciente.nome}</Text>
              <Text size="$2" color="$textSecondary">
                {paciente.genero === 'male' ? 'Masculino' : 'Feminino'} • 
                {calcularIdade(paciente.dataNascimento)} anos
              </Text>
            </Card>
          )}
          
          {/* Instruções */}
          <Text textAlign="center" color="$textSecondary">
            {regionsWithWounds.length > 0 
              ? 'Selecione a região do corpo para visualizar ou adicionar lesões' 
              : 'Selecione a região do corpo onde está localizada a lesão'}
          </Text>
          
          {/* Silhueta Humana */}
          <YStack alignItems="center" marginVertical="$4">
            <BodySilhouette
              view={view}
              regionsWithWounds={regionsWithWounds}
              onRegionPress={handleRegionPress}
              highlightColor="#FF3B30"
              baseColor="#E5E5EA"
            />
            
            {/* Botões de Ação */}
            <XStack space="$4" marginTop="$4">
              <Button
                size="$4"
                backgroundColor="$secondary"
                color="white"
                icon={<RotateCcw size={18} color="white" />}
                onPress={toggleView}
              >
                {view === 'front' ? 'Virar para Costas' : 'Virar para Frente'}
              </Button>
              
              <Button
                size="$4"
                backgroundColor="$primary"
                color="white"
                icon={<Plus size={18} color="white" />}
                onPress={navegarParaCadastroLesao}
              >
                Nova Lesão
              </Button>
            </XStack>
          </YStack>
          
          {/* Região Selecionada */}
          {selectedRegion && (
            <Card bordered padding="$3" backgroundColor="$backgroundSecondary">
              <XStack alignItems="center" space="$2">
                <MapPin size={18} color="$text" />
                <Text fontWeight="600">
                  Região selecionada: {bodyRegionNames[selectedRegion] || 'Não especificada'}
                </Text>
              </XStack>
            </Card>
          )}
          
          {/* Legenda */}
          <Card bordered padding="$3" backgroundColor="$backgroundSecondary">
            <Text fontWeight="600" marginBottom="$2">Legenda:</Text>
            <XStack space="$4">
              <XStack alignItems="center" space="$2">
                <View width={16} height={16} backgroundColor="#E5E5EA" borderRadius={8} />
                <Text>Sem lesões</Text>
              </XStack>
              <XStack alignItems="center" space="$2">
                <View width={16} height={16} backgroundColor="#FF3B30" borderRadius={8} />
                <Text>Com lesões</Text>
              </XStack>
            </XStack>
          </Card>
        </YStack>
      </ScrollView>
    </YStack>
  );
}
