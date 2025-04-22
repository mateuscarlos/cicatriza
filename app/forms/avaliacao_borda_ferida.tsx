import React, { useState } from 'react';
import { View, StyleSheet, Text, ScrollView, TextInput,  Switch } from 'react-native';
import { Button, CheckBox, Card } from '@ui-kitten/components';

// Definição dos tipos
interface DadosBordaFerida {
  maceracao: boolean;
  descolamento: {
    presente: boolean;
    localizacoes: string[];
    profundidade: number;
  };
  pelePerilesional: {
    eritema: boolean;
    escoriacao: boolean;
    ressecamento: boolean;
    maceracao: boolean;
    hiperqueratose: boolean;
    calosidade: boolean;
  };
  margemFerida: {
    aderida: boolean;
    naoAderida: boolean;
    enrolada: boolean;
  };
  dor: {
    nivel: number;
    tipo: string;
    gatilhos: string[];
    alivios: string[];
  };
}

interface Opcao {
  texto: string;
  valor: string;
}

interface PropriedadesFormularioAvaliacaoBordaFerida {
  dadosIniciais?: Partial<DadosBordaFerida>;
  aoSalvar?: (dados: DadosBordaFerida) => void;
}

/**
 * Componente de formulário para avaliação das bordas da ferida
 * 
 * Este componente implementa o formulário de avaliação da borda da ferida
 * baseado na metodologia do Triângulo de Avaliação de Feridas.
 * 
 * @param {Object} dadosIniciais - Dados iniciais para o formulário (opcional)
 * @param {Function} aoSalvar - Função chamada quando o formulário é salvo
 * @returns {React.Component} Componente de formulário
 */
const FormularioAvaliacaoBordaFerida: React.FC<PropriedadesFormularioAvaliacaoBordaFerida> = ({ dadosIniciais = {}, aoSalvar }) => {
  // Estado para armazenar os dados do formulário
  const [dadosFormulario, setDadosFormulario] = useState<DadosBordaFerida>({
    maceracao: dadosIniciais.maceracao || false,
    descolamento: {
      presente: dadosIniciais.descolamento?.presente || false,
      localizacoes: dadosIniciais.descolamento?.localizacoes || [],
      profundidade: dadosIniciais.descolamento?.profundidade || 0,
    },
    pelePerilesional: {
      eritema: dadosIniciais.pelePerilesional?.eritema || false,
      escoriacao: dadosIniciais.pelePerilesional?.escoriacao || false,
      ressecamento: dadosIniciais.pelePerilesional?.ressecamento || false,
      maceracao: dadosIniciais.pelePerilesional?.maceracao || false,
      hiperqueratose: dadosIniciais.pelePerilesional?.hiperqueratose || false,
      calosidade: dadosIniciais.pelePerilesional?.calosidade || false,
    },
    margemFerida: {
      aderida: dadosIniciais.margemFerida?.aderida || false,
      naoAderida: dadosIniciais.margemFerida?.naoAderida || false,
      enrolada: dadosIniciais.margemFerida?.enrolada || false,
    },
    dor: {
      nivel: dadosIniciais.dor?.nivel || 0,
      tipo: dadosIniciais.dor?.tipo || '',
      gatilhos: dadosIniciais.dor?.gatilhos || [],
      alivios: dadosIniciais.dor?.alivios || [],
    },
  });

  // Opções para localizações de descolamento (undermining)
  const localizacoesDescolamento: Opcao[] = [
    { texto: 'Superior', valor: 'superior' },
    { texto: 'Inferior', valor: 'inferior' },
    { texto: 'Lateral Direita', valor: 'right_lateral' },
    { texto: 'Lateral Esquerda', valor: 'left_lateral' },
  ];

  // Opções para tipos de dor
  const tiposDor: Opcao[] = [
    { texto: 'Nociceptiva', valor: 'nociceptive' },
    { texto: 'Neuropática', valor: 'neuropathic' },
    { texto: 'Mista', valor: 'mixed' },
  ];

  // Opções para gatilhos da dor
  const gatilhosDor: Opcao[] = [
    { texto: 'Troca de Curativo', valor: 'dressing_change' },
    { texto: 'Movimentação', valor: 'movement' },
    { texto: 'Mudança de Posição', valor: 'position_change' },
    { texto: 'Contato', valor: 'contact' },
    { texto: 'Pressão', valor: 'pressure' },
    { texto: 'Espontânea', valor: 'spontaneous' },
  ];

  // Opções para alívio da dor
  const aliviosDor: Opcao[] = [
    { texto: 'Medicação Oral', valor: 'oral_medication' },
    { texto: 'Medicação Tópica', valor: 'topical_medication' },
    { texto: 'Elevação do Membro', valor: 'limb_elevation' },
    { texto: 'Repouso', valor: 'rest' },
    { texto: 'Mudança de Posição', valor: 'position_change' },
    { texto: 'Alívio da Pressão', valor: 'pressure_relief' },
  ];

  // Função para atualizar dados simples
  const atualizarDadosFormulario = (campo: keyof DadosBordaFerida, valor: boolean | number | string | string[]): void => {
    setDadosFormulario({
      ...dadosFormulario,
      [campo]: valor,
    });
  };

  // Função para atualizar dados de descolamento
  const atualizarDescolamento = (
    campo: keyof DadosBordaFerida['descolamento'], 
    valor: boolean | number | string[]
  ): void => {
    setDadosFormulario({
      ...dadosFormulario,
      descolamento: {
        ...dadosFormulario.descolamento,
        [campo]: valor,
      },
    });
  };

  // Função para atualizar dados da pele perilesional
  const atualizarPelePerilesional = (campo: keyof DadosBordaFerida['pelePerilesional'], valor: boolean): void => {
    setDadosFormulario({
      ...dadosFormulario,
      pelePerilesional: {
        ...dadosFormulario.pelePerilesional,
        [campo]: valor,
      },
    });
  };

  // Função para atualizar dados da margem da ferida
  const atualizarMargemFerida = (campo: keyof DadosBordaFerida['margemFerida'], valor: boolean): void => {
    setDadosFormulario({
      ...dadosFormulario,
      margemFerida: {
        ...dadosFormulario.margemFerida,
        [campo]: valor,
      },
    });
  };

  // Função para atualizar dados de dor
  const atualizarDor = (campo: keyof DadosBordaFerida['dor'], valor: number | string | string[]): void => {
    setDadosFormulario({
      ...dadosFormulario,
      dor: {
        ...dadosFormulario.dor,
        [campo]: valor,
      },
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

  // Função para lidar com a seleção de localizações de descolamento
  const manipularAlternarLocalizacaoDescolamento = (item: string): void => {
    const listaAtualizada = alternarItemLista(dadosFormulario.descolamento.localizacoes, item);
    atualizarDescolamento('localizacoes', listaAtualizada);
  };

  // Função para lidar com a seleção de gatilhos de dor
  const manipularAlternarGatilhoDor = (item: string): void => {
    const listaAtualizada = alternarItemLista(dadosFormulario.dor.gatilhos, item);
    atualizarDor('gatilhos', listaAtualizada);
  };

  // Função para lidar com a seleção de alívios de dor
  const manipularAlternarAlivioDor = (item: string): void => {
    const listaAtualizada = alternarItemLista(dadosFormulario.dor.alivios, item);
    atualizarDor('alivios', listaAtualizada);
  };

  // Função para salvar o formulário
  const manipularSalvar = (): void => {
    if (aoSalvar) {
      aoSalvar(dadosFormulario);
    }
  };

  return (
    <ScrollView style={estilos.container}>
      <Card style={estilos.card}>
        <Text style={estilos.tituloSecao}>Avaliação das Bordas da Ferida</Text>
        
        {/* Maceração */}
        <View style={estilos.secao}>
          <View style={estilos.containerSwitch}>
            <Text style={estilos.rotulo}>Maceração</Text>
            <Switch
              value={dadosFormulario.maceracao}
              onValueChange={(valor) => atualizarDadosFormulario('maceracao', valor)}
            />
          </View>
        </View>
        
        {/* Descolamento */}
        <View style={estilos.secao}>
          <Text style={estilos.tituloSubSecao}>Descolamento (Undermining)</Text>
          
          <View style={estilos.containerSwitch}>
            <Text style={estilos.rotulo}>Presente</Text>
            <Switch
              value={dadosFormulario.descolamento.presente}
              onValueChange={(valor) => atualizarDescolamento('presente', valor)}
            />
          </View>
          
          {dadosFormulario.descolamento.presente && (
            <>
              <Text style={estilos.rotulo}>Localizações</Text>
              <View style={estilos.grupoCheckbox}>
                {localizacoesDescolamento.map((localizacao) => (
                  <CheckBox
                    key={localizacao.valor}
                    style={estilos.checkbox}
                    checked={dadosFormulario.descolamento.localizacoes.includes(localizacao.valor)}
                    onChange={() => manipularAlternarLocalizacaoDescolamento(localizacao.valor)}
                  >
                    {localizacao.texto}
                  </CheckBox>
                ))}
              </View>
              
              <Text style={estilos.rotulo}>Profundidade (cm)</Text>
              <TextInput
                style={estilos.entrada}
                keyboardType="numeric"
                value={dadosFormulario.descolamento.profundidade.toString()}
                onChangeText={(valor) => atualizarDescolamento('profundidade', parseFloat(valor) || 0)}
              />
            </>
          )}
        </View>
        
        {/* Pele Perilesional */}
        <View style={estilos.secao}>
          <Text style={estilos.tituloSubSecao}>Pele Perilesional</Text>
          
          <View style={estilos.grupoCheckbox}>
            <CheckBox
              style={estilos.checkbox}
              checked={dadosFormulario.pelePerilesional.eritema}
              onChange={(marcado) => atualizarPelePerilesional('eritema', marcado)}
            >
              Eritema
            </CheckBox>
            
            <CheckBox
              style={estilos.checkbox}
              checked={dadosFormulario.pelePerilesional.escoriacao}
              onChange={(marcado) => atualizarPelePerilesional('escoriacao', marcado)}
            >
              Escoriação
            </CheckBox>
            
            <CheckBox
              style={estilos.checkbox}
              checked={dadosFormulario.pelePerilesional.ressecamento}
              onChange={(marcado) => atualizarPelePerilesional('ressecamento', marcado)}
            >
              Ressecamento
            </CheckBox>
            
            <CheckBox
              style={estilos.checkbox}
              checked={dadosFormulario.pelePerilesional.maceracao}
              onChange={(marcado) => atualizarPelePerilesional('maceracao', marcado)}
            >
              Maceração
            </CheckBox>
            
            <CheckBox
              style={estilos.checkbox}
              checked={dadosFormulario.pelePerilesional.hiperqueratose}
              onChange={(marcado) => atualizarPelePerilesional('hiperqueratose', marcado)}
            >
              Hiperqueratose
            </CheckBox>
            
            <CheckBox
              style={estilos.checkbox}
              checked={dadosFormulario.pelePerilesional.calosidade}
              onChange={(marcado) => atualizarPelePerilesional('calosidade', marcado)}
            >
              Calosidade
            </CheckBox>
          </View>
        </View>
        
        {/* Margem da Ferida */}
        <View style={estilos.secao}>
          <Text style={estilos.tituloSubSecao}>Margem da Ferida</Text>
          
          <View style={estilos.grupoCheckbox}>
            <CheckBox
              style={estilos.checkbox}
              checked={dadosFormulario.margemFerida.aderida}
              onChange={(marcado) => atualizarMargemFerida('aderida', marcado)}
            >
              Aderida
            </CheckBox>
            
            <CheckBox
              style={estilos.checkbox}
              checked={dadosFormulario.margemFerida.naoAderida}
              onChange={(marcado) => atualizarMargemFerida('naoAderida', marcado)}
            >
              Não Aderida
            </CheckBox>
            
            <CheckBox
              style={estilos.checkbox}
              checked={dadosFormulario.margemFerida.enrolada}
              onChange={(marcado) => atualizarMargemFerida('enrolada', marcado)}
            >
              Enrolada/Epibolia
            </CheckBox>
          </View>
        </View>
        
        {/* Dor */}
        <View style={estilos.secao}>
          <Text style={estilos.tituloSubSecao}>Dor</Text>
          
          <Text style={estilos.rotulo}>Nível de Dor (0-10)</Text>
          <TextInput
            style={estilos.entrada}
            keyboardType="numeric"
            value={dadosFormulario.dor.nivel.toString()}
            onChangeText={(valor) => {
              const valorNumerico = parseInt(valor);
              if (isNaN(valorNumerico)) {
                atualizarDor('nivel', 0);
              } else if (valorNumerico > 10) {
                atualizarDor('nivel', 10);
              } else if (valorNumerico < 0) {
                atualizarDor('nivel', 0);
              } else {
                atualizarDor('nivel', valorNumerico);
              }
            }}
          />
          
          <Text style={estilos.rotulo}>Tipo de Dor</Text>
          <View style={estilos.grupoCheckbox}>
            {tiposDor.map((tipo) => (
              <CheckBox
                key={tipo.valor}
                style={estilos.checkbox}
                checked={dadosFormulario.dor.tipo === tipo.valor}
                onChange={() => atualizarDor('tipo', tipo.valor)}
              >
                {tipo.texto}
              </CheckBox>
            ))}
          </View>
          
          <Text style={estilos.rotulo}>Gatilhos da Dor</Text>
          <View style={estilos.grupoCheckbox}>
            {gatilhosDor.map((gatilho) => (
              <CheckBox
                key={gatilho.valor}
                style={estilos.checkbox}
                checked={dadosFormulario.dor.gatilhos.includes(gatilho.valor)}
                onChange={() => manipularAlternarGatilhoDor(gatilho.valor)}
              >
                {gatilho.texto}
              </CheckBox>
            ))}
          </View>
          
          <Text style={estilos.rotulo}>O que Alivia</Text>
          <View style={estilos.grupoCheckbox}>
            {aliviosDor.map((alivio) => (
              <CheckBox
                key={alivio.valor}
                style={estilos.checkbox}
                checked={dadosFormulario.dor.alivios.includes(alivio.valor)}
                onChange={() => manipularAlternarAlivioDor(alivio.valor)}
              >
                {alivio.texto}
              </CheckBox>
            ))}
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
  containerSwitch: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 15,
  },
  grupoCheckbox: {
    marginBottom: 15,
  },
  checkbox: {
    marginBottom: 10,
  },
  entrada: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 5,
    padding: 8,
    marginBottom: 15,
  },
  botaoSalvar: {
    marginTop: 20,
  },
});

export default FormularioAvaliacaoBordaFerida;