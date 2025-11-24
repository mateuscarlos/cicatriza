import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Política de Privacidade')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateSection('Última atualização: 22 de novembro de 2025'),
            SizedBox(height: 24),
            _Section(
              title: '1. Introdução',
              content:
                  'O Cicatriza é um aplicativo desenvolvido para profissionais de saúde que atuam no tratamento e acompanhamento de feridas. Esta Política de Privacidade descreve como coletamos, usamos, armazenamos e protegemos suas informações pessoais e os dados dos pacientes sob seus cuidados, em conformidade com a Lei Geral de Proteção de Dados (LGPD - Lei nº 13.709/2018) e demais legislações aplicáveis.',
            ),
            _Section(
              title: '2. Definições',
              content:
                  '• Controlador: Responsável pelo aplicativo Cicatriza\n'
                  '• Usuário: Profissional de saúde cadastrado no aplicativo\n'
                  '• Titular: Paciente cujos dados são registrados pelo usuário\n'
                  '• Dados Pessoais: Informações relacionadas a pessoa natural identificada ou identificável\n'
                  '• Dados Sensíveis: Dados pessoais sobre saúde, conforme Art. 5º, II da LGPD',
            ),
            _Section(
              title: '3. Dados Coletados',
              content:
                  '3.1. Dados do Profissional de Saúde (Usuário):\n'
                  '• Dados cadastrais: nome completo, CPF, registro profissional (CRM, COREN, etc.)\n'
                  '• Dados de contato: e-mail, telefone\n'
                  '• Dados profissionais: especialidade, instituição de trabalho\n'
                  '• Dados de acesso: login, senha criptografada, histórico de acessos\n'
                  '• Dados de localização: quando autorizado, para registro de atendimentos\n\n'
                  '3.2. Dados dos Pacientes:\n'
                  '• Dados cadastrais: nome, data de nascimento, documento de identificação\n'
                  '• Dados clínicos: histórico de feridas, avaliações, fotos das lesões, tratamentos realizados\n'
                  '• Dados de saúde: comorbidades, medicamentos em uso, alergias\n'
                  '• Dados de evolução clínica: medições, observações, datas de atendimento',
            ),
            _Section(
              title: '4. Finalidade do Tratamento de Dados',
              content:
                  'Os dados pessoais são coletados e tratados para:\n'
                  '• Permitir o cadastro e autenticação do profissional de saúde\n'
                  '• Possibilitar o registro e acompanhamento da evolução de feridas\n'
                  '• Gerar relatórios clínicos e estatísticos\n'
                  '• Facilitar a comunicação entre profissionais sobre casos clínicos\n'
                  '• Cumprir obrigações legais e regulatórias da área de saúde\n'
                  '• Melhorar a qualidade do atendimento aos pacientes\n'
                  '• Permitir auditoria e controle de qualidade dos serviços de saúde',
            ),
            _Section(
              title: '5. Base Legal',
              content:
                  'O tratamento de dados pessoais no Cicatriza está fundamentado nas seguintes bases legais da LGPD:\n'
                  '• Art. 7º, I - Consentimento do titular (profissional usuário)\n'
                  '• Art. 11, II, f - Tutela da saúde, em procedimento realizado por profissionais da área da saúde\n'
                  '• Art. 7º, VI - Exercício regular de direitos, incluindo em processo judicial, administrativo ou arbitral\n'
                  '• Art. 7º, IX - Cumprimento de obrigação legal ou regulatória pelo controlador',
            ),
            _Section(
              title: '6. Compartilhamento de Dados',
              content:
                  '6.1. Os dados dos pacientes são compartilhados:\n'
                  '• Entre profissionais de saúde autorizados dentro da mesma instituição\n'
                  '• Em caso de transferência de cuidados, com consentimento do paciente\n'
                  '• Com autoridades de saúde, quando legalmente exigido\n\n'
                  '6.2. Não compartilhamos dados com:\n'
                  '• Empresas de publicidade\n'
                  '• Terceiros não autorizados\n'
                  '• Entidades fora do contexto de saúde, salvo ordem judicial',
            ),
            _Section(
              title: '7. Armazenamento e Segurança',
              content:
                  '7.1. Medidas de Segurança:\n'
                  '• Criptografia de dados em trânsito (TLS/SSL)\n'
                  '• Criptografia de dados em repouso\n'
                  '• Autenticação multifator opcional\n'
                  '• Controle de acesso baseado em perfis\n'
                  '• Logs de auditoria de todas as operações\n'
                  '• Backups automatizados e seguros\n'
                  '• Servidores em ambiente cloud com certificações de segurança\n\n'
                  '7.2. Localização:\n'
                  '• Dados armazenados em servidores localizados no Brasil ou em países com nível adequado de proteção de dados\n\n'
                  '7.3. Retenção:\n'
                  '• Dados de usuários: mantidos enquanto a conta estiver ativa\n'
                  '• Dados de pacientes: mantidos por 20 anos após o último atendimento, conforme Resolução CFM nº 1.821/2007',
            ),
            _Section(
              title: '8. Direitos dos Titulares',
              content:
                  'Conforme a LGPD, você e seus pacientes têm direito a:\n'
                  '• Confirmação da existência de tratamento (Art. 18, I)\n'
                  '• Acesso aos dados (Art. 18, II)\n'
                  '• Correção de dados incompletos, inexatos ou desatualizados (Art. 18, III)\n'
                  '• Anonimização, bloqueio ou eliminação de dados desnecessários (Art. 18, IV)\n'
                  '• Portabilidade dos dados (Art. 18, V)\n'
                  '• Eliminação dos dados tratados com consentimento (Art. 18, VI)\n'
                  '• Informação sobre compartilhamento (Art. 18, VII)\n'
                  '• Revogação do consentimento (Art. 18, IX)\n\n'
                  'Para exercer seus direitos, entre em contato através do e-mail: privacidade@cicatriza.com.br',
            ),
            _Section(
              title: '9. Contato',
              content:
                  'Para dúvidas sobre esta política:\n'
                  '• E-mail: contato@cicatriza.com.br\n'
                  '• DPO: dpo@cicatriza.com.br\n'
                  '• Website: www.cicatriza.com.br\n\n'
                  'Ao utilizar o Cicatriza, você declara ter lido e compreendido esta Política de Privacidade e concorda com seus termos.',
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _DateSection extends StatelessWidget {
  final String text;

  const _DateSection(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[600]));
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
