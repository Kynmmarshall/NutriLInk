import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/food_request_model.dart';
import '../../providers/food_provider.dart';
import '../../providers/request_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/food_listing_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_card.dart';
import '../../constants/app_colors.dart';

class BeneficiaryDashboardScreen extends StatelessWidget {
  const BeneficiaryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foodProvider = context.watch<FoodProvider>();
    final requestProvider = context.watch<RequestProvider>();
    final strings = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          strings.findMealsNearby,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text(
          strings.beneficiaryDashboardSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            StatCard(
              label: strings.openRequests,
              value: requestProvider.requests
                  .where((request) => request.status != RequestStatus.completed)
                  .length
                  .toString(),
              icon: Icons.receipt_long,
              color: AppColors.accent,
            ),
            StatCard(
              label: strings.mealsDelivered,
              value: requestProvider.completedRequests.toString(),
              icon: Icons.emoji_food_beverage,
              color: AppColors.success,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: 200,
              child: CustomButton(
                text: strings.beneficiaryFeed,
                onPressed: () => Navigator.of(context).pushNamed('/beneficiary/feed'),
              ),
            ),
            SizedBox(
              width: 200,
              child: CustomButton(
                text: strings.requestTracking,
                isOutlined: true,
                onPressed: () => Navigator.of(context).pushNamed('/beneficiary/requests'),
              ),
            ),
            SizedBox(
              width: 200,
              child: CustomButton(
                text: strings.beneficiaryProfile,
                isOutlined: true,
                onPressed: () => Navigator.of(context).pushNamed('/beneficiary/profile'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: strings.availableToday,
          actionText: strings.refresh,
          onAction: () => context.read<FoodProvider>().fetchListings(),
        ),
        const SizedBox(height: 12),
        if (foodProvider.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          )
        else if (foodProvider.listings.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.waving_hand, size: 48),
                  const SizedBox(height: 12),
                  Text(strings.noNearbyFood,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    strings.expandSearchMessage,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...foodProvider.listings.take(5).map(
                (listing) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FoodListingCard(
                    listing: listing,
                    trailing: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final requestData = {
                          'listingId': listing.id,
                          'requestedServings': 2,
                        };
                        context.read<RequestProvider>().createRequest(requestData);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(strings.requestSent)),
                        );
                      },
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 24),
        SectionHeader(title: strings.myRequests),
        const SizedBox(height: 12),
        if (requestProvider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (requestProvider.requests.isEmpty)
          Text(strings.noRequestsYet)
        else
          ...requestProvider.requests.take(3).map(
                (request) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.fastfood),
                    title: Text(request.foodTitle),
                    subtitle: Text(_statusLabel(request.status, strings)),
                    trailing: Text(
                      '${request.requestedServings} ${strings.servings}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 60),
        CustomButton(
          text: strings.viewRequestHistory,
          isOutlined: true,
          onPressed: () => Navigator.of(context).pushNamed('/beneficiary/requests'),
        ),
      ],
    );
  }

  String _statusLabel(RequestStatus status, AppLocalizations strings) {
    switch (status) {
      case RequestStatus.pending:
        return strings.pending;
      case RequestStatus.approved:
        return strings.approved;
      case RequestStatus.rejected:
        return strings.rejected;
      case RequestStatus.inProgress:
        return strings.inProgress;
      case RequestStatus.completed:
        return strings.completed;
      case RequestStatus.cancelled:
        return strings.cancelled;
    }
  }
}
