import React, { useState } from 'react';
import { View, StyleSheet, Text, ScrollView, TextInput, Switch } from 'react-native';
import { Button, CheckBox, Card } from '@ui-kitten/components';

// Definição dos tipos
interface TipoTecido {
  granulacao: number;
  necrotico: number;
  esfacelo: number;
  epitelizacao: number;
}

interface Exsudato {
  tipo: string;
  nivel: string;
  acumulo: boolean;
}

interface Infeccao {
  local: string[];
  sistemica: string[];
  biofilme: boolean;
}

interface DadosFormulario {
  tipoTecido: TipoTecido;
  exsudato: Exsudato;
  infeccao: Infeccao;
}

interface Opcao {
  texto: string;
  valor: string;
}

interface PropriedadesFormularioAvaliacaoFerida {
  dadosIniciais?: Partial<DadosFormulario>;
  aoSalvar?: (dados: DadosFormulario) => void;
}

/**
 * Componente de formulário para avaliação do leito da ferida
 * 
 * Este componente implementa o formulário de avaliação do leito da ferida
 * baseado na metodologia do Triângulo de Avaliação de Feridas.
 * 
 * @param {Object} dadosIniciais - Dados iniciais para o formulário (opcional)
 * @param {Function} aoSalvar - Função chamada quando o formulário é salvo
 * @returns {React.Component} Componente de formulário
 */
const FormularioAvaliacaoFerida: React.FC<PropriedadesFormularioAvaliacaoFerida> = ({ dadosIniciais = {}, aoSalvar }) => {
  // Estado para armazenar os dados do formulário
  const [dadosFormulario, setDadosFormulario] = useState<DadosFormulario>({
    tipoTecido: {
      granulacao: dadosIniciais.tipoTecido?.granulacao || 0,
      necrotico: dadosIniciais.tipoTecido?.necrotico || 0,
      esfacelo: dadosIniciais.tipoTecido?.esfacelo || 0,
      epitelizacao: dadosIniciais.tipoTecido?.epitelizacao || 0,
    },
    exsudato: {
      tipo: dadosIniciais.exsudato?.tipo || '',
      nivel: dadosIniciais.exsudato?.nivel || '',
      acumulo: dadosIniciais.exsudato?.acumulo || false,
    },
    infeccao: {
      local: dadosIniciais.infeccao?.local || [],
      sistemica: dadosIniciais.infeccao?.sistemica || [],
      biofilme: dadosIniciais.infeccao?.biofilme || false,
    }
  });

  // Opções para tipo de exsudato
  const opcoesTipoExsudato: Opcao[] = [
    { texto: 'Fino/aquoso', valor: 'fino_aquoso' },
    { texto: 'Espesso', valor: 'espesso' },
    { texto: 'Claro', valor: 'claro' },
    { texto: 'Turvo', valor: 'turvo' },
    { texto: 'Rosa/vermelho', valor: 'rosa_vermelho' },
    { texto: 'Purulento', valor: 'purulento' },
  ];

  // Opções para nível de exsudato
  const opcoesNivelExsudato: Opcao[] = [
    { texto: 'Seco', valor: 'seco' },
    { texto: 'Baixo', valor: 'baixo' },
    { texto: 'Médio', valor: 'medio' },
    { texto: 'Alto', valor: 'alto' },
  ];

  // Opções para sinais de infecção local
  const sinaisInfeccaoLocal: Opcao[] = [
    { texto: 'Aumento da dor', valor: 'aumento_dor' },
    { texto: 'Eritema', valor: 'eritema' },
    { texto: 'Calor local', valor: 'calor_local' },
    { texto: 'Edema', valor: 'edema' },
    { texto: 'Aumento do exsudato', valor: 'aumento_exsudato' },
    { texto: 'Atraso na cicatrização', valor: 'atraso_cicatrizacao' },
    { texto: 'Tecido de granulação friável', valor: 'granulacao_friavel' },
    { texto: 'Odor fétido', valor: 'odor_fetido' },
    { texto: 'Tecido de granulação irregular/hipergranulação', valor: 'granulacao_irregular' },
  ];

  // Opções para sinais de infecção sistêmica
  const sinaisInfeccaoSistemica: Opcao[] = [
    { texto: 'Aumento do eritema', valor: 'aumento_eritema' },
    { texto: 'Febre (Pirexia)', valor: 'febre' },
    { texto: 'Abscesso/pus', valor: 'abscesso_pus' },
    { texto: 'Ruptura da ferida', valor: 'ruptura_ferida' },
    { texto: 'Celulite', valor: 'celulite' },
    { texto: 'Mal-estar geral', valor: 'mal_estar' },
    { texto: 'Contagem de leucócitos elevada', valor: 'leucocitos_elevados' },
    { texto: 'Linfangite', valor: 'linfangite' },
  ];

  // Função para atualizar os dados do tipo de tecido
  const atualizarTipoTecido = (campo: keyof TipoTecido, valor: number): void => {
    setDadosFormulario({
      ...dadosFormulario,
      tipoTecido: {
        ...dadosFormulario.tipoTecido,
        [campo]: valor
      }
    });
  };

  // Função para atualizar os dados do exsudato
  const atualizarExsudato = (campo: keyof Exsudato, valor: string | boolean): void => {
    setDadosFormulario({
      ...dadosFormulario,
      exsudato: {
        ...dadosFormulario.exsudato,
        [campo]: valor
      }
    });
  };

  // Função para atualizar os dados de infecção
  const atualizarInfeccao = (campo: keyof Infeccao, valor: string[] | boolean): void => {
    setDadosFormulario({
      ...dadosFormulario,
      infeccao: {
        ...dadosFormulario.infeccao,
        [campo]: valor
      }
    });
  };

  // Função para alternar um item em uma lista
  const alternarItemLista = (lista: string[], item: string): string[] => {
    if (lista.includes(item)) {
      return lista.filter(i => i !== item);
    } else {
      return [...lista, item];
    }
  };

  // Função para lidar com a seleção de sinais de infecção local
  const manipularAlternarInfeccaoLocal = (item: string): void => {
    const listaAtualizada = alternarItemLista(dadosFormulario.infeccao.local, item);
    atualizarInfeccao('local', listaAtualizada);
  };

  // Função para lidar com a seleção de sinais de infecção sistêmica
  const manipularAlternarInfeccaoSistemica = (item: string): void => {
    const listaAtualizada = alternarItemLista(dadosFormulario.infeccao.sistemica, item);
    atualizarInfeccao('sistemica', listaAtualizada);
  };

  // Função para validar se a soma dos percentuais de tipo de tecido é 100%
  const validarPercentuaisTecido = (): boolean => {
    const { granulacao, necrotico, esfacelo, epitelizacao } = dadosFormulario.tipoTecido;
    const soma = granulacao + necrotico + esfacelo + epitelizacao;
    return soma === 100;
  };

  // Função para salvar o formulário
  const manipularSalvar = (): void => {
    if (!validarPercentuaisTecido()) {
      alert('A soma dos percentuais de tipo de tecido deve ser 100%');
      return;
    }
    
    if (aoSalvar) {
      aoSalvar(dadosFormulario);
    }
  };

  return (
    <ScrollView style={estilos.container}>
      <Card style={estilos.card}>
        <Text style={estilos.tituloSecao}>Avaliação do Leito da Ferida</Text>
        
        {/* Tipo de Tecido */}
        <View style={estilos.secao}>
          <Text style={estilos.tituloSubSecao}>Tipo de Tecido (%)</Text>
          <Text style={estilos.textoAjuda}>A soma dos percentuais deve ser 100%</Text>
          
          <View style={estilos.containerTipoTecido}>
            <View style={estilos.itemTipoTecido}>
              <Text>Granulação</Text>
              <TextInput
                style={estilos.entradaPercentual}
                keyboardType="numeric"
                value={dadosFormulario.tipoTecido.granulacao.toString()}
                onChangeText={(valor) => atualizarTipoTecido('granulacao', parseInt(valor) || 0)}
              />
              <Text>%</Text>
            </View>
            
            <View style={estilos.itemTipoTecido}>
              <Text>Necrótico</Text>
              <TextInput
                style={estilos.entradaPercentual}
                keyboardType="numeric"
                value={dadosFormulario.tipoTecido.necrotico.toString()}
                onChangeText={(valor) => atualizarTipoTecido('necrotico', parseInt(valor) || 0)}
              />
              <Text>%</Text>
            </View>
            
            <View style={estilos.itemTipoTecido}>
              <Text>Esfacelo</Text>
              <TextInput
                style={estilos.entradaPercentual}
                keyboardType="numeric"
                value={dadosFormulario.tipoTecido.esfacelo.toString()}
                onChangeText={(valor) => atualizarTipoTecido('esfacelo', parseInt(valor) || 0)}
              />
              <Text>%</Text>
            </View>
            
            <View style={estilos.itemTipoTecido}>
              <Text>Epitelização</Text>
              <TextInput
                style={estilos.entradaPercentual}
                keyboardType="numeric"
                value={dadosFormulario.tipoTecido.epitelizacao.toString()}
                onChangeText={(valor) => atualizarTipoTecido('epitelizacao', parseInt(valor) || 0)}
              />
              <Text>%</Text>
            </View>
          </View>
          
          <View style={estilos.containerTotal}>
            <Text>Total: {Object.values(dadosFormulario.tipoTecido).reduce((a, b) => a + b, 0)}%</Text>
            {!validarPercentuaisTecido() && (
              <Text style={estilos.textoErro}>A soma deve ser 100%</Text>
            )}
          </View>
        </View>
        
        {/* Exsudato */}
        <View style={estilos.secao}>
          <Text style={estilos.tituloSubSecao}>Exsudato</Text>
          
          <Text style={estilos.rotulo}>Tipo</Text>
          <View style={estilos.grupoCheckbox}>
            {opcoesTipoExsudato.map((opcao) => (
              <CheckBox
                key={opcao.valor}
                style={estilos.checkbox}
                checked={dadosFormulario.exsudato.tipo === opcao.valor}
                onChange={() => atualizarExsudato('tipo', opcao.valor)}
              >
                {opcao.texto}
              </CheckBox>
            ))}
          </View>
          
          <Text style={estilos.rotulo}>Nível</Text>
          <View style={estilos.grupoCheckbox}>
            {opcoesNivelExsudato.map((opcao) => (
              <CheckBox
                key={opcao.valor}
                style={estilos.checkbox}
                checked={dadosFormulario.exsudato.nivel === opcao.valor}
                onChange={() => atualizarExsudato('nivel', opcao.valor)}
              >
                {opcao.texto}
              </CheckBox>
            ))}
          </View>
          
          <View style={estilos.containerSwitch}>
            <Text style={estilos.rotulo}>Acúmulo de exsudato no leito da ferida</Text>
            <Switch
              value={dadosFormulario.exsudato.acumulo}
              onValueChange={(valor) => atualizarExsudato('acumulo', valor)}
            />
          </View>
        </View>
        
        {/* Infecção */}
        <View style={estilos.secao}>
          <Text style={estilos.tituloSubSecao}>Infecção</Text>
          
          <Text style={estilos.rotulo}>Sinais de Infecção Local</Text>
          <View style={estilos.grupoCheckbox}>
            {sinaisInfeccaoLocal.map((sinal) => (
              <CheckBox
                key={sinal.valor}
                style={estilos.checkbox}
                checked={dadosFormulario.infeccao.local.includes(sinal.valor)}
                onChange={() => manipularAlternarInfeccaoLocal(sinal.valor)}
              >
                {sinal.texto}
              </CheckBox>
            ))}
          </View>
          
          <Text style={estilos.rotulo}>Sinais de Infecção Disseminada/Sistêmica</Text>
          <View style={estilos.grupoCheckbox}>
            {sinaisInfeccaoSistemica.map((sinal) => (
              <CheckBox
                key={sinal.valor}
                style={estilos.checkbox}
                checked={dadosFormulario.infeccao.sistemica.includes(sinal.valor)}
                onChange={() => manipularAlternarInfeccaoSistemica(sinal.valor)}
              >
                {sinal.texto}
              </CheckBox>
            ))}
          </View>
          
          <View style={estilos.containerSwitch}>
            <Text style={estilos.rotulo}>Suspeita de Biofilme</Text>
            <Text style={estilos.textoAjuda}>(Sinais clínicos que indicam a presença de Biofilme)</Text>
            <Switch
              value={dadosFormulario.infeccao.biofilme}
              onValueChange={(valor) => atualizarInfeccao('biofilme', valor)}
            />
          </View>
        </View>
        
        <Button style={estilos.botaoSalvar} onPress={manipularSalvar}>
          Salvar e Continuar
        </Button>
      </Card>
    </ScrollView>
  );
};

const estilos = StyleSheet.create({
  container: {
    flex: 1,
    padding: 10,
  },
  card: {
    marginBottom: 20,
  },
  tituloSecao: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 15,
    textAlign: 'center',
  },
  secao: {
    marginBottom: 20,
  },
  tituloSubSecao: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#3366FF',
  },
  rotulo: {
    fontSize: 16,
    marginBottom: 5,
    fontWeight: '500',
  },
  textoAjuda: {
    fontSize: 14,
    color: '#666',
    marginBottom: 10,
    fontStyle: 'italic',
  },
  containerTipoTecido: {
    marginBottom: 10,
  },
  itemTipoTecido: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 10,
  },
  entradaPercentual: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 5,
    padding: 8,
    width: 60,
    textAlign: 'center',
  },
  containerTotal: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: 10,
  },
  textoErro: {
    color: 'red',
    fontWeight: 'bold',
  },
  grupoCheckbox: {
    marginBottom: 15,
  },
  checkbox: {
    marginBottom: 10,
  },
  containerSwitch: {
    flexDirection: 'column',
    marginBottom: 15,
  },
  botaoSalvar: {
    marginTop: 20,
  },
});

export default FormularioAvaliacaoFerida;