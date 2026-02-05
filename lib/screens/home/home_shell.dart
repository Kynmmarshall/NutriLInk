import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
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
    );
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
