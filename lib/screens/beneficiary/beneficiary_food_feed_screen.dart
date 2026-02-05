import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/food_listing_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/food_provider.dart';
import '../../providers/request_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/food_listing_card.dart';

class BeneficiaryFoodFeedScreen extends StatefulWidget {
  const BeneficiaryFoodFeedScreen({super.key});

  @override
  State<BeneficiaryFoodFeedScreen> createState() => _BeneficiaryFoodFeedScreenState();
}

class _BeneficiaryFoodFeedScreenState extends State<BeneficiaryFoodFeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  FoodCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodProvider>().fetchListings();
    });
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
    final listings = _filteredListings(foodProvider.listings);

    return Scaffold(
      appBar: AppBar(title: Text(strings.beneficiaryFeed)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: strings.searchFood,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ChoiceChip(
                        label: Text(strings.allStatuses),
                        selected: _selectedCategory == null,
                        onSelected: (_) => setState(() => _selectedCategory = null),
                      ),
                      const SizedBox(width: 8),
                      ...FoodCategory.values.map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(_categoryLabel(category, strings)),
                            selected: _selectedCategory == category,
                            onSelected: (_) => setState(() => _selectedCategory = category),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => context.read<FoodProvider>().fetchListings(),
              child: foodProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : listings.isEmpty
                      ? Center(
                          child: Text(strings.noNearbyFood),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          itemCount: listings.length,
                          itemBuilder: (_, index) {
                            final listing = listings[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: FoodListingCard(
                                listing: listing,
                                trailing: ElevatedButton.icon(
                                  onPressed: () => _showRequestSheet(listing),
                                  icon: const Icon(Icons.send),
                                  label: Text(strings.requestFood),
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

  List<FoodListing> _filteredListings(List<FoodListing> listings) {
    final query = _searchController.text.trim().toLowerCase();
    return listings.where((listing) {
      final matchesQuery = query.isEmpty ||
          listing.title.toLowerCase().contains(query) ||
          listing.description.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == null || listing.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  Future<void> _showRequestSheet(FoodListing listing) async {
    final strings = AppLocalizations.of(context)!;
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    final rootContext = context;
    final navigator = Navigator.of(rootContext);
    final messenger = ScaffoldMessenger.of(rootContext);
    final requestProvider = rootContext.read<RequestProvider>();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.errorOccurred)),
      );
      return;
    }

    int servings = 1;
    final notesController = TextEditingController();

    await showModalBottomSheet<void>(
      context: rootContext,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(strings.requestFood, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(strings.requestServings),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: servings > 1
                            ? () => setSheetState(() => servings -= 1)
                            : null,
                      ),
                      Text('$servings'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: servings < listing.servings
                            ? () => setSheetState(() => servings += 1)
                            : null,
                      ),
                    ],
                  ),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(labelText: strings.requestNotes),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: strings.submitRequest,
                    onPressed: () async {
                      final success = await requestProvider.createRequest({
                        'listingId': listing.id,
                        'providerId': listing.providerId,
                        'providerName': listing.providerName,
                        'foodTitle': listing.title,
                        'beneficiaryId': user.id,
                        'beneficiaryName': user.fullName,
                        'requestedServings': servings,
                        'notes': notesController.text.trim(),
                      });

                      if (!mounted) return;

                      navigator.pop();
                      if (success) {
                        messenger.showSnackBar(
                          SnackBar(content: Text(strings.requestCreated)),
                        );
                      } else {
                        final error = requestProvider.error ?? strings.errorOccurred;
                        messenger.showSnackBar(
                          SnackBar(content: Text(error)),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String _categoryLabel(FoodCategory category, AppLocalizations strings) {
    switch (category) {
      case FoodCategory.vegetables:
        return strings.vegetables;
      case FoodCategory.fruits:
        return strings.fruits;
      case FoodCategory.grains:
        return strings.grains;
      case FoodCategory.dairy:
        return strings.dairy;
      case FoodCategory.meat:
        return strings.meat;
      case FoodCategory.prepared:
        return strings.prepared;
      case FoodCategory.other:
        return strings.other;
    }
  }
}
