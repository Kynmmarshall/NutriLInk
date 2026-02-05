import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../models/delivery_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/delivery_provider.dart';

class DeliveryAvailableTasksScreen extends StatefulWidget {
  const DeliveryAvailableTasksScreen({super.key});

  @override
  State<DeliveryAvailableTasksScreen> createState() => _DeliveryAvailableTasksScreenState();
}

class _DeliveryAvailableTasksScreenState extends State<DeliveryAvailableTasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  Future<void> _refresh() async {
    await context.read<DeliveryProvider>().fetchDeliveries();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final deliveryProvider = context.watch<DeliveryProvider>();
    final availableTasks = deliveryProvider.deliveries
        .where((delivery) => delivery.status == DeliveryStatus.pending)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(strings.availableTasks)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(strings.availableTasksDescription),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: deliveryProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : availableTasks.isEmpty
                      ? ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(32),
                              child: Center(child: Text(strings.noDeliveryTasks)),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          itemCount: availableTasks.length,
                          itemBuilder: (_, index) {
                            final task = availableTasks[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.deliveryColor.withValues(alpha: 0.15),
                                  child: const Icon(Icons.local_shipping, color: AppColors.deliveryColor),
                                ),
                                title: Text(task.foodTitle),
                                subtitle: Text('${task.pickupAddress} → ${task.dropoffAddress}'),
                                trailing: TextButton(
                                  onPressed: () => _assignTask(task),
                                  child: Text(strings.assignToMe),
                                ),
                                onTap: () => _openDetails(task),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _assignTask(Delivery delivery) async {
    final strings = AppLocalizations.of(context)!;
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.errorOccurred)),
      );
      return;
    }

    final success = await context.read<DeliveryProvider>().updateDelivery(
      delivery.id,
      {
        'status': DeliveryStatus.accepted.name,
        'deliveryAgentId': user.id,
        'deliveryAgentName': user.fullName,
      },
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.taskAccepted)),
      );
    } else {
      final error = context.read<DeliveryProvider>().error ?? strings.errorOccurred;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  void _openDetails(Delivery delivery) {
    Navigator.of(context).pushNamed('/delivery/details', arguments: delivery);
  }
}
