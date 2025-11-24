import 'package:flutter/material.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Termos de Uso')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateSection('Última atualização: 22 de novembro de 2025'),
            SizedBox(height: 24),
            _Section(
              title: '1. Aceitação dos Termos',
              content:
                  'Ao criar uma conta e utilizar o aplicativo Cicatriza, você concorda com estes Termos de Uso e com a Política de Privacidade. Se você não concordar com qualquer parte destes termos, não deve utilizar o aplicativo.\n\n'
                  'Estes termos constituem um contrato legalmente vinculante entre você (profissional de saúde) e os responsáveis pelo aplicativo Cicatriza.',
            ),
            _Section(
              title: '2. Descrição do Serviço',
              content:
                  'O Cicatriza é um aplicativo móvel desenvolvido para auxiliar profissionais de saúde no registro, acompanhamento e gestão do tratamento de feridas. O serviço inclui:\n\n'
                  '• Cadastro e gerenciamento de pacientes\n'
                  '• Registro fotográfico de lesões\n'
                  '• Documentação de avaliações e tratamentos\n'
                  '• Histórico e evolução clínica\n'
                  '• Geração de relatórios\n'
                  '• Sincronização de dados em nuvem',
            ),
            _Section(
              title: '3. Elegibilidade',
              content:
                  '3.1. Requisitos:\n'
                  '• Ser profissional de saúde legalmente habilitado\n'
                  '• Possuir registro ativo em conselho profissional (CRM, COREN, CRF, etc.)\n'
                  '• Ser maior de 18 anos\n'
                  '• Ter autorização legal para exercer a profissão no Brasil\n\n'
                  '3.2. Verificação:\n'
                  '• Reservamo-nos o direito de verificar suas credenciais profissionais\n'
                  '• Podemos solicitar documentação comprobatória a qualquer momento\n'
                  '• Contas com informações falsas serão imediatamente suspensas',
            ),
            _Section(
              title: '4. Responsabilidades do Usuário',
              content:
                  '• Fornecer informações verdadeiras, precisas e completas\n'
                  '• Manter suas credenciais de acesso seguras e confidenciais\n'
                  '• Notificar imediatamente sobre uso não autorizado de sua conta\n'
                  '• Atualizar suas informações quando necessário\n'
                  '• Não compartilhar sua conta com terceiros\n'
                  '• Você é totalmente responsável por todas as atividades realizadas em sua conta',
            ),
            _Section(
              title: '5. Uso Adequado do Aplicativo',
              content:
                  '5.1. Usos Permitidos:\n'
                  '• Documentação clínica legítima de pacientes sob seus cuidados\n'
                  '• Registro de evolução de feridas e tratamentos\n'
                  '• Geração de relatórios para fins profissionais\n'
                  '• Compartilhamento de informações com equipe autorizada\n\n'
                  '5.2. Usos Proibidos:\n'
                  '• Registrar dados de pacientes sem consentimento adequado\n'
                  '• Compartilhar informações de pacientes fora do contexto clínico\n'
                  '• Usar o aplicativo para fins não relacionados à assistência à saúde\n'
                  '• Violar qualquer lei ou regulamento de saúde\n'
                  '• Realizar engenharia reversa ou desmontagem do aplicativo\n'
                  '• Introduzir malware, vírus ou códigos maliciosos\n'
                  '• Tentar acessar dados de outros usuários sem autorização',
            ),
            _Section(
              title: '6. Responsabilidades Profissionais',
              content:
                  'Como profissional de saúde, você é responsável por:\n'
                  '• Obter consentimento informado dos pacientes para registro de dados\n'
                  '• Garantir a precisão das informações inseridas\n'
                  '• Seguir as normas éticas e legais de sua profissão\n'
                  '• Cumprir as resoluções dos conselhos profissionais\n'
                  '• Manter a confidencialidade dos dados dos pacientes\n'
                  '• Usar o aplicativo como ferramenta complementar ao juízo clínico\n\n'
                  'O Cicatriza é uma ferramenta de suporte, não substituindo o julgamento profissional. Decisões clínicas são de exclusiva responsabilidade do profissional de saúde.',
            ),
            _Section(
              title: '7. Privacidade e Proteção de Dados',
              content:
                  'O tratamento de dados pessoais segue nossa Política de Privacidade e a LGPD (Lei nº 13.709/2018):\n'
                  '• Dados são criptografados e armazenados com segurança\n'
                  '• Acesso restrito por autenticação e controle de permissões\n'
                  '• Conformidade com regulamentações de saúde (CFM, COFEN, etc.)\n'
                  '• Direito de acesso, correção e exclusão de dados conforme LGPD',
            ),
            _Section(
              title: '8. Disponibilidade do Serviço',
              content:
                  'Envidamos esforços para manter o aplicativo disponível 24/7, mas não garantimos disponibilidade ininterrupta ou livre de erros.\n\n'
                  'Não nos responsabilizamos por indisponibilidade devido a:\n'
                  '• Falhas de internet ou telecomunicações\n'
                  '• Caso fortuito ou força maior\n'
                  '• Manutenções emergenciais\n'
                  '• Ataques cibernéticos ou eventos fora de nosso controle',
            ),
            _Section(
              title: '9. Limitação de Responsabilidade',
              content:
                  'Na máxima extensão permitida por lei:\n'
                  '• O Cicatriza é fornecido "como está" e "conforme disponível"\n'
                  '• Não garantimos resultados clínicos específicos\n'
                  '• Não nos responsabilizamos por decisões clínicas tomadas com base no aplicativo\n'
                  '• Não somos responsáveis por erros de entrada de dados pelo usuário\n'
                  '• Não seremos responsáveis por danos indiretos, incidentais, especiais ou consequenciais\n'
                  '• Responsabilidade limitada ao valor pago pelo serviço nos últimos 12 meses',
            ),
            _Section(
              title: '10. Rescisão',
              content:
                  '10.1. Por Você:\n'
                  '• Pode cancelar sua conta a qualquer momento através das configurações\n'
                  '• Exclusão de conta é irreversível e resultará em perda de dados\n\n'
                  '10.2. Por Nós:\n'
                  '• Podemos suspender ou encerrar sua conta por violação destes termos\n'
                  '• Podemos encerrar o serviço com aviso prévio de 90 dias\n\n'
                  '10.3. Efeitos da Rescisão:\n'
                  '• Perda de acesso ao aplicativo\n'
                  '• Direito de exportar seus dados antes da exclusão (exceto em caso de violação grave)\n'
                  '• Obrigações de confidencialidade permanecem em vigor',
            ),
            _Section(
              title: '11. Conformidade Legal',
              content:
                  'Legislação Aplicável:\n'
                  '• Lei nº 13.709/2018 (LGPD - Lei Geral de Proteção de Dados)\n'
                  '• Lei nº 12.965/2014 (Marco Civil da Internet)\n'
                  '• Resolução CFM nº 1.821/2007 (prontuários médicos)\n'
                  '• Código de Ética de sua categoria profissional\n'
                  '• Regulamentações dos conselhos profissionais de saúde\n\n'
                  'Você deve cumprir todas as leis aplicáveis ao exercício profissional.',
            ),
            _Section(
              title: '12. Alterações nos Termos',
              content:
                  'Podemos modificar estes Termos de Uso periodicamente. Alterações significativas serão notificadas através do aplicativo ou e-mail. O uso continuado após alterações constitui aceitação dos novos termos.',
            ),
            _Section(
              title: '13. Contato',
              content:
                  'Para questões sobre estes Termos de Uso:\n'
                  '• E-mail: juridico@cicatriza.com.br\n'
                  '• Suporte técnico: suporte@cicatriza.com.br\n'
                  '• Telefone: (11) 0000-0000\n\n'
                  'Horário de atendimento: Segunda a sexta, 9h às 18h',
            ),
            SizedBox(height: 16),
            _AcceptanceBox(),
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

class _AcceptanceBox extends StatelessWidget {
  const _AcceptanceBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: const Text(
        'Ao utilizar o Cicatriza, você declara ter lido, compreendido e concordado com estes Termos de Uso e com a Política de Privacidade.',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
