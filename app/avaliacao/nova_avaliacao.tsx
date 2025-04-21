import React, { useState } from 'react';
import { YStack, XStack, Input, Button, Text, Form, ScrollView, H1, Switch, TextArea, Select, Spinner, KeyboardAvoidingView, Slider, Card } from 'tamagui';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, Camera, Check, X, Calendar, Thermometer, Droplet, FileText, Activity } from '@tamagui/lucide-icons';
import * as Haptics from 'expo-haptics';
import { Platform } from 'react-native';

/**
 * Tela de Nova Avaliação de Ferida da aplicação Cicatriza
 * 
 * Esta tela permite registrar uma nova avaliação para uma ferida existente,
 * incluindo dimensões, características do tecido, exsudato, bordas, pele perilesional,
 * dor, odor, sinais de infecção e observações.
 */
export default function NovaAvaliacaoScreen() {
  const router = useRouter();
  const { id, pacienteId } = useLocalSearchParams<{ id: string, pacienteId: string }>();
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [imagemSelecionada, setImagemSelecionada] = useState(null);
  const [ferida, setFerida] = useState(null);

  // Estado do formulário
  const [form, setForm] = useState({
    data: new Date(),
    dimensoes: {
      comprimento: '',
      largura: '',
      profundidade: '',
      unidade: 'cm'
    },
    exsudato: {
      tipo: 'Seroso',
      quantidade: 'Pequeno'
    },
    tecidos: {
      granulacao: 50,
      fibrina: 30,
      necrose: 20
    },
    bordas: '',
    pele: '',
    dor: 0,
    odor: 'Ausente',
    sinaisInfeccao: false,
    observacoes: ''
  });

  /**
   * Atualiza o estado do formulário
   */
  const atualizarForm = (campo, valor) => {
    // Lógica para atualizar campos aninhados
    const campos = campo.split('.');
    if (campos.length === 1) {
      setForm(prev => ({ ...prev, [campo]: valor }));
    } else {
      setForm(prev => {
        const novoForm = { ...prev };
        let atual = novoForm;
        for (let i = 0; i < campos.length - 1; i++) {
          atual = atual[campos[i]];
        }
        atual[campos[campos.length - 1]] = valor;
        return novoForm;
      });
    }
  };

  /**
   * Seleciona uma imagem para a avaliação
   */
  const selecionarImagem = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    // Simulação de seleção de imagem - substituir pela implementação real
    setImagemSelecionada('https://example.com/images/wound_assessment.jpg');
  };

  /**
   * Formata a data para exibição
   */
  const formatarData = (data) => {
    if (!data) return '';
    return data.toLocaleDateString('pt-BR');
  };

  /**
   * Salva a avaliação
   */
  const salvarAvaliacao = async () => {
    // Validação básica
    if (!form.dimensoes.comprimento || !form.dimensoes.largura) {
      setError('As dimensões da lesão são obrigatórias');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
      return;
    }

    try {
      setIsLoading(true);
      setError('');
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
      
      // Simulação de salvamento - substituir pela implementação real com Firebase
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // Navegar de volta para a tela de detalhes da ferida
      router.replace(`/(app)/pacientes/${pacienteId}/lesoes/${id}`);
    } catch (err) {
      setError('Falha ao salvar avaliação. Tente novamente.');
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
    } finally {
      setIsLoading(false);
    }
  };

  /**
   * Cancela o cadastro e retorna para a tela anterior
   */
  const cancelar = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    router.back();
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={{ flex: 1 }}
    >
      <ScrollView>
        <YStack flex={1} padding="$4" backgroundColor="$background" space="$4">
          {/* Cabeçalho */}
          <XStack justifyContent="space-between" alignItems="center">
            <Button
              size="$3"
              backgroundColor="$backgroundSecondary"
              icon={<ArrowLeft size={18} color="$text" />}
              onPress={cancelar}
            >
              Voltar
            </Button>
            <H1 fontSize="$6" color="$text">Nova Avaliação</H1>
            <Button size="$3" backgroundColor="transparent" />
          </XStack>

          {/* Formulário */}
          <Form space="$4" onSubmit={salvarAvaliacao}>
            {error ? (
              <Text color="$red10" textAlign="center" marginBottom="$2">
                {error}
              </Text>
            ) : null}

            {/* Data da Avaliação */}
            <YStack space="$2">
              <Text color="$textSecondary">Data da Avaliação</Text>
              <Input
                size="$4"
                placeholder="DD/MM/AAAA"
                value={formatarData(form.data)}
                // Na implementação real, usar um DatePicker
                backgroundColor="$background"
                borderColor="$borderColor"
                focusStyle={{ borderColor: '$primary' }}
                icon={<Calendar size={18} color="$textSecondary" />}
              />
            </YStack>

            {/* Dimensões */}
            <YStack space="$4" backgroundColor="$backgroundSecondary" padding="$4" borderRadius="$4">
              <Text fontSize="$5" fontWeight="bold" color="$text">Dimensões *</Text>

              <XStack space="$2">
                <YStack flex={1} space="$2">
                  <Text color="$textSecondary">Comprimento</Text>
                  <Input
                    size="$4"
                    placeholder="0.0"
                    value={form.dimensoes.comprimento}
                    onChangeText={(text) => atualizarForm('dimensoes.comprimento', text)}
                    keyboardType="numeric"
                    backgroundColor="$background"
                    borderColor="$borderColor"
                    focusStyle={{ borderColor: '$primary' }}
                  />
                </YStack>
                
                <YStack flex={1} space="$2">
                  <Text color="$textSecondary">Largura</Text>
                  <Input
                    size="$4"
                    placeholder="0.0"
                    value={form.dimensoes.largura}
                    onChangeText={(text) => atualizarForm('dimensoes.largura', text)}
                    keyboardType="numeric"
                    backgroundColor="$background"
                    borderColor="$borderColor"
                    focusStyle={{ borderColor: '$primary' }}
                  />
                </YStack>
              </XStack>

              <YStack space="$2">
                <Text color="$textSecondary">Profundidade (opcional)</Text>
                <Input
                  size="$4"
                  placeholder="0.0"
                  value={form.dimensoes.profundidade}
                  onChangeText={(text) => atualizarForm('dimensoes.profundidade', text)}
                  keyboardType="numeric"
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                />
              </YStack>

              <YStack space="$2">
                <Text color="$textSecondary">Unidade de Medida</Text>
                <Select
                  size="$4"
                  value={form.dimensoes.unidade}
                  onValueChange={(value) => atualizarForm('dimensoes.unidade', value)}
                  backgroundColor="$background"
                >
                  <Select.Trigger iconAfter={<Select.CaretDown />}>
                    <Select.Value placeholder="Selecione a unidade" />
                  </Select.Trigger>
                  <Select.Content>
                    <Select.Item index={0} value="cm">
                      <Select.ItemText>Centímetros (cm)</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={1} value="mm">
                      <Select.ItemText>Milímetros (mm)</Select.ItemText>
                    </Select.Item>
                  </Select.Content>
                </Select>
              </YStack>
            </YStack>

            {/* Exsudato */}
            <YStack space="$4" backgroundColor="$backgroundSecondary" padding="$4" borderRadius="$4">
              <Text fontSize="$5" fontWeight="bold" color="$text">Exsudato</Text>

              <YStack space="$2">
                <Text color="$textSecondary">Tipo</Text>
                <Select
                  size="$4"
                  value={form.exsudato.tipo}
                  onValueChange={(value) => atualizarForm('exsudato.tipo', value)}
                  backgroundColor="$background"
                >
                  <Select.Trigger iconAfter={<Select.CaretDown />}>
                    <Select.Value placeholder="Selecione o tipo" />
                  </Select.Trigger>
                  <Select.Content>
                    <Select.Item index={0} value="Seroso">
                      <Select.ItemText>Seroso</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={1} value="Serosanguinolento">
                      <Select.ItemText>Serosanguinolento</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={2} value="Sanguinolento">
                      <Select.ItemText>Sanguinolento</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={3} value="Purulento">
                      <Select.ItemText>Purulento</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={4} value="Ausente">
                      <Select.ItemText>Ausente</Select.ItemText>
                    </Select.Item>
                  </Select.Content>
                </Select>
              </YStack>

              <YStack space="$2">
                <Text color="$textSecondary">Quantidade</Text>
                <Select
                  size="$4"
                  value={form.exsudato.quantidade}
                  onValueChange={(value) => atualizarForm('exsudato.quantidade', value)}
                  backgroundColor="$background"
                >
                  <Select.Trigger iconAfter={<Select.CaretDown />}>
                    <Select.Value placeholder="Selecione a quantidade" />
                  </Select.Trigger>
                  <Select.Content>
                    <Select.Item index={0} value="Ausente">
                      <Select.ItemText>Ausente</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={1} value="Pequeno">
                      <Select.ItemText>Pequeno</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={2} value="Moderado">
                      <Select.ItemText>Moderado</Select.ItemText>
                    </Select.Item>
                    <Select.Item index={3} value="Grande">
                      <Select.ItemText>Grande</Select.ItemText>
                    </Select.Item>
                  </Select.Content>
                </Select>
              </YStack>
            </YStack>

            {/* Tecidos */}
            <YStack space="$4" backgroundColor="$backgroundSecondary" padding="$4" borderRadius="$4">
              <Text fontSize="$5" fontWeight="bold" color="$text">Tecidos (% aproximada)</Text>

              <YStack space="$3">
                <Text color="$textSecondary">Tecido de Granulação: {form.tecidos.granulacao}%</Text>
                <Slider
                  size="$4"
                  defaultValue={[form.tecidos.granulacao]}
                  max={100}
                  step={5}
                  onValueChange={(value) => {
                    const granulacao = value[0];
                    const restante = 100 - granulacao;
                    const fibrina = Math.round((form.tecidos.fibrina / (form.tecidos.fibrina + form.tecidos.necrose)) * restante);
                    const necrose = restante - fibrina;
                    
                    atualizarForm('tecidos.granulacao', granulacao);
                    atualizarForm('tecidos.fibrina', fibrina);
                    atualizarForm('tecidos.necrose', necrose);
                  }}
                >
                  <Slider.Track backgroundColor="$backgroundSecondary">
                    <Slider.TrackActive backgroundColor="$green10" />
                  </Slider.Track>
                  <Slider.Thumb backgroundColor="$green10" />
                </Slider>
              </YStack>

              <YStack space="$3">
                <Text color="$textSecondary">Tecido de Fibrina: {form.tecidos.fibrina}%</Text>
                <Slider
                  size="$4"
                  defaultValue={[form.tecidos.fibrina]}
                  max={100 - form.tecidos.granulacao}
                  step={5}
                  onValueChange={(value) => {
                    const fibrina = value[0];
                    const necrose = 100 - form.tecidos.granulacao - fibrina;
                    
                    atualizarForm('tecidos.fibrina', fibrina);
                    atualizarForm('tecidos.necrose', necrose);
                  }}
                >
                  <Slider.Track backgroundColor="$backgroundSecondary">
                    <Slider.TrackActive backgroundColor="$yellow10" />
                  </Slider.Track>
                  <Slider.Thumb backgroundColor="$yellow10" />
                </Slider>
              </YStack>

              <YStack space="$3">
                <Text color="$textSecondary">Tecido Necrótico: {form.tecidos.necrose}%</Text>
                <Slider
                  size="$4"
                  defaultValue={[form.tecidos.necrose]}
                  max={100 - form.tecidos.granulacao - form.tecidos.fibrina}
                  step={5}
                  disabled
                >
                  <Slider.Track backgroundColor="$backgroundSecondary">
                    <Slider.TrackActive backgroundColor="$gray10" />
                  </Slider.Track>
                  <Slider.Thumb backgroundColor="$gray10" />
                </Slider>
              </YStack>
            </YStack>

            {/* Bordas e Pele Perilesional */}
            <YStack space="$4" backgroundColor="$backgroundSecondary" padding="$4" borderRadius="$4">
              <Text fontSize="$5" fontWeight="bold" color="$text">Bordas e Pele Perilesional</Text>

              <YStack space="$2">
                <Text color="$textSecondary">Bordas</Text>
                <TextArea
                  size="$4"
                  placeholder="Descreva as características das bordas (ex: regulares, irregulares, maceradas, epitelizadas)"
                  value={form.bordas}
                  onChangeText={(text) => atualizarForm('bordas', text)}
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                  minHeight={80}
                />
              </YStack>

              <YStack space="$2">
                <Text color="$textSecondary">Pele Perilesional</Text>
                <TextArea
                  size="$4"
                  placeholder="Descreva as características da pele ao redor da lesão (ex: hiperemiada, macerada, íntegra)"
                  value={form.pele}
                  onChangeText={(text) => atualizarForm('pele', text)}
                  backgroundColor="$background"
                  borderColor="$borderColor"
                  focusStyle={{ borderColor: '$primary' }}
                  minHeight={80}
                />
              </YStack>
            </YStack>

            {/* Dor, Odor e Sinais de Infecção */}
            <YStack space="$4">
              {/* Add the content for this section here */}
            </YStack>

            {/* Observações */}
            <YStack space="$4" backgroundColor="$backgroundSecondary" padding="$4" borderRadius="$4">
              <Text fontSize="$5" fontWeight="bold" color="$text">Observações</Text>
              <TextArea
                size="$4"
                placeholder="Adicione observações adicionais sobre a lesão"
                value={form.observacoes}
                onChangeText={(text) => atualizarForm('observacoes', text)}
                backgroundColor="$background"
                borderColor="$borderColor"
                focusStyle={{ borderColor: '$primary' }}
                minHeight={80}
              />
            </YStack>

            {/* Botões de Ação */}
            <XStack justifyContent="space-between" marginTop="$4">
              <Button
                size="$4"
                backgroundColor="$red10"
                icon={<X size={18} color="$background" />}
                onPress={cancelar}
              >
                Cancelar
              </Button>
              <Button
                size="$4"
                backgroundColor="$green10"
                icon={isLoading ? <Spinner color="$background" /> : <Check size={18} color="$background" />}
                onPress={salvarAvaliacao}
                disabled={isLoading}
              >
                {isLoading ? 'Salvando...' : 'Salvar'}
              </Button>
            </XStack>
          </Form>
        </YStack>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}