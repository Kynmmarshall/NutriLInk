import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _adminCodeController = TextEditingController();
  String? _adminCodeError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _adminCodeController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    } else if (authProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error!)),
      );
    }
  }

  Future<void> _loginAsGuest(UserRole role) async {
    final strings = AppLocalizations.of(context)!;
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.loginAsGuest(role);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    } else {
      final errorMessage = authProvider.error ?? strings.errorOccurred;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> _unlockAdminAccess() async {
    final strings = AppLocalizations.of(context)!;
    final code = _adminCodeController.text.trim();

    if (code.isEmpty) {
      setState(() => _adminCodeError = strings.requiredField);
      return;
    }
    if (code != AppConstants.adminAccessCode) {
      setState(() => _adminCodeError = 'Invalid admin code');
      return;
    }

    setState(() => _adminCodeError = null);
    await _loginAsGuest(UserRole.admin);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.login),
        actions: [
          IconButton(
            tooltip: strings.theme,
            icon: Icon(_themeIcon(themeMode)),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
          IconButton(
            tooltip: strings.language,
            icon: const Icon(Icons.language),
            onPressed: () => context.read<LocaleProvider>().toggleLocale(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  strings.welcome,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  strings.welcomeMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _emailController,
                  label: strings.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return strings.requiredField;
                    }
                    if (!value.contains('@')) {
                      return strings.invalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  label: strings.password,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return strings.requiredField;
                    }
                    if (value.length < 6) {
                      return strings.passwordTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(strings.forgotPassword),
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: strings.login,
                  onPressed: _login,
                  isLoading: authProvider.isLoading,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(strings.dontHaveAccount),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed('/register'),
                      child: Text(strings.register),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  strings.guestLogin,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  strings.guestLoginDescription,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildGuestRoleButton(
                      icon: Icons.storefront,
                      label: strings.foodProvider,
                      role: UserRole.provider,
                      color: Colors.blue,
                      isLoading: authProvider.isLoading,
                    ),
                    _buildGuestRoleButton(
                      icon: Icons.favorite,
                      label: strings.beneficiary,
                      role: UserRole.beneficiary,
                      color: Colors.green,
                      isLoading: authProvider.isLoading,
                    ),
                    _buildGuestRoleButton(
                      icon: Icons.delivery_dining,
                      label: strings.deliveryAgent,
                      role: UserRole.deliveryAgent,
                      color: Colors.orange,
                      isLoading: authProvider.isLoading,
                    ),
                    _buildGuestRoleButton(
                      icon: Icons.admin_panel_settings,
                      label: strings.admin,
                      role: UserRole.admin,
                      color: Colors.purple,
                      isLoading: authProvider.isLoading,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Admin access override',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _adminCodeController,
                  obscureText: true,
                  onChanged: (_) {
                    if (_adminCodeError != null) {
                      setState(() => _adminCodeError = null);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Admin Access Code',
                    prefixIcon: const Icon(Icons.vpn_key),
                    errorText: _adminCodeError,
                  ),
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Unlock Admin Dashboard',
                  onPressed: authProvider.isLoading ? null : _unlockAdminAccess,
                  isLoading: authProvider.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuestRoleButton({
    required IconData icon,
    required String label,
    required UserRole role,
    required Color color,
    required bool isLoading,
  }) {
    return SizedBox(
      width: 220,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : () => _loginAsGuest(role),
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
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
}
