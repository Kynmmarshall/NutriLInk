import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../models/food_request_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/request_provider.dart';

class BeneficiaryRequestTrackingScreen extends StatefulWidget {
  const BeneficiaryRequestTrackingScreen({super.key});

  @override
  State<BeneficiaryRequestTrackingScreen> createState() => _BeneficiaryRequestTrackingScreenState();
}

class _BeneficiaryRequestTrackingScreenState extends State<BeneficiaryRequestTrackingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  Future<void> _loadRequests() async {
    final user = context.read<AuthProvider>().currentUser;
    await context.read<RequestProvider>().fetchRequests(beneficiaryId: user?.id);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final requestProvider = context.watch<RequestProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(strings.requestTracking)),
      body: RefreshIndicator(
        onRefresh: _loadRequests,
        child: requestProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : requestProvider.requests.isEmpty
                ? ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(child: Text(strings.noRequestsYet)),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: requestProvider.requests.length,
                    itemBuilder: (_, index) {
                      final request = requestProvider.requests[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _statusColor(request.status).withValues(alpha: 0.15),
                            child: Icon(Icons.fastfood, color: _statusColor(request.status)),
                          ),
                          title: Text(request.foodTitle),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_statusLabel(request.status, strings)),
                              Text('${strings.requestServings}: ${request.requestedServings}'),
                            ],
                          ),
                          trailing: request.status == RequestStatus.pending
                              ? TextButton(
                                  onPressed: () => _cancelRequest(request),
                                  child: Text(strings.cancelRequest),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Future<void> _cancelRequest(FoodRequest request) async {
    final strings = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.cancelRequest),
        content: Text(strings.confirmCancelRequest),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(strings.no),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(strings.yes),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirm == true) {
      final success = await context.read<RequestProvider>().cancelRequest(request.id);
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.requestCancelled)),
        );
      } else {
        final error = context.read<RequestProvider>().error ?? strings.errorOccurred;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }
  }

  Color _statusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return AppColors.statusPending;
      case RequestStatus.approved:
        return AppColors.statusApproved;
      case RequestStatus.rejected:
        return AppColors.statusRejected;
      case RequestStatus.inProgress:
        return AppColors.statusInProgress;
      case RequestStatus.completed:
        return AppColors.statusCompleted;
      case RequestStatus.cancelled:
        return AppColors.statusCancelled;
    }
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
