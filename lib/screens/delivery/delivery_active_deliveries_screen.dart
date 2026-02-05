import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../models/delivery_model.dart';
import '../../providers/delivery_provider.dart';

class DeliveryActiveDeliveriesScreen extends StatelessWidget {
  const DeliveryActiveDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final deliveryProvider = context.watch<DeliveryProvider>();
    final activeDeliveries = deliveryProvider.deliveries.where(_isActive).toList();

    return Scaffold(
      appBar: AppBar(title: Text(strings.activeDeliveries)),
      body: deliveryProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : activeDeliveries.isEmpty
              ? Center(child: Text(strings.noDeliveryTasks))
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: activeDeliveries.length,
                  itemBuilder: (_, index) {
                    final delivery = activeDeliveries[index];
                    final nextStatus = _nextStatus(delivery.status);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.deliveryColor.withValues(alpha: 0.15),
                          child: Icon(Icons.route, color: AppColors.deliveryColor),
                        ),
                        title: Text(delivery.foodTitle),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${delivery.pickupAddress} → ${delivery.dropoffAddress}'),
                            const SizedBox(height: 4),
                            Text(_statusLabel(delivery.status, strings)),
                          ],
                        ),
                        trailing: nextStatus == null
                            ? null
                            : ElevatedButton(
                                onPressed: () => _advanceStatus(context, delivery, nextStatus),
                                child: Text(_statusCta(delivery.status, strings)),
                              ),
                        onTap: () => Navigator.of(context).pushNamed(
                          '/delivery/details',
                          arguments: delivery,
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  bool _isActive(Delivery delivery) {
    return delivery.status == DeliveryStatus.accepted ||
        delivery.status == DeliveryStatus.pickupInProgress ||
        delivery.status == DeliveryStatus.pickedUp ||
        delivery.status == DeliveryStatus.deliveryInProgress;
  }

  DeliveryStatus? _nextStatus(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.accepted:
        return DeliveryStatus.pickupInProgress;
      case DeliveryStatus.pickupInProgress:
        return DeliveryStatus.pickedUp;
      case DeliveryStatus.pickedUp:
        return DeliveryStatus.deliveryInProgress;
      case DeliveryStatus.deliveryInProgress:
        return DeliveryStatus.delivered;
      default:
        return null;
    }
  }

  String _statusCta(DeliveryStatus status, AppLocalizations strings) {
    switch (status) {
      case DeliveryStatus.accepted:
        return strings.startPickup;
      case DeliveryStatus.pickupInProgress:
        return strings.markPickedUp;
      case DeliveryStatus.pickedUp:
        return strings.startDriving;
      case DeliveryStatus.deliveryInProgress:
        return strings.markDelivered;
      default:
        return strings.update;
    }
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

  Future<void> _advanceStatus(
    BuildContext context,
    Delivery delivery,
    DeliveryStatus nextStatus,
  ) async {
    final strings = AppLocalizations.of(context)!;
    final success = await context.read<DeliveryProvider>().updateDelivery(
          delivery.id,
          {'status': nextStatus.name},
        );

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.statusUpdated)),
      );
    } else {
      final error = context.read<DeliveryProvider>().error ?? strings.errorOccurred;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }
}
