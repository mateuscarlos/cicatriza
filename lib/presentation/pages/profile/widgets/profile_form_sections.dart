import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
