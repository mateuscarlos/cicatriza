import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/session_service.dart';

/// Tela de gerenciamento de sessões ativas
class ActiveSessionsPage extends StatefulWidget {
  final String userId;

  const ActiveSessionsPage({super.key, required this.userId});

  @override
  State<ActiveSessionsPage> createState() => _ActiveSessionsPageState();
}

class _ActiveSessionsPageState extends State<ActiveSessionsPage> {
  late SessionService _sessionService;
  List<ActiveSession> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  void _loadSessions() async {
    setState(() => _isLoading = true);

    // TODO: Obter SessionService via GetIt
    // _sessionService = GetIt.I<SessionService>();

    // Por enquanto, criar instância temporária
    final prefs = await SharedPreferences.getInstance();
    _sessionService = SessionService(prefs: prefs);

    final sessions = await _sessionService.getActiveSessions(widget.userId);

    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessões Ativas'),
        actions: [
          if (_sessions.length > 1)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Deslogar de todos',
              onPressed: _revokeAllOtherSessions,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sessions.isEmpty
          ? const Center(child: Text('Nenhuma sessão ativa'))
          : RefreshIndicator(
              onRefresh: () async => _loadSessions(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _sessions.length,
                itemBuilder: (context, index) {
                  final session = _sessions[index];
                  return _SessionCard(
                    session: session,
                    onRevoke: () => _revokeSession(session),
                  );
                },
              ),
            ),
    );
  }

  Future<void> _revokeSession(ActiveSession session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revogar Sessão'),
        content: Text(
          'Deseja realmente deslogar do dispositivo "${session.deviceName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Revogar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _sessionService.revokeSession(widget.userId, session.sessionId);
      _loadSessions();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sessão revogada com sucesso')),
        );
      }
    }
  }

  Future<void> _revokeAllOtherSessions() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deslogar de Todos os Dispositivos'),
        content: const Text(
          'Deseja realmente deslogar de todos os outros dispositivos? '
          'Apenas este dispositivo permanecerá conectado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Deslogar Todos'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _sessionService.revokeAllOtherSessions(widget.userId);
      _loadSessions();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todas as outras sessões foram revogadas'),
          ),
        );
      }
    }
  }
}

/// Card que exibe informações de uma sessão
class _SessionCard extends StatelessWidget {
  final ActiveSession session;
  final VoidCallback onRevoke;

  const _SessionCard({required this.session, required this.onRevoke});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: session.isCurrentDevice
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary,
          child: Icon(_getDeviceIcon(session.deviceType), color: Colors.white),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                session.deviceName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (session.isCurrentDevice)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Este dispositivo',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  'Último acesso: ${dateFormat.format(session.lastAccessAt)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.login,
                  size: 16,
                  color: theme.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  'Login em: ${dateFormat.format(session.createdAt)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: session.isCurrentDevice
            ? null
            : IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Revogar sessão',
                onPressed: onRevoke,
              ),
      ),
    );
  }

  IconData _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'android':
        return Icons.android;
      case 'ios':
        return Icons.phone_iphone;
      case 'windows':
        return Icons.desktop_windows;
      case 'macos':
        return Icons.laptop_mac;
      case 'linux':
        return Icons.computer;
      default:
        return Icons.devices;
    }
  }
}
