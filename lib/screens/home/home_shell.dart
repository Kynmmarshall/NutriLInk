import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/delivery_provider.dart';
import '../../providers/food_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/request_provider.dart';
import '../../providers/theme_provider.dart';
import '../admin/admin_dashboard_screen.dart';
import '../beneficiary/beneficiary_dashboard_screen.dart';
import '../delivery/delivery_dashboard_screen.dart';
import '../provider/provider_dashboard_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final TextEditingController _adminCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final foodProvider = context.read<FoodProvider>();
      final requestProvider = context.read<RequestProvider>();
      final deliveryProvider = context.read<DeliveryProvider>();
      
      foodProvider.fetchListings();
      if (authProvider.currentUser != null) {
        final user = authProvider.currentUser!;
        if (user.role == UserRole.provider) {
          foodProvider.fetchMyListings(user.id);
        }
        if (user.role == UserRole.beneficiary) {
          requestProvider.fetchRequests(beneficiaryId: user.id);
        } else {
          requestProvider.fetchRequests();
        }
        if (user.role == UserRole.deliveryAgent) {
          deliveryProvider.fetchDeliveries(deliveryAgentId: user.id);
        } else {
          deliveryProvider.fetchDeliveries();
        }
      }
    });
  }

  @override
  void dispose() {
    _adminCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
            },
            child: Text(strings.login),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: _handleBackNavigation,
      child: Scaffold(
        appBar: AppBar(
        title: Text('${strings.dashboard} · ${user.fullName}'),
        actions: [
          IconButton(
            tooltip: strings.theme,
            icon: Icon(_themeIcon(context.watch<ThemeProvider>().themeMode)),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
          IconButton(
            tooltip: strings.language,
            icon: const Icon(Icons.language),
            onPressed: () => context.read<LocaleProvider>().toggleLocale(),
          ),
          IconButton(
            tooltip: strings.communityMap,
            icon: const Icon(Icons.map),
            onPressed: () => Navigator.of(context).pushNamed('/community-map'),
          ),
          IconButton(
            tooltip: strings.admin,
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: _showAdminAccessDialog,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthProvider>().logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Text(strings.logout),
              ),
            ],
          ),
        ],
      ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _buildDashboard(user.role),
        ),
      ),
    );
  }

  Future<bool> _handleBackNavigation() async {
    await context.read<AuthProvider>().logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    }
    return false;
  }

  Future<void> _showAdminAccessDialog() async {
    final strings = AppLocalizations.of(context)!;
    final codeController = _adminCodeController..clear();
    String? errorMessage;

    final bool? unlocked = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.admin_panel_settings),
                  const SizedBox(width: 8),
                  Text(strings.admin),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter the admin access code to continue.'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: codeController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Access Code',
                      prefixIcon: Icon(Icons.vpn_key),
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(strings.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    if (codeController.text.trim() == AppConstants.adminAccessCode) {
                      Navigator.of(dialogContext).pop(true);
                    } else {
                      setState(() => errorMessage = 'Invalid admin code');
                    }
                  },
                  child: const Text('Verify'),
                ),
              ],
            );
          },
        );
      },
    );

    if (unlocked == true && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      );
    }
  }

  IconData _themeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      default:
        return Icons.brightness_4;
    }
  }

  Widget _buildDashboard(UserRole role) {
    switch (role) {
      case UserRole.provider:
        return const ProviderDashboardScreen();
      case UserRole.deliveryAgent:
        return const DeliveryDashboardScreen();
      case UserRole.admin:
        return const AdminDashboardScreen();
      default:
        return const BeneficiaryDashboardScreen();
    }
  }
}
