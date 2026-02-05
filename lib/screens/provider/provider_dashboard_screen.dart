import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/food_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/food_listing_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_card.dart';
import '../../constants/app_colors.dart';

class ProviderDashboardScreen extends StatelessWidget {
  const ProviderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foodProvider = context.watch<FoodProvider>();
    final authProvider = context.watch<AuthProvider>();
    final myListings = foodProvider.myListings;
    final strings = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () async {
        final user = authProvider.currentUser;
        if (user != null) {
          await context.read<FoodProvider>().fetchMyListings(user.id);
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            strings.providerDashboardTitle,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            strings.providerDashboardSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              StatCard(
                label: strings.activeListings,
                value: myListings.length.toString(),
                icon: Icons.inventory_2,
                color: AppColors.primary,
              ),
              StatCard(
                label: strings.mealsAvailable,
                value: myListings.fold<int>(0, (sum, listing) => sum + listing.servings).toString(),
                icon: Icons.restaurant,
                color: AppColors.secondary,
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: strings.addListing,
            icon: Icons.add_circle,
            onPressed: () => Navigator.of(context).pushNamed('/provider/add-listing'),
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: strings.manageListings,
            isOutlined: true,
            onPressed: () => Navigator.of(context).pushNamed('/provider/manage-listings'),
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: strings.providerProfile,
            isOutlined: true,
            onPressed: () => Navigator.of(context).pushNamed('/provider/profile'),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: strings.recentListings,
            actionText: strings.viewAll,
            onAction: () => Navigator.of(context).pushNamed('/provider/manage-listings'),
          ),
          const SizedBox(height: 12),
          if (foodProvider.isLoading)
            const Center(child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ))
          else if (myListings.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.sentiment_satisfied, size: 48),
                    const SizedBox(height: 12),
                    Text(strings.noListings, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      strings.shareFoodCta,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...myListings.take(3).map(
                  (listing) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FoodListingCard(
                      listing: listing,
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
