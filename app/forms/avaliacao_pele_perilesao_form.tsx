import React, { useState } from 'react';
import { View, StyleSheet, Text, ScrollView, TextInput, Switch } from 'react-native';
import { Button, Card } from '@ui-kitten/components';

// Definição dos tipos
interface CondicaoPele {
  presente: boolean;
  extensao: number;
}

interface DadosFormulario {
  maceracao: CondicaoPele;
  escoriacao: CondicaoPele;
  peleSeca: CondicaoPele;
  hiperqueratose: CondicaoPele;
  calo: CondicaoPele;
  eczema: CondicaoPele;
}

interface PropsFormularioAvaliacaoPelePerilesao {
  dadosIniciais?: Partial<DadosFormulario>;
  aoSalvar?: (dados: DadosFormulario) => void;
}

/**
 * Componente de formulário para avaliação da pele perilesão
 * 
 * Este componente implementa o formulário de avaliação da pele perilesão
 * baseado na metodologia do Triângulo de Avaliação de Feridas.
 * 
 * @param {Object} dadosIniciais - Dados iniciais para o formulário (opcional)
 * @param {Function} aoSalvar - Função chamada quando o formulário é salvo
 * @returns {React.Component} Componente de formulário
 */
const FormularioAvaliacaoPelePerilesao: React.FC<PropsFormularioAvaliacaoPelePerilesao> = ({ 
  dadosIniciais = {}, 
  aoSalvar 
}) => {
  // Estado para armazenar os dados do formulário
  const [dadosFormulario, setDadosFormulario] = useState<DadosFormulario>({
    maceracao: {
      presente: dadosIniciais.maceracao?.presente || false,
      extensao: dadosIniciais.maceracao?.extensao || 0,
    },
    escoriacao: {
      presente: dadosIniciais.escoriacao?.presente || false,
      extensao: dadosIniciais.escoriacao?.extensao || 0,
    },
    peleSeca: {
      presente: dadosIniciais.peleSeca?.presente || false,
      extensao: dadosIniciais.peleSeca?.extensao || 0,
    },
    hiperqueratose: {
      presente: dadosIniciais.hiperqueratose?.presente || false,
      extensao: dadosIniciais.hiperqueratose?.extensao || 0,
    },
    calo: {
      presente: dadosIniciais.calo?.presente || false,
      extensao: dadosIniciais.calo?.extensao || 0,
    },
    eczema: {
      presente: dadosIniciais.eczema?.presente || false,
      extensao: dadosIniciais.eczema?.extensao || 0,
    },
  });

  // Função para atualizar os dados de uma condição específica
  const atualizarCondicao = (condicao: keyof DadosFormulario, campo: keyof CondicaoPele, valor: boolean | number): void => {
    setDadosFormulario({
      ...dadosFormulario,
      [condicao]: {
        ...dadosFormulario[condicao],
        [campo]: valor
      }
    });
  };

  // Função para salvar o formulário
  const manipularSalvar = (): void => {
    if (aoSalvar) {
      aoSalvar(dadosFormulario);
    }
  };

  // Renderiza um item de condição da pele
  const renderizarItemCondicao = (condicao: keyof DadosFormulario, titulo: string, descricao: string): JSX.Element => {
    const dadosCondicao = dadosFormulario[condicao];
    
    return (
      <View style={estilos.secao}>
        <View style={estilos.containerInterruptor}>
          <Text style={estilos.rotulo}>{titulo}</Text>
          <Text style={estilos.textoAuxiliar}>{descricao}</Text>
          <Switch
            value={dadosCondicao.presente}
            onValueChange={(valor) => atualizarCondicao(condicao, 'presente', valor)}
          />
        </View>
        
        {dadosCondicao.presente && (
          <View style={estilos.containerExtensao}>
            <Text style={estilos.rotulo}>Extensão (cm)</Text>
            <Text style={estilos.textoAuxiliar}>
              Distância da borda da ferida até onde a condição se estende (até 4cm)
            </Text>
            <TextInput
              style={estilos.campoTexto}
              keyboardType="numeric"
              value={dadosCondicao.extensao.toString()}
              onChangeText={(valor) => atualizarCondicao(condicao, 'extensao', parseFloat(valor) || 0)}
              placeholder="Ex: 2.5"
            />
          </View>
        )}
      </View>
    );
  };

  return (
    <ScrollView style={estilos.container}>
      <Card style={estilos.cartao}>
        <Text style={estilos.tituloSecao}>Avaliação da Pele Perilesão</Text>
        <Text style={estilos.textoAuxiliar}>
          A pele perilesão é definida como a pele dentro de 4 cm da borda da ferida, 
          ou qualquer pele sob o curativo. Problemas na pele perilesão podem atrasar a cicatrização, 
          causar dor e desconforto para o paciente.
        </Text>
        
        {/* Maceração */}
        {renderizarItemCondicao(
          'maceracao',
          'Maceração',
          'Amolecimento da pele como resultado do contato prolongado com a umidade. Pele macerada de aspecto esbranquiçado.'
        )}
        
        {/* Escoriação */}
        {renderizarItemCondicao(
          'escoriacao',
          'Escoriação',
          'Causada por lesões repetidas na superfície da pele causada por trauma, por exemplo, arranhões, abrasão, reações a medicamentos ou irritantes.'
        )}
        
        {/* Pele Seca */}
        {renderizarItemCondicao(
          'peleSeca',
          'Pele Seca (Xerose)',
          'As células de queratina tornam-se planas e escamosas. A pele fica áspera e pode haver descamação visível.'
        )}
        
        {/* Hiperqueratose */}
        {renderizarItemCondicao(
          'hiperqueratose',
          'Hiperqueratose',
          'Acúmulo excessivo de pele seca (queratina), muitas vezes nas mãos, calcanhares e solas dos pés.'
        )}
        
        {/* Calo */}
        {renderizarItemCondicao(
          'calo',
          'Calo',
          'Parte da pele ou tecido mole engrossado e endurecido, especialmente em uma área que foi submetida a fricção ou pressão.'
        )}
        
        {/* Eczema */}
        {renderizarItemCondicao(
          'eczema',
          'Eczema',
          'Inflamação da pele, caracterizada por coceira, pele vermelha e erupção na pele.'
        )}
        
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
  cartao: {
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
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
    paddingBottom: 15,
  },
  rotulo: {
    fontSize: 16,
    marginBottom: 5,
    fontWeight: '500',
  },
  textoAuxiliar: {
    fontSize: 14,
    color: '#666',
    marginBottom: 10,
    fontStyle: 'italic',
  },
  containerInterruptor: {
    flexDirection: 'column',
    marginBottom: 10,
  },
  containerExtensao: {
    marginTop: 10,
    paddingLeft: 15,
    borderLeftWidth: 2,
    borderLeftColor: '#3366FF',
  },
  campoTexto: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 5,
    padding: 10,
    marginBottom: 15,
  },
  botaoSalvar: {
    marginTop: 20,
  },
});

export default FormularioAvaliacaoPelePerilesao;