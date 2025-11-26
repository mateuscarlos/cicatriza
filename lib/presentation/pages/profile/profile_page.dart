import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../blocs/auth_bloc.dart';
import '../../blocs/auth_event.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../widgets/skeleton_loader.dart';
import 'widgets/profile_form_sections.dart';
import 'qr_code_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(const ProfileLoadRequested()),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _crmController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _institutionController = TextEditingController();
  final _roleController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _addressController = TextEditingController();

  // Temporary profile state for preferences
  UserProfile? _currentProfile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _crmController.dispose();
    _specialtyController.dispose();
    _institutionController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cepController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateControllers(UserProfile profile) {
    _nameController.text = profile.displayName ?? '';
    _crmController.text = profile.crmCofen ?? '';
    _specialtyController.text = profile.specialty;
    _institutionController.text = profile.institution ?? '';
    _roleController.text = profile.role ?? '';
    _emailController.text = profile.email;
    _phoneController.text = profile.phone ?? '';
    _addressController.text = profile.address ?? '';
    _currentProfile = profile;
  }

  void _saveProfile(BuildContext context) {
    if (_currentProfile == null) return;

    // Validar formulário
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, corrija os erros no formulário'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final updatedProfile = _currentProfile!.copyWith(
      displayName: _nameController.text.trim(),
      crmCofen: _crmController.text.trim(),
      specialty: _specialtyController.text.trim(),
      institution: _institutionController.text.trim(),
      role: _roleController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      // Preferences are updated via callback in _currentProfile
    );

    context.read<ProfileBloc>().add(ProfileUpdateRequested(updatedProfile));
  }

  void _shareProfile() {
    if (_currentProfile == null) return;

    final name = _currentProfile!.displayName ?? 'Sem nome';
    final specialty = _currentProfile!.specialty;
    final institution = _currentProfile!.institution ?? '';
    final crm = _currentProfile!.crmCofen ?? '';

    final text =
        '''
Perfil Profissional - Cicatriza

Nome: $name
Especialidade: $specialty${institution.isNotEmpty ? '\nInstituição: $institution' : ''}${crm.isNotEmpty ? '\nCRM/COREN: $crm' : ''}

Aplicativo Cicatriza - Gestão de Feridas
    ''';

    Share.share(text, subject: 'Perfil Profissional - $name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              if (_currentProfile != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => QrCodePage(profile: _currentProfile!),
                  ),
                );
              }
            },
            tooltip: 'QR Code do Perfil',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareProfile,
            tooltip: 'Compartilhar Perfil',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveProfile(context),
            tooltip: 'Salvar Alterações',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Identificação'),
            Tab(text: 'Contato'),
          ],
        ),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _updateControllers(state.profile);
          } else if (state is ProfileUpdateSuccess) {
            // Verificar se foi atualização de foto ou dados gerais
            final message = state.profile.photoURL != _currentProfile?.photoURL
                ? 'Foto de perfil atualizada com sucesso!'
                : 'Perfil atualizado com sucesso!';

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));

            // Atualizar o AuthBloc para refletir as mudanças na HomePage
            context.read<AuthBloc>().add(const AuthProfileUpdateRequested());
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading && _currentProfile == null) {
            return const ProfileSkeleton();
          }

          if (_currentProfile == null) {
            // Initial loading or error state without data
            return const Center(child: Text('Carregando perfil...'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileBloc>().add(const ProfileLoadRequested());
              // Aguardar até o estado mudar
              await context.read<ProfileBloc>().stream.firstWhere(
                (state) => state is! ProfileLoading,
              );
            },
            child: Form(
              key: _formKey,
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: IdentificationSection(
                      nameController: _nameController,
                      crmController: _crmController,
                      specialtyController: _specialtyController,
                      institutionController: _institutionController,
                      roleController: _roleController,
                      photoURL: _currentProfile!.photoURL,
                      onPhotoChanged: (photoPath) {
                        // Disparar evento para fazer upload da foto
                        context.read<ProfileBloc>().add(
                          ProfileImageUploadRequested(photoPath),
                        );
                      },
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ContactSection(
                      emailController: _emailController,
                      phoneController: _phoneController,
                      cepController: _cepController,
                      addressController: _addressController,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
