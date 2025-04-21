import React, { useState, useEffect } from 'react';
import { YStack, XStack, Button, Text, ScrollView, H1, Card, Avatar, Spinner, View, Tabs, TabsContent, H2, Paragraph } from 'tamagui';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, Edit, User, Calendar, Phone, MapPin, Mail, FileText, Activity, Clock, Plus } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';

/**
 * Tela de Detalhes do Paciente da aplicação Cicatriza
 * 
 * Esta tela exibe informações detalhadas sobre um paciente específico,
 * incluindo dados pessoais, histórico médico e lesões cadastradas.
 */
export default function DetalhesPacienteScreen() {
  const router = useRouter();
  const { id } = useLocalSearchParams<{ id: string }>();
  const [isLoading, setIsLoading] = useState(true);
  const [paciente, setPaciente] = useState(null);

  // Carregar dados do paciente
  useEffect(() => {
    const carregarPaciente = async () => {
      setIsLoading(true);
      try {
        // Simulação de carregamento de dados - substituir por chamada real ao Firebase
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Dados simulados do paciente
        setPaciente({
          id: id,
          nome: 'Maria Silva',
          dataNascimento: new Date(1980, 5, 15),
          genero: 'female',
          telefone: '(11) 98765-4321',
          email: 'maria.silva@email.com',
          endereco: 'Rua das Flores, 123 - São Paulo, SP',
          ultimaConsulta: new Date(2025, 3, 10),
          historico: {
            condicoes: ['Diabetes Tipo 2', 'Hipertensão'],
            alergias: ['Penicilina', 'Látex'],
            medicamentos: ['Metformina 500mg', 'Losartana 50mg'],
            observacoes: 'Paciente com histórico de cicatrização lenta.'
          },
          lesoes: [
            {
              id: 'l1',
              tipo: 'Úlcera Venosa',
              localizacao: 'Perna Direita',
              regiao: 'leg_right_lower',
              dataInicio: new Date(2025, 2, 15),
              status: 'active',
              ultimaAvaliacao: new Date(2025, 3, 10)
            },
            {
              id: 'l2',
              tipo: 'Lesão por Pressão',
              localizacao: 'Calcanhar Esquerdo',
              regiao: 'foot_left',
              dataInicio: new Date(2025, 3, 1),
              status: 'healing',
              ultimaAvaliacao: new Date(2025, 3, 10)
            }
          ]
        });
      } catch (error) {
        console.error('Erro ao carregar paciente:', error);
      } finally {
        setIsLoading(false);
      }
    };

    if (id) {
      carregarPaciente();
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
   * Formata a data para exibição
   */
  const formatarData = (data) => {
    if (!data) return '';
    return data.toLocaleDateString('pt-BR');
  };

  /**
   * Navega para a tela de edição do paciente
   */
  const navegarParaEdicaoPaciente = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    router.push(`/(app)/pacientes/${id}/editar`);
  };

  /**
   * Navega para a tela Bodyparts
   */
  const navegarParaBodyparts = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    router.push(`/(app)/pacientes/${id}/bodyparts`);
  };

  /**
   * Navega para a tela de detalhes da lesão
   */
  const navegarParaDetalhesLesao = (lesaoId) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.push(`/(app)/pacientes/${id}/lesoes/${lesaoId}`);
  };

  /**
   * Navega para a tela de cadastro de nova lesão
   */
  const navegarParaCadastroLesao = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    router.push(`/(app)/pacientes/${id}/bodyparts`);
  };

  /**
   * Navega de volta para a lista de pacientes
   */
  const voltarParaListaPacientes = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.back();
  };

  // Renderiza o status da lesão com cor apropriada
  const renderizarStatusLesao = (status) => {
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
        <Text marginTop="$2">Carregando informações do paciente...</Text>
      </YStack>
    );
  }

  if (!paciente) {
    return (
      <YStack flex={1} justifyContent="center" alignItems="center" backgroundColor="$background" padding="$4">
        <Text color="$textSecondary" textAlign="center">
          Paciente não encontrado.
        </Text>
        <Button
          marginTop="$4"
          size="$4"
          backgroundColor="$primary"
          color="white"
          icon={<ArrowLeft size={18} color="white" />}
          onPress={voltarParaListaPacientes}
        >
          Voltar para Lista de Pacientes
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
              onPress={voltarParaListaPacientes}
            >
              Voltar
            </Button>
            <H1 fontSize="$6" color="$text">Detalhes do Paciente</H1>
            <Button
              size="$3"
              backgroundColor="$backgroundSecondary"
              icon={<Edit size={18} color="$text" />}
              onPress={navegarParaEdicaoPaciente}
            >
              Editar
            </Button>
          </XStack>

          {/* Informações Básicas do Paciente */}
          <Card padding="$4" backgroundColor="$backgroundSecondary" borderRadius="$4">
            <XStack space="$4" alignItems="center">
              <Avatar circular size="$8" backgroundColor="$primary">
                <Avatar.Image source={{ uri: `https://i.pravatar.cc/150?u=${paciente.id}` }} />
                <Avatar.Fallback backgroundColor="$primary">
                  {paciente.nome.charAt(0)}
                </Avatar.Fallback>
              </Avatar>
              <YStack flex={1} space="$1">
                <Text fontSize="$6" fontWeight="bold" color="$text">
                  {paciente.nome}
                </Text>
                <XStack alignItems="center" space="$1">
                  <User size={16} color="$textSecondary" />
                  <Text fontSize="$4" color="$textSecondary">
                    {paciente.genero === 'male' ? 'Masculino' : 'Feminino'}, {calcularIdade(paciente.dataNascimento)} anos
                  </Text>
                </XStack>
                <XStack alignItems="center" space="$1">
                  <Calendar size={16} color="$textSecondary" />
                  <Text fontSize="$4" color="$textSecondary">
                    Nascimento: {formatarData(paciente.dataNascimento)}
                  </Text>
                </XStack>
              </YStack>
            </XStack>
          </Card>

          {/* Abas de Informações */}
          <Tabs
            defaultValue="info"
            orientation="horizontal"
            flexDirection="column"
            backgroundColor="$backgroundSecondary"
            borderRadius="$4"
          >
            <Tabs.List>
              <Tabs.Tab value="info" flex={1}>
                <Text>Informações</Text>
              </Tabs.Tab>
              <Tabs.Tab value="historico" flex={1}>
                <Text>Histórico Médico</Text>
              </Tabs.Tab>
              <Tabs.Tab value="lesoes" flex={1}>
                <Text>Lesões</Text>
              </Tabs.Tab>
            </Tabs.List>

            {/* Aba de Informações de Contato */}
            <TabsContent value="info" padding="$4">
              <YStack space="$4">
                <YStack space="$2">
                  <Text fontSize="$3" color="$textSecondary">Telefone</Text>
                  <XStack alignItems="center" space="$2">
                    <Phone size={18} color="$text" />
                    <Text fontSize="$4" color="$text">{paciente.telefone}</Text>
                  </XStack>
                </YStack>

                <YStack space="$2">
                  <Text fontSize="$3" color="$textSecondary">E-mail</Text>
                  <XStack alignItems="center" space="$2">
                    <Mail size={18} color="$text" />
                    <Text fontSize="$4" color="$text">{paciente.email}</Text>
                  </XStack>
                </YStack>

                <YStack space="$2">
                  <Text fontSize="$3" color="$textSecondary">Endereço</Text>
                  <XStack alignItems="center" space="$2">
                    <MapPin size={18} color="$text" />
                    <Text fontSize="$4" color="$text">{paciente.endereco}</Text>
                  </XStack>
                </YStack>

                <YStack space="$2">
                  <Text fontSize="$3" color="$textSecondary">Última Consulta</Text>
                  <XStack alignItems="center" space="$2">
                    <Calendar size={18} color="$text" />
                    <Text fontSize="$4" color="$text">{formatarData(paciente.ultimaConsulta)}</Text>
                  </XStack>
                </YStack>
              </YStack>
            </TabsContent>

            {/* Aba de Histórico Médico */}
            <TabsContent value="historico" padding="$4">
              <YStack space="$4">
                <YStack space="$2">
                  <Text fontSize="$3" color="$textSecondary">Condições Médicas</Text>
                  {paciente.historico.condicoes.length > 0 ? (
                    paciente.historico.condicoes.map((condicao, index) => (
                      <XStack key={index} alignItems="center" space="$2">
                        <FileText size={18} color="$text" />
                        <Text fontSize="$4" color="$text">{condicao}</Text>
                      </XStack>
                    ))
                  ) : (
                    <Text fontSize="$4" color="$textSecondary">Nenhuma condição registrada</Text>
                  )}
                </YStack>

                <YStack space="$2">
                  <Text fontSize="$3" color="$textSecondary">Alergias</Text>
                  {paciente.historico.alergias.length > 0 ? (
                    paciente.historico.alergias.map((alergia, index) => (
                      <XStack key={index} alignItems="center" space="$2">
                        <FileText size={18} color="$text" />
                        <Text fontSize="$4" color="$text">{alergia}</Text>
                      </XStack>
                    ))
                  ) : (
                    <Text fontSize="$4" color="$textSecondary">Nenhuma alergia registrada</Text>
                  )}
                </YStack>

                <YStack space="$2">
                  <Text fontSize="$3" color="$textSecondary">Medicamentos</Text>
                  {paciente.historico.medicamentos.length > 0 ? (
                    paciente.historico.medicamentos.map((medicamento, index) => (
                      <XStack key={index} alignItems="center" space="$2">
                        <FileText size={18} color="$text" />
                        <Text fontSize="$4" color="$text">{medicamento}</Text>
                      </XStack>
                    ))
                  ) : (
                    <Text fontSize="$4" color="$textSecondary">Nenhum medicamento registrado</Text>
                  )}
                </YStack>

                <YStack space="$2">
                  <Text fontSize="$3" color="$textSecondary">Observações</Text>
                  <Text fontSize="$4" color="$text">{paciente.historico.observacoes}</Text>
                </YStack>
              </YStack>
            </TabsContent>

            {/* Aba de Lesões */}
            <TabsContent value="lesoes" padding="$4">
              <YStack space="$4">
                <XStack justifyContent="space-between" alignItems="center">
                  <H2 fontSize="$5" color="$text">Lesões Cadastradas</H2>
                  <Button
                    size="$3"
                    backgroundColor="$primary"
                    color="white"
                    icon={<Plus size={16} color="white" />}
                    onPress={navegarParaBodyparts}
                  >
                    Nova Lesão
                  </Button>
                </XStack>

                {paciente.lesoes.length > 0 ? (
                  <YStack space="$3">
                    {paciente.lesoes.map((lesao) => (
                      <Card
                        key={lesao.id}
                        padding="$3"
                        backgroundColor="$background"
                        borderRadius="$4"
                        pressStyle={{ opacity: 0.8, scale: 0.98 }}
                        animation="bouncy"
                        onPress={() => navegarParaDetalhesLesao(lesao.id)}
                      >
                        <XStack justifyContent="space-between" alignItems="center">
                          <YStack space="$1">
                            <Text fontSize="$4" fontWeight="bold" color="$text">
                              {lesao.tipo}
                            </Text>
                            <XStack alignItems="center" space="$1">
                              <MapPin size={14} color="$textSecondary" />
                              <Text fontSize="$3" color="$textSecondary">
                                {lesao.localizacao}
                              </Text>
                            </XStack>
                          </YStack>
                          {renderizarStatusLesao(lesao.status)}
                        </XStack>
                        <XStack marginTop="$2" justifyContent="space-between" alignItems="center">
  <XStack alignItems="center" space="$1">
    <Calendar size={14} color="$textSecondary" />
    <Text fontSize="$3" color="$textSecondary">
      Início: {formatarData(lesao.dataInicio)}
    </Text>
  </XStack>
  <XStack alignItems="center" space="$1">
    <Activity size={14} color="$textSecondary" />
    <Text fontSize="$3" color="$textSecondary">
      Última avaliação: {formatarData(lesao.ultimaAvaliacao)}
    </Text>
  </XStack>
</XStack>
                      </Card>
                    ))}
                  </YStack>
                ) : (
                  <Text fontSize="$4" color="$textSecondary" textAlign="center">
                    Nenhuma lesão cadastrada para este paciente.
                  </Text>
                )}
              </YStack>
            </TabsContent>
          </Tabs>
        </YStack>
      </ScrollView>
    </YStack>
  );
}