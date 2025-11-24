import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../domain/entities/user_profile.dart';
import 'dart:convert';

class QrCodePage extends StatelessWidget {
  final UserProfile profile;

  const QrCodePage({required this.profile, super.key});

  String _generateQrData() {
    // Gera dados estruturados do perfil profissional
    final data = {
      'type': 'cicatriza_profile',
      'version': '1.0',
      'uid': profile.uid,
      'name': profile.displayName ?? '',
      'email': profile.email,
      'crm': profile.crmCofen ?? '',
      'specialty': profile.specialty,
      'institution': profile.institution ?? '',
    };
    return jsonEncode(data);
  }

  void _shareQrCode(BuildContext context) {
    // Copia informações do perfil para clipboard
    final text =
        '''
Perfil Profissional - Cicatriza

Nome: ${profile.displayName ?? 'Não informado'}
Email: ${profile.email}
CRM/COREN: ${profile.crmCofen ?? 'Não informado'}
Especialidade: ${profile.specialty}
Instituição: ${profile.institution ?? 'Não informada'}
''';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Informações copiadas para a área de transferência'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final qrData = _generateQrData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code do Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareQrCode(context),
            tooltip: 'Compartilhar informações',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Cabeçalho com foto e nome
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage:
                        profile.photoURL != null && profile.photoURL!.isNotEmpty
                        ? NetworkImage(profile.photoURL!)
                        : null,
                    child: profile.photoURL == null || profile.photoURL!.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 50,
                            color: colorScheme.onPrimaryContainer,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.displayName ?? 'Nome não informado',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.specialty,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // QR Code
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      QrImageView(
                        data: qrData,
                        size: 280,
                        backgroundColor: Colors.white,
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: colorScheme.primary,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: colorScheme.onSurface,
                        ),
                        embeddedImage: const AssetImage(
                          'assets/logos/logo.png',
                        ),
                        embeddedImageStyle: const QrEmbeddedImageStyle(
                          size: Size(40, 40),
                        ),
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Escaneie para visualizar o perfil profissional',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Informações do perfil
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informações Profissionais',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        context,
                        Icons.badge,
                        'CRM/COREN',
                        profile.crmCofen ?? 'Não informado',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        Icons.email,
                        'Email',
                        profile.email,
                      ),
                      if (profile.institution != null &&
                          profile.institution!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          context,
                          Icons.business,
                          'Instituição',
                          profile.institution!,
                        ),
                      ],
                      if (profile.role != null && profile.role!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          context,
                          Icons.work,
                          'Cargo',
                          profile.role!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Instruções
              Card(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Este QR Code pode ser compartilhado com outros profissionais de saúde para facilitar o networking e identificação.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _shareQrCode(context),
                      icon: const Icon(Icons.copy),
                      label: const Text('Copiar Informações'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        // TODO: Implementar salvamento do QR Code como imagem
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Funcionalidade em desenvolvimento'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Salvar QR Code'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
