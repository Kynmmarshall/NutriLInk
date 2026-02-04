import 'dart:async';

import '../constants/app_constants.dart';
import '../models/food_listing_model.dart';
import 'api_service.dart';

class FoodService {
  FoodService();

  final ApiService _apiService = ApiService();

  bool get _useMockData =>
      AppConstants.baseUrl.contains('your-api-url') ||
      AppConstants.baseUrl.contains('localhost');

  Future<List<FoodListing>> fetchListings({
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    if (_useMockData) {
      return Future<List<FoodListing>>.delayed(
        const Duration(milliseconds: 400),
        () => _mockListings,
      );
    }

    final queryParams = <String, String>{};
    if (latitude != null) queryParams['latitude'] = latitude.toString();
    if (longitude != null) queryParams['longitude'] = longitude.toString();
    if (radius != null) queryParams['radius'] = radius.toString();

    final response = await _apiService.get(
      AppConstants.foodListingsEndpoint,
      queryParams: queryParams,
    );

    final listings = (response['listings'] as List)
        .map((json) => FoodListing.fromJson(json))
        .toList();
    return listings;
  }

  Future<List<FoodListing>> fetchMyListings(String providerId) async {
    if (_useMockData) {
      return Future<List<FoodListing>>.delayed(
        const Duration(milliseconds: 400),
        () => _mockListings
            .where((listing) => listing.providerId == providerId)
            .toList(),
      );
    }

    final response = await _apiService.get(
      '${AppConstants.foodListingsEndpoint}/provider/$providerId',
    );

    return (response['listings'] as List)
        .map((json) => FoodListing.fromJson(json))
        .toList();
  }

  Future<FoodListing> createListing(Map<String, dynamic> listingData) async {
    if (_useMockData) {
      return Future<FoodListing>.delayed(
        const Duration(milliseconds: 300),
        () => FoodListing(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          providerId: listingData['providerId'] ?? 'mock-provider',
          providerName: listingData['providerName'] ?? 'Mock Provider',
          title: listingData['title'] ?? 'Untitled Listing',
          description: listingData['description'] ?? 'No description',
          category: FoodCategory.values.first,
          foodType: FoodType.values.first,
          servings: listingData['servings'] ?? 0,
          quantity: listingData['quantity']?.toString(),
          expiryTime: DateTime.now().add(const Duration(hours: 6)),
          address: listingData['address'] ?? 'Unknown',
          latitude: listingData['latitude']?.toDouble() ?? 0,
          longitude: listingData['longitude']?.toDouble() ?? 0,
          images: const [],
          status: FoodStatus.available,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    final response = await _apiService.post(
      AppConstants.foodListingsEndpoint,
      body: listingData,
    );

    return FoodListing.fromJson(response['listing']);
  }

  Future<FoodListing> updateListing(
    String listingId,
    Map<String, dynamic> updates,
  ) async {
    if (_useMockData) {
      final base = _mockListings.first;
      return Future<FoodListing>.delayed(
        const Duration(milliseconds: 250),
        () => base.copyWith(
          id: listingId,
          title: updates['title'] ?? base.title,
          description: updates['description'] ?? base.description,
          servings: updates['servings'] ?? base.servings,
          updatedAt: DateTime.now(),
        ),
      );
    }

    final response = await _apiService.put(
      '${AppConstants.foodListingsEndpoint}/$listingId',
      body: updates,
    );

    return FoodListing.fromJson(response['listing']);
  }

  Future<void> deleteListing(String listingId) async {
    if (_useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return;
    }

    await _apiService.delete(
      '${AppConstants.foodListingsEndpoint}/$listingId',
    );
  }

  List<FoodListing> get _mockListings => [
        FoodListing(
          id: 'listing-1',
          providerId: 'provider-1',
          providerName: 'Green Basket Café',
          title: 'Fresh Veggie Bowls',
          description:
              'Individually packed veggie bowls prepared today. Best before tonight.',
          category: FoodCategory.vegetables,
          foodType: FoodType.fresh,
          servings: 15,
          quantity: '15 bowls',
          expiryTime: DateTime.now().add(const Duration(hours: 6)),
          address: '123 Market Street',
          latitude: 37.7749,
          longitude: -122.4194,
          images: const [],
          status: FoodStatus.available,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          updatedAt: DateTime.now(),
        ),
        FoodListing(
          id: 'listing-2',
          providerId: 'provider-2',
          providerName: 'Community Bakery',
          title: 'Whole Grain Bread Loaves',
          description: 'Freshly baked loaves available for pickup this evening.',
          category: FoodCategory.grains,
          foodType: FoodType.packaged,
          servings: 25,
          quantity: '25 loaves',
          expiryTime: DateTime.now().add(const Duration(hours: 10)),
          address: '45 Sunrise Ave',
          latitude: 37.781,
          longitude: -122.42,
          images: const [],
          status: FoodStatus.available,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          updatedAt: DateTime.now(),
        ),
      ];
}
