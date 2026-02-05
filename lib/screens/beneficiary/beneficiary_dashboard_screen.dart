import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Find Meals Nearby',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Request and track nutritious meals from local partners.',
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
              label: 'Open Requests',
              value: requestProvider.requests
                  .where((request) => request.status != RequestStatus.completed)
                  .length
                  .toString(),
              icon: Icons.receipt_long,
              color: AppColors.accent,
            ),
            StatCard(
              label: 'Meals Delivered',
              value: requestProvider.completedRequests.toString(),
              icon: Icons.emoji_food_beverage,
              color: AppColors.success,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'Available Today',
          actionText: 'Refresh',
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
                  Text('No nearby food right now',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text('Check back soon or expand your search radius.'),
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
                          const SnackBar(content: Text('Request sent!')),
                        );
                      },
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 24),
        SectionHeader(title: 'My Requests'),
        const SizedBox(height: 12),
        if (requestProvider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (requestProvider.requests.isEmpty)
          const Text('No requests yet. Your history will appear here.')
        else
          ...requestProvider.requests.take(3).map(
                (request) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.fastfood),
                    title: Text(request.foodTitle),
                    subtitle: Text(request.status.name.toUpperCase()),
                    trailing: Text(
                      '${request.requestedServings} servings',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 60),
        CustomButton(
          text: 'View Request History',
          isOutlined: true,
          onPressed: () {},
        ),
      ],
    );
  }
}
