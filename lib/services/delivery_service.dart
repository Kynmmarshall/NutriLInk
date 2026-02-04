import 'dart:async';

import '../constants/app_constants.dart';
import '../models/delivery_model.dart';
import 'api_service.dart';

class DeliveryService {
  DeliveryService();

  final ApiService _apiService = ApiService();

  bool get _useMockData =>
      AppConstants.baseUrl.contains('your-api-url') ||
      AppConstants.baseUrl.contains('localhost');

  Future<List<Delivery>> fetchDeliveries({String? deliveryAgentId}) async {
    if (_useMockData) {
      return Future<List<Delivery>>.delayed(
        const Duration(milliseconds: 300),
        () => _mockDeliveries
            .where(
              (delivery) => deliveryAgentId == null
                  ? true
                  : delivery.deliveryAgentId == deliveryAgentId,
            )
            .toList(),
      );
    }

    final response = await _apiService.get(
      AppConstants.deliveriesEndpoint,
      queryParams: deliveryAgentId != null
          ? {'deliveryAgentId': deliveryAgentId}
          : null,
    );

    return (response['deliveries'] as List)
        .map((json) => Delivery.fromJson(json))
        .toList();
  }

  Future<Delivery> updateDelivery(
    String deliveryId,
    Map<String, dynamic> updates,
  ) async {
    if (_useMockData) {
      final base = _mockDeliveries.first;
      return Future<Delivery>.delayed(
        const Duration(milliseconds: 200),
        () => base.copyWith(
          id: deliveryId,
          status: updates['status'] != null
              ? DeliveryStatus.values.firstWhere(
                  (status) => status.name == updates['status'],
                  orElse: () => base.status,
                )
              : base.status,
          notes: updates['notes'] ?? base.notes,
          updatedAt: DateTime.now(),
        ),
      );
    }

    final response = await _apiService.put(
      '${AppConstants.deliveriesEndpoint}/$deliveryId',
      body: updates,
    );

    return Delivery.fromJson(response['delivery']);
  }

  Future<Delivery> assignDelivery(Map<String, dynamic> assignmentData) async {
    if (_useMockData) {
      return Future<Delivery>.delayed(
        const Duration(milliseconds: 250),
        () => _mockDeliveries.first.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          deliveryAgentId:
              assignmentData['deliveryAgentId'] ?? 'mock-delivery-agent',
          deliveryAgentName:
              assignmentData['deliveryAgentName'] ?? 'Mock Delivery Agent',
          status: DeliveryStatus.accepted,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    final response = await _apiService.post(
      AppConstants.deliveriesEndpoint,
      body: assignmentData,
    );

    return Delivery.fromJson(response['delivery']);
  }

  List<Delivery> get _mockDeliveries => [
        Delivery(
          id: 'delivery-1',
          requestId: 'request-1',
          listingId: 'listing-1',
          providerId: 'provider-1',
          providerName: 'Green Basket Café',
          beneficiaryId: 'beneficiary-1',
          beneficiaryName: 'Maya Ali',
          deliveryAgentId: 'delivery-1',
          deliveryAgentName: 'Luis Gomez',
          foodTitle: 'Fresh Veggie Bowls',
          servings: 4,
          pickupAddress: '123 Market Street',
          pickupLatitude: 37.7749,
          pickupLongitude: -122.4194,
          dropoffAddress: 'Sunset Shelter',
          dropoffLatitude: 37.78,
          dropoffLongitude: -122.42,
          status: DeliveryStatus.deliveryInProgress,
          pickupTime: DateTime.now().subtract(const Duration(minutes: 30)),
          deliveryTime: null,
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
          notes: 'Call upon arrival',
          deliveryProof: null,
          distance: 4.2,
        ),
        Delivery(
          id: 'delivery-2',
          requestId: 'request-2',
          listingId: 'listing-2',
          providerId: 'provider-2',
          providerName: 'Community Bakery',
          beneficiaryId: 'beneficiary-2',
          beneficiaryName: 'Community Shelter',
          deliveryAgentId: null,
          deliveryAgentName: null,
          foodTitle: 'Whole Grain Bread Loaves',
          servings: 10,
          pickupAddress: '45 Sunrise Ave',
          pickupLatitude: 37.781,
          pickupLongitude: -122.42,
          dropoffAddress: 'Hope Community Center',
          dropoffLatitude: 37.79,
          dropoffLongitude: -122.41,
          status: DeliveryStatus.pending,
          pickupTime: null,
          deliveryTime: null,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
          notes: null,
          deliveryProof: null,
          distance: 6.1,
        ),
      ];
}
