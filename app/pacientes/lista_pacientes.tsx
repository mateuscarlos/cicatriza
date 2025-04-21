import React, { useState } from 'react';
import { YStack, XStack, Input, Button, Text, ScrollView, H1, Card, Avatar, Spinner, View } from 'tamagui';
import { useRouter } from 'expo-router';
import { Search, Plus, User, Calendar, Phone, MapPin, Filter, SortDesc } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';

/**
 * Tela de Lista de Pacientes da aplicação Cicatriza
 * 
 * Esta tela exibe a lista de pacientes cadastrados, com opções de busca,
 * filtragem e navegação para detalhes do paciente ou cadastro de novo paciente.
 */
export default function ListaPacientesScreen() {
  const router = useRouter();
  const [searchQuery, setSearchQuery] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [showFilters, setShowFilters] = useState(false);

  // Dados simulados de pacientes
  const [pacientes, setPacientes] = useState([
    {
      id: '1',
      nome: 'Maria Silva',
      dataNascimento: new Date(1980, 5, 15),
      genero: 'female',
      telefone: '(11) 98765-4321',
      endereco: 'Rua das Flores, 123 - São Paulo, SP',
      ultimaConsulta: new Date(2025, 3, 10),
      quantidadeLesoes: 2,
    },
    {
      id: '2',
      nome: 'João Santos',
      dataNascimento: new Date(1975, 8, 22),
      genero: 'male',
      telefone: '(11) 91234-5678',
      endereco: 'Av. Paulista, 1000 - São Paulo, SP',
      ultimaConsulta: new Date(2025, 3, 15),
      quantidadeLesoes: 1,
    },
    {
      id: '3',
      nome: 'Ana Oliveira',
      dataNascimento: new Date(1990, 2, 8),
      genero: 'female',
      telefone: '(11) 99876-5432',
      endereco: 'Rua Augusta, 500 - São Paulo, SP',
      ultimaConsulta: new Date(2025, 3, 5),
      quantidadeLesoes: 3,
    },
  ]);

  /**
   * Calcula a idade com base na data de nascimento
   */
  const calcularIdade = (dataNascimento) => {
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
    return data.toLocaleDateString('pt-BR');
  };

  /**
   * Filtra os pacientes com base na busca
   */
  const pacientesFiltrados = pacientes.filter(paciente =>
    paciente.nome.toLowerCase().includes(searchQuery.toLowerCase()) ||
    paciente.telefone.includes(searchQuery)
  );

  /**
   * Navega para a tela de detalhes do paciente
   */
  const navegarParaDetalhesPaciente = (id) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.push(`/(app)/pacientes/${id}`);
  };

  /**
   * Navega para a tela de cadastro de paciente
   */
  const navegarParaCadastroPaciente = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    router.push('/(app)/pacientes/novo');
  };

  /**
   * Alterna a exibição dos filtros
   */
  const toggleFiltros = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    setShowFilters(!showFilters);
  };

  return (
    <YStack flex={1} backgroundColor="$background">
      <YStack padding="$4" space="$4">
        {/* Cabeçalho */}
        <XStack justifyContent="space-between" alignItems="center">
          <H1 fontSize="$6" color="$text">Pacientes</H1>
          <Button
            size="$4"
            backgroundColor="$primary"
            color="white"
            borderRadius="$4"
            icon={<Plus size={18} color="white" />}
            onPress={navegarParaCadastroPaciente}
          >
            Novo Paciente
          </Button>
        </XStack>

        {/* Barra de Busca */}
        <XStack space="$2">
          <Input
            flex={1}
            size="$4"
            placeholder="Buscar paciente por nome ou telefone"
            value={searchQuery}
            onChangeText={setSearchQuery}
            backgroundColor="$backgroundSecondary"
            borderColor="$borderColor"
            focusStyle={{ borderColor: '$primary' }}
            icon={<Search size={18} color="$textSecondary" />}
          />
          <Button
            size="$4"
            backgroundColor="$backgroundSecondary"
            icon={<Filter size={18} color="$text" />}
            onPress={toggleFiltros}
          />
          <Button
            size="$4"
            backgroundColor="$backgroundSecondary"
            icon={<SortDesc size={18} color="$text" />}
          />
        </XStack>

        {/* Filtros (expandíveis) */}
        {showFilters && (
          <Card padding="$3" backgroundColor="$backgroundSecondary">
            <Text>Filtros (a implementar)</Text>
          </Card>
        )}
      </YStack>

      {/* Lista de Pacientes */}
      {isLoading ? (
        <YStack flex={1} justifyContent="center" alignItems="center">
          <Spinner size="large" color="$primary" />
          <Text marginTop="$2">Carregando pacientes...</Text>
        </YStack>
      ) : pacientesFiltrados.length === 0 ? (
        <YStack flex={1} justifyContent="center" alignItems="center" padding="$4">
          <Text color="$textSecondary" textAlign="center">
            Nenhum paciente encontrado.
            {searchQuery ? ' Tente uma busca diferente.' : ' Cadastre seu primeiro paciente.'}
          </Text>
          {!searchQuery && (
            <Button
              marginTop="$4"
              size="$4"
              backgroundColor="$primary"
              color="white"
              icon={<Plus size={18} color="white" />}
              onPress={navegarParaCadastroPaciente}
            >
              Cadastrar Paciente
            </Button>
          )}
        </YStack>
      ) : (
        <ScrollView>
          <YStack padding="$4" space="$3">
            {pacientesFiltrados.map((paciente) => (
              <Card
                key={paciente.id}
                padding="$4"
                backgroundColor="$backgroundSecondary"
                borderRadius="$4"
                pressStyle={{ opacity: 0.8, scale: 0.98 }}
                animation="bouncy"
                onPress={() => navegarParaDetalhesPaciente(paciente.id)}
              >
                <XStack space="$3" alignItems="center">
                  <Avatar circular size="$6" backgroundColor="$primary">
                    <Avatar.Image source={{ uri: `https://i.pravatar.cc/150?u=${paciente.id}` }} />
                    <Avatar.Fallback backgroundColor="$primary">
                      {paciente.nome.charAt(0)}
                    </Avatar.Fallback>
                  </Avatar>
                  <YStack flex={1} space="$1">
                    <Text fontSize="$5" fontWeight="bold" color="$text">
                      {paciente.nome}
                    </Text>
                    <XStack space="$2" flexWrap="wrap">
                      <XStack alignItems="center" space="$1">
                        <User size={14} color="$textSecondary" />
                        <Text fontSize="$3" color="$textSecondary">
                          {paciente.genero === 'male' ? 'Masculino' : 'Feminino'}, {calcularIdade(paciente.dataNascimento)} anos
                        </Text>
                      </XStack>
                      <XStack alignItems="center" space="$1">
                        <Phone size={14} color="$textSecondary" />
                        <Text fontSize="$3" color="$textSecondary">
                          {paciente.telefone}
                        </Text>
                      </XStack>
                    </XStack>
                    <XStack alignItems="center" space="$1">
                      <MapPin size={14} color="$textSecondary" />
                      <Text fontSize="$3" color="$textSecondary" numberOfLines={1}>
                        {paciente.endereco}
                      </Text>
                    </XStack>
                  </YStack>
                </XStack>
                <XStack marginTop="$3" justifyContent="space-between">
                  <XStack alignItems="center" space="$1">
                    <Calendar size={14} color="$textSecondary" />
                    <Text fontSize="$3" color="$textSecondary">
                      Última consulta: {formatarData(paciente.ultimaConsulta)}
                    </Text>
                  </XStack>
                  <View
                    backgroundColor={paciente.quantidadeLesoes > 0 ? '$red5' : '$green5'}
                    paddingHorizontal="$2"
                    paddingVertical="$1"
                    borderRadius="$2"
                  >
                    <Text
                      fontSize="$2"
                      color={paciente.quantidadeLesoes > 0 ? '$red10' : '$green10'}
                      fontWeight="bold"
                    >
                      {paciente.quantidadeLesoes} {paciente.quantidadeLesoes === 1 ? 'lesão' : 'lesões'}
                    </Text>
                  </View>
                </XStack>
              </Card>
            ))}
          </YStack>
        </ScrollView>
      )}
    </YStack>
  );
}
