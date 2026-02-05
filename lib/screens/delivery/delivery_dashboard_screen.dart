import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/delivery_model.dart';
import '../../providers/delivery_provider.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_card.dart';
import '../../constants/app_colors.dart';

class DeliveryDashboardScreen extends StatelessWidget {
  const DeliveryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deliveryProvider = context.watch<DeliveryProvider>();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Delivery Center',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Accept tasks, view routes, and update delivery statuses.',
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
              label: 'Active Deliveries',
              value: deliveryProvider.activeDeliveries.toString(),
              icon: Icons.delivery_dining,
              color: AppColors.deliveryColor,
            ),
            StatCard(
              label: 'Completed',
              value: deliveryProvider.deliveries
                  .where((d) => d.status == DeliveryStatus.delivered)
                  .length
                  .toString(),
              icon: Icons.check_circle,
              color: AppColors.success,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'Available Tasks',
          actionText: 'Refresh',
          onAction: () => context.read<DeliveryProvider>().fetchDeliveries(),
        ),
        const SizedBox(height: 12),
        if (deliveryProvider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (deliveryProvider.deliveries.isEmpty)
          const Text('No delivery tasks at the moment.')
        else
          ...deliveryProvider.deliveries.map(
                (delivery) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.deliveryColor.withOpacity(0.15),
                      child: Icon(
                        Icons.local_shipping,
                        color: AppColors.deliveryColor,
                      ),
                    ),
                    title: Text(delivery.foodTitle),
                    subtitle: Text(
                      '${delivery.pickupAddress} → ${delivery.dropoffAddress}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          delivery.status.name,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text('${delivery.distance?.toStringAsFixed(1) ?? '-'} km'),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
