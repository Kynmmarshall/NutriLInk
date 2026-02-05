import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/delivery_model.dart';
import '../../providers/delivery_provider.dart';
import '../../providers/food_provider.dart';
import '../../providers/request_provider.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_card.dart';
import '../../constants/app_colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foodProvider = context.watch<FoodProvider>();
    final requestProvider = context.watch<RequestProvider>();
    final deliveryProvider = context.watch<DeliveryProvider>();

    final totalMeals = foodProvider.listings.fold<int>(
      0,
      (sum, listing) => sum + listing.servings,
    );

    final wasteReducedKg = totalMeals * 0.45; // rough estimate per meal

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Admin Control Center',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 4),
        Text(
          'Monitor platform health, growth, and social impact.',
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
              label: 'Active Listings',
              value: foodProvider.listings.length.toString(),
              icon: Icons.inventory,
              color: AppColors.primary,
            ),
            StatCard(
              label: 'Requests (24h)',
              value: requestProvider.requests.length.toString(),
              icon: Icons.request_page,
              color: AppColors.accent,
            ),
            StatCard(
              label: 'Meals Delivered',
              value: deliveryProvider.deliveries
                  .where((delivery) => delivery.status == DeliveryStatus.delivered)
                  .length
                  .toString(),
              icon: Icons.volunteer_activism,
              color: AppColors.success,
            ),
            StatCard(
              label: 'Food Waste Reduced',
              value: '${wasteReducedKg.toStringAsFixed(1)} kg',
              icon: Icons.eco,
              color: AppColors.secondary,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'Recent Requests',
          actionText: 'View All',
          onAction: () {},
        ),
        const SizedBox(height: 12),
        if (requestProvider.requests.isEmpty)
          const Text('No recent requests yet.')
        else
          ...requestProvider.requests.take(5).map(
                (request) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.15),
                      child: Icon(
                        Icons.person,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(request.foodTitle),
                    subtitle: Text(
                      '${request.beneficiaryName} • ${request.status.name.toUpperCase()}',
                    ),
                    trailing: Text('${request.requestedServings} servings'),
                  ),
                ),
              ),
        const SizedBox(height: 24),
        SectionHeader(title: 'Delivery Logistics'),
        const SizedBox(height: 12),
        if (deliveryProvider.deliveries.isEmpty)
          const Text('No deliveries to monitor right now.')
        else
          ...deliveryProvider.deliveries.take(4).map(
                (delivery) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.local_shipping),
                    title: Text(delivery.foodTitle),
                    subtitle: Text(
                      '${delivery.providerName} → ${delivery.beneficiaryName}',
                    ),
                    trailing: Text(delivery.status.name),
                  ),
                ),
              ),
      ],
    );
  }
}
