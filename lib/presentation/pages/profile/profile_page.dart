import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../blocs/auth_bloc.dart';
import '../../blocs/auth_event.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import 'widgets/profile_form_sections.dart';

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

  // Controllers
  final _nameController = TextEditingController();
  final _crmController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _institutionController = TextEditingController();
  final _roleController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  // Temporary profile state for preferences
  UserProfile? _currentProfile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
    _addressController.dispose();
    _cityController.dispose();
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
    _cityController.text = profile.city ?? '';
    _currentProfile = profile;
  }

  void _saveProfile(BuildContext context) {
    if (_currentProfile == null) return;

    final updatedProfile = _currentProfile!.copyWith(
      displayName: _nameController.text,
      crmCofen: _crmController.text,
      specialty: _specialtyController.text,
      institution: _institutionController.text,
      role: _roleController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      city: _cityController.text,
      // Preferences are updated via callback in _currentProfile
    );

    context.read<ProfileBloc>().add(ProfileUpdateRequested(updatedProfile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveProfile(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Identificação'),
            Tab(text: 'Contato'),
            Tab(text: 'Preferências'),
            Tab(text: 'Segurança'),
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
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_currentProfile == null) {
            // Initial loading or error state without data
            return const Center(child: Text('Carregando perfil...'));
          }

          return TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
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
                child: ContactSection(
                  emailController: _emailController,
                  phoneController: _phoneController,
                  addressController: _addressController,
                  cityController: _cityController,
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: PreferencesSection(
                  profile: _currentProfile!,
                  onProfileChanged: (updated) {
                    setState(() {
                      _currentProfile = updated;
                    });
                  },
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SecuritySection(
                  profile: _currentProfile!,
                  onLogout: () {
                    context.read<AuthBloc>().add(const AuthSignOutRequested());
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
