import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/food_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/stat_card.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({super.key});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  bool _updatingProfile = false;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final foodProvider = context.watch<FoodProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(strings.providerProfile)),
        body: Center(child: Text(strings.errorOccurred)),
      );
    }

    final totalListings = foodProvider.myListings.length;
    final totalMeals = foodProvider.myListings.fold<int>(
      0,
      (sum, listing) => sum + listing.servings,
    );

    return Scaffold(
      appBar: AppBar(title: Text(strings.providerProfile)),
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
                    Text(
                      user.fullName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(user.email),
                    const SizedBox(height: 8),
                    Text('${strings.phoneNumber}: ${user.phoneNumber}'),
                    if (user.address != null && user.address!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('${strings.address}: ${user.address}'),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(strings.impactStats, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                StatCard(
                  label: strings.totalListings,
                  value: totalListings.toString(),
                  icon: Icons.inventory,
                  color: AppColors.providerColor,
                ),
                StatCard(
                  label: strings.mealsAvailable,
                  value: totalMeals.toString(),
                  icon: Icons.restaurant,
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(strings.contactInformation, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: Text(strings.phoneNumber),
                subtitle: Text(user.phoneNumber.isEmpty ? strings.noDataAvailable : user.phoneNumber),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(strings.address),
                subtitle: Text(user.address?.isNotEmpty == true ? user.address! : strings.noDataAvailable),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: strings.editProfile,
              onPressed: _updatingProfile
                  ? null
                  : () {
                      _showEditContactDialog(user, strings);
                    },
              isLoading: _updatingProfile,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditContactDialog(User user, AppLocalizations strings) async {
    final phoneController = TextEditingController(text: user.phoneNumber);
    final addressController = TextEditingController(text: user.address ?? '');
    final rootContext = context;
    final navigator = Navigator.of(rootContext);
    final messenger = ScaffoldMessenger.of(rootContext);
    final authProvider = rootContext.read<AuthProvider>();

    await showDialog<void>(
      context: rootContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(strings.editProfile),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: strings.phoneNumber),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: strings.address),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(strings.cancel),
            ),
            TextButton(
              onPressed: () async {
                setState(() => _updatingProfile = true);
                final success = await authProvider.updateProfile(
                  phoneNumber: phoneController.text.trim(),
                  address: addressController.text.trim(),
                );

                if (!mounted) return;

                setState(() => _updatingProfile = false);
                navigator.pop();

                if (success) {
                  messenger.showSnackBar(
                    SnackBar(content: Text(strings.profileUpdated)),
                  );
                } else {
                  final error = authProvider.error ?? strings.errorOccurred;
                  messenger.showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                }
              },
              child: Text(strings.save),
            ),
          ],
        );
      },
    );
  }
}
