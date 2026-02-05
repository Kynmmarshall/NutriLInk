import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/delivery_model.dart';
import '../../providers/delivery_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_card.dart';
import '../../constants/app_colors.dart';

class DeliveryDashboardScreen extends StatelessWidget {
  const DeliveryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deliveryProvider = context.watch<DeliveryProvider>();
    final strings = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          strings.deliveryCenter,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text(
          strings.deliveryDashboardSubtitle,
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
                label: strings.activeDeliveries,
              value: deliveryProvider.activeDeliveries.toString(),
              icon: Icons.delivery_dining,
              color: AppColors.deliveryColor,
            ),
            StatCard(
                label: strings.completed,
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
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 220,
                child: CustomButton(
                  text: strings.availableTasks,
                  onPressed: () => Navigator.of(context).pushNamed('/delivery/tasks'),
                ),
              ),
              SizedBox(
                width: 220,
                child: CustomButton(
                  text: strings.activeDeliveries,
                  isOutlined: true,
                  onPressed: () => Navigator.of(context).pushNamed('/delivery/active'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        SectionHeader(
            title: strings.availableTasks,
            actionText: strings.refresh,
          onAction: () => context.read<DeliveryProvider>().fetchDeliveries(),
        ),
        const SizedBox(height: 12),
        if (deliveryProvider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (deliveryProvider.deliveries.isEmpty)
          Text(strings.noDeliveryTasks)
        else
          ...deliveryProvider.deliveries.map(
                (delivery) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.deliveryColor.withValues(alpha: 0.15),
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
                          _statusLabel(delivery.status, strings),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text('${delivery.distance?.toStringAsFixed(1) ?? '-'} ${strings.km}'),
                      ],
                    ),
                    onTap: () => Navigator.of(context).pushNamed(
                      '/delivery/details',
                      arguments: delivery,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  String _statusLabel(DeliveryStatus status, AppLocalizations strings) {
    switch (status) {
      case DeliveryStatus.pending:
        return strings.pending;
      case DeliveryStatus.accepted:
        return strings.acceptTask;
      case DeliveryStatus.pickupInProgress:
        return strings.pickupInProgress;
      case DeliveryStatus.pickedUp:
        return strings.pickedUp;
      case DeliveryStatus.deliveryInProgress:
        return strings.deliveryInProgress;
      case DeliveryStatus.delivered:
        return strings.deliveryCompleted;
      case DeliveryStatus.cancelled:
        return strings.cancelled;
    }
  }
}
