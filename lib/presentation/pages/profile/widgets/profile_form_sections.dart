import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:brasil_fields/brasil_fields.dart';

// Para busca de CEP
import 'package:dio/dio.dart';

class IdentificationSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController crmController;
  final TextEditingController specialtyController;
  final TextEditingController institutionController;
  final TextEditingController roleController;
  final String? photoURL;
  final Function(String)? onPhotoChanged;

  const IdentificationSection({
    required this.nameController, required this.crmController, required this.specialtyController, required this.institutionController, required this.roleController, super.key,
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

      if (image == null) return;

      // Crop da imagem
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Ajustar Foto',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Ajustar Foto',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );

      if (croppedFile == null) return;

      // Preview da imagem antes de confirmar
      if (context.mounted) {
        final bool? confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar foto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: Image.file(
                    File(croppedFile.path),
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Deseja usar esta foto no seu perfil?',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('CANCELAR'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('CONFIRMAR'),
              ),
            ],
          ),
        );

        if (confirmed == true && onPhotoChanged != null) {
          onPhotoChanged!(croppedFile.path);
        }
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
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor, insira seu nome completo';
            }
            if (value.trim().length < 3) {
              return 'Nome deve ter pelo menos 3 caracteres';
            }
            // Validar caracteres especiais (permitir letras, espaços e acentos)
            if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value.trim())) {
              return 'Nome não pode conter números ou caracteres especiais';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: crmController,
          decoration: const InputDecoration(
            labelText: 'Registro Profissional (CRM/COREN)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.badge),
            hintText: '123456-UF (ex: 123456-SP)',
          ),
          inputFormatters: [
            MaskTextInputFormatter(
              mask: '######-AA',
              filter: {'#': RegExp(r'[0-9]'), 'A': RegExp(r'[A-Z]')},
            ),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor, insira seu registro profissional';
            }
            if (!RegExp(r'^\d{1,6}-[A-Z]{2}$').hasMatch(value.trim())) {
              return 'Formato inválido. Use: 123456-UF';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: specialtyController,
          decoration: const InputDecoration(
            labelText: 'Especialidade',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.medical_services),
            hintText: 'Ex: Estomaterapia, Dermatologia',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor, insira sua especialidade';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: institutionController,
          decoration: const InputDecoration(
            labelText: 'Instituição / Clínica',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.business),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: roleController,
          decoration: const InputDecoration(
            labelText: 'Cargo / Função',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.work),
            hintText: 'Ex: Enfermeiro, Médico',
          ),
        ),
      ],
    );
  }
}

class ContactSection extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController cepController;
  final TextEditingController addressController;
  final Dio? dio;

  const ContactSection({
    required this.emailController, required this.phoneController, required this.cepController, required this.addressController, super.key,
    this.dio,
  });

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool _isLoadingCep = false;

  Future<void> _searchCep(String cep) async {
    // Remove caracteres não numéricos
    final cleanCep = cep.replaceAll(RegExp(r'\D'), '');

    if (cleanCep.length != 8) return;

    setState(() => _isLoadingCep = true);

    try {
      final dio = widget.dio ?? Dio();
      final response = await dio.get(
        'https://viacep.com.br/ws/$cleanCep/json/',
      );

      if (response.statusCode == 200 && mounted) {
        final data = response.data;

        if (data['erro'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('CEP não encontrado'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        // Monta o endereço completo
        final address = [
          if (data['logradouro']?.toString().isNotEmpty == true)
            data['logradouro'],
          if (data['bairro']?.toString().isNotEmpty == true) data['bairro'],
          if (data['localidade']?.toString().isNotEmpty == true)
            data['localidade'],
          if (data['uf']?.toString().isNotEmpty == true) data['uf'],
        ].join(', ');

        widget.addressController.text = address;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CEP encontrado!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CEP não encontrado'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao buscar CEP: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingCep = false);
      }
    }
  }

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
          controller: widget.emailController,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'E-mail Profissional',
            border: OutlineInputBorder(),
            filled: true,
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.phoneController,
          decoration: const InputDecoration(
            labelText: 'Telefone (WhatsApp)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
            hintText: '(11) 99999-9999',
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [TelefoneInputFormatter()],
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              // Remove caracteres não numéricos
              final cleaned = value.replaceAll(RegExp(r'\D'), '');
              if (cleaned.length < 10) {
                return 'Telefone inválido';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.cepController,
          decoration: InputDecoration(
            labelText: 'CEP',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.location_searching),
            suffixIcon: _isLoadingCep
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _searchCep(widget.cepController.text),
                    tooltip: 'Buscar CEP',
                  ),
            hintText: '12345-678',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [CepInputFormatter()],
          onChanged: (value) {
            if (value.replaceAll(RegExp(r'\D'), '').length == 8) {
              _searchCep(value);
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.addressController,
          decoration: const InputDecoration(
            labelText: 'Endereço',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
            hintText: 'Rua, Número, Bairro, Cidade - Estado',
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          validator: (value) {
            if (value != null &&
                value.trim().isNotEmpty &&
                value.trim().length < 10) {
              return 'Endereço muito curto';
            }
            return null;
          },
        ),
      ],
    );
  }
}
