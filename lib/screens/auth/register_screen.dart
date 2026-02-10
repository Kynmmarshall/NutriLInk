import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/location_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/role_card.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  UserRole _selectedRole = UserRole.beneficiary;
  bool _isFetchingLocation = false;
  double? _latitude;
  double? _longitude;
  String? _resolvedAddress;
  String? _locationError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_latitude == null || _longitude == null) {
      final strings = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.locationRequired)),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      role: _selectedRole,
      address: _resolvedAddress,
      latitude: _latitude,
      longitude: _longitude,
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

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();

    final themeMode = context.watch<ThemeProvider>().themeMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.register),
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
                  strings.selectRole,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final bool useTwoColumns = constraints.maxWidth >= 500;
                    final double aspectRatio = useTwoColumns ? 0.9 : 1.8;

                    return GridView.count(
                      crossAxisCount: useTwoColumns ? 2 : 1,
                      childAspectRatio: aspectRatio,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildRoleCard(
                          icon: Icons.storefront,
                          title: strings.foodProvider,
                          description: strings.providerDescription,
                          role: UserRole.provider,
                          color: Colors.blue,
                        ),
                        _buildRoleCard(
                          icon: Icons.favorite,
                          title: strings.beneficiary,
                          description: strings.beneficiaryDescription,
                          role: UserRole.beneficiary,
                          color: Colors.green,
                        ),
                        _buildRoleCard(
                          icon: Icons.delivery_dining,
                          title: strings.deliveryAgent,
                          description: strings.deliveryDescription,
                          role: UserRole.deliveryAgent,
                          color: Colors.orange,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildLocationCard(strings),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _fullNameController,
                  label: strings.fullName,
                  validator: (value) =>
                      value == null || value.isEmpty ? strings.requiredField : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  label: strings.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return strings.requiredField;
                    if (!value.contains('@')) return strings.invalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _phoneController,
                  label: strings.phoneNumber,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value == null || value.isEmpty ? strings.requiredField : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  label: strings.password,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return strings.requiredField;
                    if (value.length < 6) return strings.passwordTooShort;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: strings.confirmPassword,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return strings.requiredField;
                    if (value != _passwordController.text) return strings.passwordMismatch;
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: strings.register,
                  onPressed: _register,
                  isLoading: authProvider.isLoading,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(strings.alreadyHaveAccount),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                      child: Text(strings.login),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _captureLocation() async {
    final strings = AppLocalizations.of(context)!;
    setState(() {
      _isFetchingLocation = true;
      _locationError = null;
    });

    try {
      final details = await LocationService.getCurrentLocation();
      setState(() {
        _latitude = details.latitude;
        _longitude = details.longitude;
        _resolvedAddress = details.address;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.locationCaptureSuccess)),
      );
    } catch (e) {
      setState(() {
        _locationError = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isFetchingLocation = false);
      }
    }
  }

  Widget _buildLocationCard(AppLocalizations strings) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.locationCaptureTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              strings.locationCaptureSubtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _isFetchingLocation ? null : _captureLocation,
              icon: _isFetchingLocation
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
              label: Text(_isFetchingLocation
                  ? strings.locationCaptureFetching
                  : strings.locationCaptureButton),
            ),
            const SizedBox(height: 12),
            if (_latitude != null && _longitude != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.place, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _resolvedAddress ?? strings.location,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lat: ${_latitude!.toStringAsFixed(4)}, Lng: ${_longitude!.toStringAsFixed(4)}',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            if (_locationError != null) ...[
              Text(
                _locationError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required IconData icon,
    required String title,
    required String description,
    required UserRole role,
    required Color color,
  }) {
    return RoleCard(
      icon: icon,
      title: title,
      description: description,
      color: color,
      isSelected: _selectedRole == role,
      onTap: () => setState(() => _selectedRole = role),
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
