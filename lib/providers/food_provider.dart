import 'package:flutter/material.dart';
import '../models/food_listing_model.dart';
import '../services/food_service.dart';

class FoodProvider with ChangeNotifier {
  final FoodService _foodService = FoodService();

  List<FoodListing> _listings = [];
  List<FoodListing> _myListings = [];
  bool _isLoading = false;
  String? _error;

  List<FoodListing> get listings => _listings;
  List<FoodListing> get myListings => _myListings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all available food listings
  Future<void> fetchListings({
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final queryParams = <String, String>{};
      if (latitude != null) queryParams['latitude'] = latitude.toString();
      if (longitude != null) queryParams['longitude'] = longitude.toString();
      if (radius != null) queryParams['radius'] = radius.toString();

      _listings = await _foodService.fetchListings(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch my listings (provider)
  Future<void> fetchMyListings(String providerId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _myListings = await _foodService.fetchMyListings(providerId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new food listing
  Future<bool> createListing(Map<String, dynamic> listingData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final newListing = await _foodService.createListing(listingData);
      _myListings.insert(0, newListing);
      _listings.insert(0, newListing);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update food listing
  Future<bool> updateListing(String listingId, Map<String, dynamic> updates) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedListing = await _foodService.updateListing(listingId, updates);

      final index = _myListings.indexWhere((l) => l.id == listingId);
      if (index != -1) {
        _myListings[index] = updatedListing;
      }

      final listingIndex = _listings.indexWhere((l) => l.id == listingId);
      if (listingIndex != -1) {
        _listings[listingIndex] = updatedListing;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete food listing
  Future<bool> deleteListing(String listingId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _foodService.deleteListing(listingId);

      _myListings.removeWhere((l) => l.id == listingId);
      _listings.removeWhere((l) => l.id == listingId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
