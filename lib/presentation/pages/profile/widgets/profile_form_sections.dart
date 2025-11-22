import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../domain/entities/user_profile.dart';

class IdentificationSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController crmController;
  final TextEditingController specialtyController;
  final TextEditingController institutionController;
  final TextEditingController roleController;
  final String? photoURL;
  final Function(String)? onPhotoChanged;

  const IdentificationSection({
    super.key,
    required this.nameController,
    required this.crmController,
    required this.specialtyController,
    required this.institutionController,
    required this.roleController,
    this.photoURL,
    this.onPhotoChanged,
  });

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    // Mostrar opções de escolha
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolher foto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Câmera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null && onPhotoChanged != null) {
        onPhotoChanged!(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao selecionar imagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Identificação Profissional',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Avatar com foto de perfil
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundImage: photoURL != null && photoURL!.isNotEmpty
                    ? NetworkImage(photoURL!)
                    : null,
                child: photoURL == null || photoURL!.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  elevation: 4,
                  shape: const CircleBorder(),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 20),
                      color: Theme.of(context).colorScheme.onPrimary,
                      padding: EdgeInsets.zero,
                      onPressed: () => _pickImage(context),
                      tooltip: 'Alterar foto',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Toque no ícone da câmera para alterar a foto',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nome Completo',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: crmController,
          decoration: const InputDecoration(
            labelText: 'Registro Profissional (COREN/CRM)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: specialtyController,
          decoration: const InputDecoration(
            labelText: 'Especialidade',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: institutionController,
          decoration: const InputDecoration(
            labelText: 'Instituição / Clínica',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: roleController,
          decoration: const InputDecoration(
            labelText: 'Cargo / Função',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class ContactSection extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;

  const ContactSection({
    super.key,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contato e Comunicação',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: emailController,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'E-mail Profissional',
            border: OutlineInputBorder(),
            filled: true,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: 'Telefone (WhatsApp)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: addressController,
          decoration: const InputDecoration(
            labelText: 'Endereço Profissional',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: cityController,
          decoration: const InputDecoration(
            labelText: 'Cidade',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class PreferencesSection extends StatefulWidget {
  final UserProfile profile;
  final Function(UserProfile) onProfileChanged;

  const PreferencesSection({
    super.key,
    required this.profile,
    required this.onProfileChanged,
  });

  @override
  State<PreferencesSection> createState() => _PreferencesSectionState();
}

class _PreferencesSectionState extends State<PreferencesSection> {
  late bool _calendarSync;
  late Map<String, bool> _notifications;
  late String _language;
  late String _theme;

  @override
  void initState() {
    super.initState();
    _calendarSync = widget.profile.calendarSync;
    _notifications = Map.from(widget.profile.notifications);
    _language = widget.profile.language;
    _theme = widget.profile.theme;
  }

  void _updateProfile() {
    widget.onProfileChanged(
      widget.profile.copyWith(
        calendarSync: _calendarSync,
        notifications: _notifications,
        language: _language,
        theme: _theme,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferências de Uso',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _language,
          decoration: const InputDecoration(
            labelText: 'Idioma',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'pt-BR', child: Text('Português (Brasil)')),
            DropdownMenuItem(value: 'en-US', child: Text('English (US)')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _language = value);
              _updateProfile();
            }
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _theme,
          decoration: const InputDecoration(
            labelText: 'Tema',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'system', child: Text('Sistema')),
            DropdownMenuItem(value: 'light', child: Text('Claro')),
            DropdownMenuItem(value: 'dark', child: Text('Escuro')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _theme = value);
              _updateProfile();
            }
          },
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Sincronização com Calendário'),
          value: _calendarSync,
          onChanged: (value) {
            setState(() => _calendarSync = value);
            _updateProfile();
          },
        ),
        const Divider(),
        const Text(
          'Notificações',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        CheckboxListTile(
          title: const Text('Agendas'),
          value: _notifications['agendas'] ?? false,
          onChanged: (value) {
            setState(() => _notifications['agendas'] = value ?? false);
            _updateProfile();
          },
        ),
        CheckboxListTile(
          title: const Text('Transferências'),
          value: _notifications['transferencias'] ?? false,
          onChanged: (value) {
            setState(() => _notifications['transferencias'] = value ?? false);
            _updateProfile();
          },
        ),
        CheckboxListTile(
          title: const Text('Alertas Clínicos'),
          value: _notifications['alertas_clinicos'] ?? false,
          onChanged: (value) {
            setState(() => _notifications['alertas_clinicos'] = value ?? false);
            _updateProfile();
          },
        ),
      ],
    );
  }
}

class SecuritySection extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onLogout;

  const SecuritySection({
    super.key,
    required this.profile,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Segurança e LGPD',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          title: const Text('Data de Criação'),
          subtitle: Text(profile.createdAt.toLocal().toString()),
        ),
        ListTile(
          title: const Text('Último Acesso'),
          subtitle: Text(profile.lastAccess?.toLocal().toString() ?? 'N/A'),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Consentimento LGPD'),
          subtitle: const Text('Concordo com o processamento dos meus dados.'),
          value: profile.lgpdConsent,
          onChanged: null, // Read-only or managed elsewhere
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            // Implement export logic
          },
          icon: const Icon(Icons.download),
          label: const Text('Exportar meus dados'),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onLogout,
          icon: const Icon(Icons.logout),
          label: const Text('Sair'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
