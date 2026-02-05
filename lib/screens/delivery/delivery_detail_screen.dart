import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../models/delivery_model.dart';

class DeliveryDetailScreen extends StatelessWidget {
  const DeliveryDetailScreen({super.key, required this.delivery});

  final Delivery delivery;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(strings.deliveryDetails)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListTile(
            leading: const Icon(Icons.flag),
            title: Text(strings.pickupLocation),
            subtitle: Text(delivery.pickupAddress),
          ),
          ListTile(
            leading: const Icon(Icons.place),
            title: Text(strings.dropoffLocation),
            subtitle: Text(delivery.dropoffAddress),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.timelapse),
              title: Text(strings.status),
              subtitle: Text(_statusLabel(delivery.status, strings)),
              trailing: Text('${delivery.servings} ${strings.servings}'),
            ),
          ),
          const SizedBox(height: 16),
          Text(strings.viewRoute, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('${delivery.distance?.toStringAsFixed(1) ?? '-'} ${strings.km} ${strings.away}'),
          const SizedBox(height: 24),
          Text(strings.contactProvider, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call),
                label: Text(strings.call),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.message),
                label: Text(strings.message),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(strings.contactBeneficiary, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call),
                label: Text(strings.call),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.message),
                label: Text(strings.message),
              ),
            ],
          ),
          if (delivery.notes != null && delivery.notes!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(strings.notes, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              color: AppColors.deliveryColor.withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(delivery.notes!),
              ),
            ),
          ],
        ],
      ),
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
