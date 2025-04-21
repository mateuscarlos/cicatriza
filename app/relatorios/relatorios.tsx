import React, { useState, useEffect } from 'react';
import { YStack, XStack, Button, Text, ScrollView, H1, Card, Spinner, View, Separator, Select } from 'tamagui';
import { useRouter } from 'expo-router';
import { ArrowLeft, FileText, Download, Printer, Share, Filter, Calendar, User, Search } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';

/**
 * Tela de Relatórios da aplicação Cicatriza
 * 
 * Esta tela permite gerar e visualizar diferentes tipos de relatórios,
 * incluindo relatórios de pacientes, lesões, tratamentos e estatísticas.
 */
export default function RelatoriosScreen() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const [tipoRelatorio, setTipoRelatorio] = useState('pacientes');
  const [periodoRelatorio, setPeriodoRelatorio] = useState('ultimo_mes');
  const [relatoriosRecentes, setRelatoriosRecentes] = useState([]);

  // Carregar relatórios recentes
  useEffect(() => {
    const carregarRelatoriosRecentes = async () => {
      try {
        // Simulação de carregamento de dados - substituir por chamada real ao Firebase
        await new Promise(resolve => setTimeout(resolve, 500));
        
        // Dados simulados de relatórios recentes
        const relatoriosSimulados = [
          {
            id: 'rel1',
            tipo: 'pacientes',
            titulo: 'Relatório de Pacientes',
            dataGeracao: new Date(2025, 3, 15),
            formato: 'PDF',
            tamanho: '1.2 MB',
            url: 'https://example.com/relatorios/pacientes_20250415.pdf'
          },
          {
            id: 'rel2',
            tipo: 'lesoes',
            titulo: 'Relatório de Lesões',
            dataGeracao: new Date(2025, 3, 10),
            formato: 'PDF',
            tamanho: '2.5 MB',
            url: 'https://example.com/relatorios/lesoes_20250410.pdf'
          },
          {
            id: 'rel3',
            tipo: 'tratamentos',
            titulo: 'Relatório de Tratamentos',
            dataGeracao: new Date(2025, 3, 5),
            formato: 'PDF',
            tamanho: '1.8 MB',
            url: 'https://example.com/relatorios/tratamentos_20250405.pdf'
          },
          {
            id: 'rel4',
            tipo: 'estatisticas',
            titulo: 'Estatísticas de Cicatrização',
            dataGeracao: new Date(2025, 3, 1),
            formato: 'PDF',
            tamanho: '0.9 MB',
            url: 'https://example.com/relatorios/estatisticas_20250401.pdf'
          }
        ];
        
        setRelatoriosRecentes(relatoriosSimulados);
      } catch (error) {
        console.error('Erro ao carregar relatórios recentes:', error);
      }
    };

    carregarRelatoriosRecentes();
  }, []);

  /**
   * Formata a data para exibição
   */
  const formatarData = (data) => {
    if (!data) return '';
    return data.toLocaleDateString('pt-BR');
  };

  /**
   * Gera um novo relatório
   */
  const gerarRelatorio = async () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    setIsLoading(true);
    
    try {
      // Simulação de geração de relatório - substituir pela implementação real
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      // Adicionar novo relatório à lista de recentes
      const novoRelatorio = {
        id: `rel${Date.now()}`,
        tipo: tipoRelatorio,
        titulo: obterTituloRelatorio(tipoRelatorio),
        dataGeracao: new Date(),
        formato: 'PDF',
        tamanho: '1.5 MB',
        url: `https://example.com/relatorios/${tipoRelatorio}_${new Date().toISOString().split('T')[0].replace(/-/g, '')}.pdf`
      };
      
      setRelatoriosRecentes([novoRelatorio, ...relatoriosRecentes]);
      
      // Simular abertura do relatório
      alert(`Relatório de ${obterTituloRelatorio(tipoRelatorio)} gerado com sucesso!`);
    } catch (error) {
      console.error('Erro ao gerar relatório:', error);
      alert('Erro ao gerar relatório. Tente novamente.');
    } finally {
      setIsLoading(false);
    }
  };

  /**
   * Obtém o título do relatório com base no tipo
   */
  const obterTituloRelatorio = (tipo) => {
    switch (tipo) {
      case 'pacientes':
        return 'Pacientes';
      case 'lesoes':
        return 'Lesões';
      case 'tratamentos':
        return 'Tratamentos';
      case 'estatisticas':
        return 'Estatísticas de Cicatrização';
      case 'prescricoes':
        return 'Prescrições';
      default:
        return 'Relatório';
    }
  };

  /**
   * Abre um relatório existente
   */
  const abrirRelatorio = (relatorio) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    // Simulação de abertura de relatório - substituir pela implementação real
    alert(`Abrindo relatório: ${relatorio.titulo}`);
  };

  /**
   * Compartilha um relatório
   */
  const compartilharRelatorio = (relatorio) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    // Simulação de compartilhamento - substituir pela implementação real
    alert(`Compartilhando relatório: ${relatorio.titulo}`);
  };

  /**
   * Obtém o ícone para o tipo de relatório
   */
  const obterIconeRelatorio = (tipo) => {
    switch (tipo) {
      case 'pacientes':
        return <User size={18} color="$primary" />;
      case 'lesoes':
        return <FileText size={18} color="$primary" />;
      case 'tratamentos':
        return <FileText size={18} color="$primary" />;
      case 'estatisticas':
        return <FileText size={18} color="$primary" />;
      case 'prescricoes':
        return <FileText size={18} color="$primary" />;
      default:
        return <FileText size={18} color="$primary" />;
    }
  };

  return (
    <YStack flex={1} backgroundColor="$background">
      <ScrollView>
        <YStack padding="$4" space="$4">
          {/* Cabeçalho */}
          <XStack justifyContent="space-between" alignItems="center">
            <H1 fontSize="$6" color="$text">Relatórios</H1>
          </XStack>

          {/* Gerador de Relatórios */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Gerar Novo Relatório
            </Text>
            
            <YStack space="$3">
              <YStack space="$1">
                <Text fontSize="$4" color="$textSecondary">Tipo de Relatório</Text>
                <Select
                  size="$4"
                  value={tipoRelatorio}
                  onValueChange={(value) => setTipoRelatorio(value)}
                  backgroundColor="$background"
                >
                  <Select.Trigger iconAfter={<Select.CaretDown />}>
                    <Select.Value placeholder="Selecione o tipo de relatório" />
                  </Select.Trigger>
                  <Select.Content>
                    <Select.Item index={0} value="pacientes">
                      <Select.ItemText>Relatório de Pacientes</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={1} value="lesoes">
                      <Select.ItemText>Relatório de Lesões</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={2} value="tratamentos">
                      <Select.ItemText>Relatório de Tratamentos</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={3} value="estatisticas">
                      <Select.ItemText>Estatísticas de Cicatrização</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={4} value="prescricoes">
                      <Select.ItemText>Relatório de Prescrições</Select.ItemText>
                    </Select.Item>
                  </Select.Content>
                </Select>
              </YStack>
              
              <YStack space="$1">
                <Text fontSize="$4" color="$textSecondary">Período</Text>
                <Select
                  size="$4"
                  value={periodoRelatorio}
                  onValueChange={(value) => setPeriodoRelatorio(value)}
                  backgroundColor="$background"
                >
                  <Select.Trigger iconAfter={<Select.CaretDown />}>
                    <Select.Value placeholder="Selecione o período" />
                  </Select.Trigger>
                  <Select.Content>
                    <Select.Item index={0} value="ultimo_mes">
                      <Select.ItemText>Último Mês</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={1} value="ultimos_3_meses">
                      <Select.ItemText>Últimos 3 Meses</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={2} value="ultimos_6_meses">
                      <Select.ItemText>Últimos 6 Meses</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={3} value="ultimo_ano">
                      <Select.ItemText>Último Ano</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={4} value="todos">
                      <Select.ItemText>Todo o Período</Select.ItemText>
                    </Select.Item>
                  </Select.Content>
                </Select>
              </YStack>
              
              <Button
                size="$4"
                backgroundColor="$primary"
                color="white"
                icon={isLoading ? undefined : <FileText size={18} color="white" />}
                onPress={gerarRelatorio}
                disabled={isLoading}
              >
                {isLoading ? <Spinner color="white" size="small" /> : 'Gerar Relatório'}
              </Button>
            </YStack>
          </Card>

          {/* Relatórios Recentes */}
          <YStack space="$3">
            <Text fontSize="$5" fontWeight="bold" color="$text">
              Relatórios Recentes
            </Text>
            
            {relatoriosRecentes.length > 0 ? (
              relatoriosRecentes.map((relatorio) => (
                <Card
                  key={relatorio.id}
                  padding="$4"
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  borderWidth={1}
                  borderRadius="$4"
                  pressStyle={{ opacity: 0.8, scale: 0.98 }}
                  onPress={() => abrirRelatorio(relatorio)}
                >
                  <XStack justifyContent="space-between" alignItems="center" marginBottom="$2">
                    <XStack alignItems="center" space="$2">
                      {obterIconeRelatorio(relatorio.tipo)}
                      <Text fontSize="$4" fontWeight="bold" color="$text">
                        {relatorio.titulo}
                      </Text>
                    </XStack>
                  </XStack>
                  
                  <Separator marginVertical="$2" />
                  
                  <YStack space="$2">
                    <XStack justifyContent="space-between">
                      <Text fontSize="$3" color="$textSecondary">Data de Geração:</Text>
                      <Text fontSize="$3" color="$text">{formatarData(relatorio.dataGeracao)}</Text>
                    </XStack>
                    
                    <XStack justifyContent="space-between">
                      <Text fontSize="$3" color="$textSecondary">Formato:</Text>
                      <Text fontSize="$3" color="$text">{relatorio.formato}</Text>
                    </XStack>
                    
                    <XStack justifyContent="space-between">
                      <Text fontSize="$3" color="$textSecondary">Tamanho:</Text>
                      <Text fontSize="$3" color="$text">{relatorio.tamanho}</Text>
                    </XStack>
                  </YStack>
                  
                  <XStack space="$2" marginTop="$3" justifyContent="flex-end">
                    <Button
                      size="$2"
                      backgroundColor="$backgroundSecondary"
                      icon={<Download size={16} color="$text" />}
                      onPress={() => abrirRelatorio(relatorio)}
                    >
                      Abrir
                    </Button>
                    <Button
                      size="$2"
                      backgroundColor="$backgroundSecondary"
                      icon={<Share size={16} color="$text" />}
                      onPress={() => compartilharRelatorio(relatorio)}
                    >
                      Compartilhar
                    </Button>
                  </XStack>
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
                  Nenhum relatório gerado recentemente.
                </Text>
              </YStack>
            )}
          </YStack>
        </YStack>
      </ScrollView>
    </YStack>
  );
}
