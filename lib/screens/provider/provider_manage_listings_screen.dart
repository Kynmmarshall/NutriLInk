import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/food_listing_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/food_provider.dart';
import '../../widgets/food_listing_card.dart';

class ProviderManageListingsScreen extends StatefulWidget {
  const ProviderManageListingsScreen({super.key});

  @override
  State<ProviderManageListingsScreen> createState() => _ProviderManageListingsScreenState();
}

class _ProviderManageListingsScreenState extends State<ProviderManageListingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  FoodStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    if (user != null) {
      await context.read<FoodProvider>().fetchMyListings(user.id);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final foodProvider = context.watch<FoodProvider>();
    final listings = _filteredListings(foodProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.manageListings)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: strings.searchListings,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<FoodStatus?>(
                  key: ValueKey(_statusFilter?.name ?? 'all'),
                  initialValue: _statusFilter,
                  decoration: InputDecoration(labelText: strings.filterByStatus),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(strings.allStatuses),
                    ),
                    ...FoodStatus.values.map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(_statusLabel(status, strings)),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => _statusFilter = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadData,
              child: foodProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : listings.isEmpty
                      ? Center(
                          child: Text(
                            strings.noListings,
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          itemCount: listings.length,
                          itemBuilder: (_, index) {
                            final listing = listings[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: FoodListingCard(
                                listing: listing,
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _showEditDialog(listing, strings);
                                    } else if (value == 'delete') {
                                      _confirmDelete(listing, strings);
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text(strings.editListing),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text(strings.delete),
                                    ),
                                  ],
                                ),
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

  List<FoodListing> _filteredListings(FoodProvider provider) {
    final query = _searchController.text.trim().toLowerCase();
    return provider.myListings.where((listing) {
      final matchesQuery = query.isEmpty ||
          listing.title.toLowerCase().contains(query) ||
          listing.description.toLowerCase().contains(query);
      final matchesStatus = _statusFilter == null || listing.status == _statusFilter;
      return matchesQuery && matchesStatus;
    }).toList();
  }

  String _statusLabel(FoodStatus status, AppLocalizations strings) {
    switch (status) {
      case FoodStatus.available:
        return strings.available;
      case FoodStatus.reserved:
        return strings.reserved;
      case FoodStatus.expired:
        return strings.expired;
      case FoodStatus.completed:
        return strings.completed;
    }
  }

  Future<void> _showEditDialog(FoodListing listing, AppLocalizations strings) async {
    final titleController = TextEditingController(text: listing.title);
    final servingsController = TextEditingController(text: listing.servings.toString());
    final descriptionController = TextEditingController(text: listing.description);
    final rootContext = context;
    final messenger = ScaffoldMessenger.of(rootContext);
    final navigator = Navigator.of(rootContext);
    final foodProvider = rootContext.read<FoodProvider>();

    await showDialog<void>(
      context: rootContext,
      builder: (_) {
        FoodStatus status = listing.status;
        return StatefulBuilder(
          builder: (dialogContext, setModalState) {
            return AlertDialog(
              title: Text(strings.editListing),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: strings.foodTitle),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: strings.description),
                      maxLines: 2,
                    ),
                    TextField(
                      controller: servingsController,
                      decoration: InputDecoration(labelText: strings.servings),
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<FoodStatus>(
                      key: ValueKey('${listing.id}-${status.name}'),
                      initialValue: status,
                      decoration: InputDecoration(labelText: strings.filterByStatus),
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() => status = value);
                        }
                      },
                      items: FoodStatus.values
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(_statusLabel(value, strings)),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(strings.cancel),
                ),
                TextButton(
                  onPressed: () async {
                    final success = await foodProvider.updateListing(
                      listing.id,
                      {
                        'title': titleController.text.trim(),
                        'description': descriptionController.text.trim(),
                        'servings': int.tryParse(servingsController.text.trim()) ?? listing.servings,
                        'status': status.name,
                      },
                    );

                    if (!mounted) return;

                    if (success) {
                      messenger.showSnackBar(
                        SnackBar(content: Text(strings.listingUpdated)),
                      );
                      navigator.pop();
                    } else {
                      final error = foodProvider.error ?? strings.errorOccurred;
                      messenger.showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                    }
                  },
                  child: Text(strings.updateListing),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(FoodListing listing, AppLocalizations strings) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(strings.deleteListingConfirm),
          content: Text(strings.deleteListingMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(strings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(strings.delete),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldDelete != true) return;

    final foodProvider = context.read<FoodProvider>();
    final success = await foodProvider.deleteListing(listing.id);
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    if (success) {
      messenger.showSnackBar(
        SnackBar(content: Text(strings.listingDeleted)),
      );
    } else {
      final error = foodProvider.error ?? strings.errorOccurred;
      messenger.showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }
}
