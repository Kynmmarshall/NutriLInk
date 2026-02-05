import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../services/storage_service.dart';
import '../../widgets/custom_button.dart';

class BeneficiaryProfileScreen extends StatefulWidget {
  const BeneficiaryProfileScreen({super.key});

  @override
  State<BeneficiaryProfileScreen> createState() => _BeneficiaryProfileScreenState();
}

class _BeneficiaryProfileScreenState extends State<BeneficiaryProfileScreen> {
  double _searchRadius = 5;
  bool _savingPreferences = false;

  @override
  void initState() {
    super.initState();
    final savedRadius = StorageService.getInt('beneficiary_radius');
    if (savedRadius != null) {
      _searchRadius = savedRadius.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final user = context.watch<AuthProvider>().currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(strings.beneficiaryProfile)),
        body: Center(child: Text(strings.errorOccurred)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(strings.beneficiaryProfile)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.fullName, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(user.email),
                    const SizedBox(height: 8),
                    Text('${strings.phoneNumber}: ${user.phoneNumber}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(strings.radiusPreference, style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _searchRadius,
              min: 1,
              max: 25,
              divisions: 24,
              label: '${_searchRadius.round()} ${strings.km}',
              onChanged: (value) => setState(() => _searchRadius = value),
            ),
            Text('${_searchRadius.round()} ${strings.km}'),
            const SizedBox(height: 24),
            CustomButton(
              text: strings.save,
              onPressed: _savingPreferences
                  ? null
                  : () {
                      _savePreferences(strings);
                    },
              isLoading: _savingPreferences,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePreferences(AppLocalizations strings) async {
    setState(() => _savingPreferences = true);
    await StorageService.setInt('beneficiary_radius', _searchRadius.round());
    if (!mounted) return;
    setState(() => _savingPreferences = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(strings.savedPreferences)),
    );
  }
}
