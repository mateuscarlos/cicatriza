import React, { useState, useEffect } from 'react';
import { YStack, XStack, Button, Text, ScrollView, H1, Card, Spinner, View, Separator, Input } from 'tamagui';
import { useRouter } from 'expo-router';
import { ArrowLeft, FileText, Download, Printer, Share, Filter, Calendar, User, Search, Edit } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';

/**
 * Tela de Geração de Prescrições da aplicação Cicatriza
 * 
 * Esta tela permite gerar prescrições para pacientes com base nos tratamentos ativos,
 * incluindo medicamentos, coberturas e orientações.
 */
export default function PrescricoesScreen() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const [pacientes, setPacientes] = useState([]);
  const [pacienteSelecionado, setPacienteSelecionado] = useState(null);
  const [prescricoesRecentes, setPrescricoesRecentes] = useState([]);
  const [termoBusca, setTermoBusca] = useState('');

  // Carregar pacientes e prescrições recentes
  useEffect(() => {
    const carregarDados = async () => {
      try {
        // Simulação de carregamento de dados - substituir por chamada real ao Firebase
        await new Promise(resolve => setTimeout(resolve, 500));
        
        // Dados simulados de pacientes
        const pacientesSimulados = [
          {
            id: 'pac1',
            nome: 'Maria Silva',
            genero: 'female',
            dataNascimento: new Date(1980, 5, 15),
            telefone: '(11) 98765-4321',
            possuiTratamentoAtivo: true
          },
          {
            id: 'pac2',
            nome: 'João Santos',
            genero: 'male',
            dataNascimento: new Date(1975, 3, 20),
            telefone: '(11) 91234-5678',
            possuiTratamentoAtivo: true
          },
          {
            id: 'pac3',
            nome: 'Ana Oliveira',
            genero: 'female',
            dataNascimento: new Date(1990, 8, 10),
            telefone: '(11) 99876-5432',
            possuiTratamentoAtivo: false
          }
        ];
        
        setPacientes(pacientesSimulados);
        
        // Dados simulados de prescrições recentes
        const prescricoesSimuladas = [
          {
            id: 'presc1',
            pacienteId: 'pac1',
            pacienteNome: 'Maria Silva',
            dataGeracao: new Date(2025, 3, 15),
            tipo: 'Medicamentos e Curativos',
            formato: 'PDF',
            tamanho: '0.8 MB',
            url: 'https://example.com/prescricoes/maria_silva_20250415.pdf'
          },
          {
            id: 'presc2',
            pacienteId: 'pac2',
            pacienteNome: 'João Santos',
            dataGeracao: new Date(2025, 3, 10),
            tipo: 'Medicamentos',
            formato: 'PDF',
            tamanho: '0.5 MB',
            url: 'https://example.com/prescricoes/joao_santos_20250410.pdf'
          }
        ];
        
        setPrescricoesRecentes(prescricoesSimuladas);
      } catch (error) {
        console.error('Erro ao carregar dados:', error);
      }
    };

    carregarDados();
  }, []);

  /**
   * Formata a data para exibição
   */
  const formatarData = (data) => {
    if (!data) return '';
    return data.toLocaleDateString('pt-BR');
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

  /**
   * Filtra pacientes com base no termo de busca
   */
  const pacientesFiltrados = pacientes.filter(paciente => 
    paciente.nome.toLowerCase().includes(termoBusca.toLowerCase())
  );

  /**
   * Seleciona um paciente para gerar prescrição
   */
  const selecionarPaciente = (paciente) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    setPacienteSelecionado(paciente);
  };

  /**
   * Gera uma nova prescrição
   */
  const gerarPrescricao = async () => {
    if (!pacienteSelecionado) {
      alert('Selecione um paciente para gerar a prescrição.');
      return;
    }
    
    if (!pacienteSelecionado.possuiTratamentoAtivo) {
      alert('Este paciente não possui tratamentos ativos para gerar prescrição.');
      return;
    }
    
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    setIsLoading(true);
    
    try {
      // Simulação de geração de prescrição - substituir pela implementação real
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      // Adicionar nova prescrição à lista de recentes
      const novaPrescricao = {
        id: `presc${Date.now()}`,
        pacienteId: pacienteSelecionado.id,
        pacienteNome: pacienteSelecionado.nome,
        dataGeracao: new Date(),
        tipo: 'Medicamentos e Curativos',
        formato: 'PDF',
        tamanho: '0.7 MB',
        url: `https://example.com/prescricoes/${pacienteSelecionado.nome.toLowerCase().replace(' ', '_')}_${new Date().toISOString().split('T')[0].replace(/-/g, '')}.pdf`
      };
      
      setPrescricoesRecentes([novaPrescricao, ...prescricoesRecentes]);
      
      // Simular abertura da prescrição
      alert(`Prescrição para ${pacienteSelecionado.nome} gerada com sucesso!`);
      
      // Limpar seleção
      setPacienteSelecionado(null);
    } catch (error) {
      console.error('Erro ao gerar prescrição:', error);
      alert('Erro ao gerar prescrição. Tente novamente.');
    } finally {
      setIsLoading(false);
    }
  };

  /**
   * Abre uma prescrição existente
   */
  const abrirPrescricao = (prescricao) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    // Simulação de abertura de prescrição - substituir pela implementação real
    alert(`Abrindo prescrição para ${prescricao.pacienteNome}`);
  };

  /**
   * Compartilha uma prescrição
   */
  const compartilharPrescricao = (prescricao) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    // Simulação de compartilhamento - substituir pela implementação real
    alert(`Compartilhando prescrição para ${prescricao.pacienteNome}`);
  };

  /**
   * Navega para a tela de edição de prescrição
   */
  const navegarParaEdicaoPrescricao = (prescricao) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    router.push(`/(app)/prescricoes/${prescricao.id}/editar`);
  };

  return (
    <YStack flex={1} backgroundColor="$background">
      <ScrollView>
        <YStack padding="$4" space="$4">
          {/* Cabeçalho */}
          <XStack justifyContent="space-between" alignItems="center">
            <H1 fontSize="$6" color="$text">Prescrições</H1>
          </XStack>

          {/* Gerador de Prescrições */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <Text fontSize="$5" fontWeight="bold" color="$text" marginBottom="$3">
              Gerar Nova Prescrição
            </Text>
            
            <YStack space="$3">
              <YStack space="$1">
                <Text fontSize="$4" color="$textSecondary">Buscar Paciente</Text>
                <Input
                  size="$4"
                  placeholder="Digite o nome do paciente"
                  value={termoBusca}
                  onChangeText={setTermoBusca}
                  backgroundColor="$background"
                  icon={<Search size={18} color="$textSecondary" />}
                />
              </YStack>
              
              <YStack space="$2" maxHeight={200} overflow="scroll">
                {pacientesFiltrados.length > 0 ? (
                  pacientesFiltrados.map((paciente) => (
                    <Card
                      key={paciente.id}
                      padding="$3"
                      backgroundColor={pacienteSelecionado?.id === paciente.id ? '$primary2' : '$background'}
                      borderColor={pacienteSelecionado?.id === paciente.id ? '$primary' : '$borderColor'}
                      borderWidth={1}
                      borderRadius="$2"
                      pressStyle={{ opacity: 0.8, scale: 0.98 }}
                      onPress={() => selecionarPaciente(paciente)}
                    >
                      <XStack justifyContent="space-between" alignItems="center">
                        <YStack>
                          <Text fontSize="$4" fontWeight="bold" color="$text">
                            {paciente.nome}
                          </Text>
                          <Text fontSize="$3" color="$textSecondary">
                            {paciente.genero === 'male' ? 'Masculino' : 'Feminino'}, {calcularIdade(paciente.dataNascimento)} anos
                          </Text>
                        </YStack>
                        <View
                          width={12}
                          height={12}
                          borderRadius={6}
                          backgroundColor={paciente.possuiTratamentoAtivo ? '$green10' : '$gray10'}
                        />
                      </XStack>
                    </Card>
                  ))
                ) : (
                  <Text color="$textSecondary" textAlign="center" padding="$2">
                    Nenhum paciente encontrado.
                  </Text>
                )}
              </YStack>
              
              <Button
                size="$4"
                backgroundColor="$primary"
                color="white"
                icon={isLoading ? undefined : <FileText size={18} color="white" />}
                onPress={gerarPrescricao}
                disabled={isLoading || !pacienteSelecionado || !pacienteSelecionado.possuiTratamentoAtivo}
              >
                {isLoading ? <Spinner color="white" size="small" /> : 'Gerar Prescrição'}
              </Button>
              
              {pacienteSelecionado && !pacienteSelecionado.possuiTratamentoAtivo && (
                <Text color="$red10" fontSize="$3" textAlign="center">
                  Este paciente não possui tratamentos ativos para gerar prescrição.
                </Text>
              )}
            </YStack>
          </Card>

          {/* Prescrições Recentes */}
          <YStack space="$3">
            <Text fontSize="$5" fontWeight="bold" color="$text">
              Prescrições Recentes
            </Text>
            
            {prescricoesRecentes.length > 0 ? (
              prescricoesRecentes.map((prescricao) => (
                <Card
                  key={prescricao.id}
                  padding="$4"
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  borderWidth={1}
                  borderRadius="$4"
                  pressStyle={{ opacity: 0.8, scale: 0.98 }}
                  onPress={() => abrirPrescricao(prescricao)}
                >
                  <XStack justifyContent="space-between" alignItems="center" marginBottom="$2">
                    <XStack alignItems="center" space="$2">
                      <FileText size={18} color="$primary" />
                      <Text fontSize="$4" fontWeight="bold" color="$text">
                        {prescricao.pacienteNome}
                      </Text>
                    </XStack>
                  </XStack>
                  
                  <Separator marginVertical="$2" />
                  
                  <YStack space="$2">
                    <XStack justifyContent="space-between">
                      <Text fontSize="$3" color="$textSecondary">Data de Geração:</Text>
                      <Text fontSize="$3" color="$text">{formatarData(prescricao.dataGeracao)}</Text>
                    </XStack>
                    
                    <XStack justifyContent="space-between">
                      <Text fontSize="$3" color="$textSecondary">Tipo:</Text>
                      <Text fontSize="$3" color="$text">{prescricao.tipo}</Text>
                    </XStack>
                    
                    <XStack justifyContent="space-between">
                      <Text fontSize="$3" color="$textSecondary">Formato:</Text>
                      <Text fontSize="$3" color="$text">{prescricao.formato}</Text>
                    </XStack>
                  </YStack>
                  
                  <XStack space="$2" marginTop="$3" justifyContent="flex-end">
                    <Button
                      size="$2"
                      backgroundColor="$backgroundSecondary"
                      icon={<Download size={16} color="$text" />}
                      onPress={() => abrirPrescricao(prescricao)}
                    >
                      Abrir
                    </Button>
                    <Button
                      size="$2"
                      backgroundColor="$backgroundSecondary"
                      icon={<Edit size={16} color="$text" />}
                      onPress={() => navegarParaEdicaoPrescricao(prescricao)}
                    >
                      Editar
                    </Button>
                    <Button
                      size="$2"
                      backgroundColor="$backgroundSecondary"
                      icon={<Share size={16} color="$text" />}
                      onPress={() => compartilharPrescricao(prescricao)}
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
                  Nenhuma prescrição gerada recentemente.
                </Text>
              </YStack>
            )}
          </YStack>
        </YStack>
      </ScrollView>
    </YStack>
  );
}
