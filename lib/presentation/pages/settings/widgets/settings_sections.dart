import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';

class PreferencesSettingsSection extends StatefulWidget {
  final UserProfile profile;
  final Function(UserProfile) onProfileChanged;

  const PreferencesSettingsSection({
    super.key,
    required this.profile,
    required this.onProfileChanged,
  });

  @override
  State<PreferencesSettingsSection> createState() =>
      _PreferencesSettingsSectionState();
}

class _PreferencesSettingsSectionState
    extends State<PreferencesSettingsSection> {
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

  @override
  void didUpdateWidget(PreferencesSettingsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      setState(() {
        _calendarSync = widget.profile.calendarSync;
        _notifications = Map.from(widget.profile.notifications);
        _language = widget.profile.language;
        _theme = widget.profile.theme;
      });
    }
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

        // Idioma
        DropdownButtonFormField<String>(
          initialValue: _language,
          decoration: const InputDecoration(
            labelText: 'Idioma',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.language),
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

        // Tema
        DropdownButtonFormField<String>(
          initialValue: _theme,
          decoration: const InputDecoration(
            labelText: 'Tema',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.palette),
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
        const SizedBox(height: 24),

        // Sincronização
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.sync),
            title: const Text('Sincronização com Calendário'),
            subtitle: const Text(
              'Sincronizar agendamentos com o calendário do dispositivo',
            ),
            value: _calendarSync,
            onChanged: (value) {
              setState(() => _calendarSync = value);
              _updateProfile();
            },
          ),
        ),
        const SizedBox(height: 24),

        // Notificações
        const Text(
          'Notificações',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              CheckboxListTile(
                secondary: const Icon(Icons.calendar_today),
                title: const Text('Agendas'),
                subtitle: const Text('Receber notificações sobre agendamentos'),
                value: _notifications['agendas'] ?? false,
                onChanged: (value) {
                  setState(() => _notifications['agendas'] = value ?? false);
                  _updateProfile();
                },
              ),
              const Divider(height: 1),
              CheckboxListTile(
                secondary: const Icon(Icons.transfer_within_a_station),
                title: const Text('Transferências'),
                subtitle: const Text(
                  'Receber notificações sobre transferências de pacientes',
                ),
                value: _notifications['transferencias'] ?? false,
                onChanged: (value) {
                  setState(
                    () => _notifications['transferencias'] = value ?? false,
                  );
                  _updateProfile();
                },
              ),
              const Divider(height: 1),
              CheckboxListTile(
                secondary: const Icon(Icons.warning_amber),
                title: const Text('Alertas Clínicos'),
                subtitle: const Text(
                  'Receber alertas sobre condições clínicas importantes',
                ),
                value: _notifications['alertas_clinicos'] ?? false,
                onChanged: (value) {
                  setState(
                    () => _notifications['alertas_clinicos'] = value ?? false,
                  );
                  _updateProfile();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SecuritySettingsSection extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onLogout;

  const SecuritySettingsSection({
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

        // Informações da conta
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Conta criada em'),
                subtitle: Text(
                  _formatDate(profile.createdAt),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Último acesso'),
                subtitle: Text(
                  profile.lastAccess != null
                      ? _formatDate(profile.lastAccess!)
                      : 'Não disponível',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // LGPD
        const Text(
          'Privacidade e Dados',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              CheckboxListTile(
                secondary: const Icon(Icons.verified_user),
                title: const Text('Consentimento LGPD'),
                subtitle: const Text(
                  'Concordo com o processamento dos meus dados pessoais',
                ),
                value: profile.lgpdConsent,
                onChanged: null, // Read-only, gerenciado em outro fluxo
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Exportar meus dados'),
                subtitle: const Text('Solicitar cópia dos seus dados pessoais'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Implementar exportação de dados
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Funcionalidade de exportação em desenvolvimento',
                      ),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.policy),
                title: const Text('Política de Privacidade'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Abrir política de privacidade
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Abrindo política de privacidade...'),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Termos de Uso'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Abrir termos de uso
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abrindo termos de uso...')),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Ações de conta
        const Text(
          'Conta',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.lock_reset, color: Colors.orange),
                title: const Text('Alterar senha'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Implementar alteração de senha
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Funcionalidade de alteração de senha em desenvolvimento',
                      ),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('Excluir conta'),
                subtitle: const Text('Esta ação é irreversível'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showDeleteAccountDialog(context);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Botão de logout
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              _showLogoutDialog(context, onLogout);
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sair da Conta'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showLogoutDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir conta'),
        content: const Text(
          'Esta ação é irreversível e todos os seus dados serão permanentemente excluídos. Tem certeza que deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar exclusão de conta
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Funcionalidade de exclusão de conta em desenvolvimento',
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
