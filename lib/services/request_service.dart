import 'dart:async';

import '../constants/app_constants.dart';
import '../models/food_request_model.dart';
import 'api_service.dart';

class RequestService {
  RequestService();

  final ApiService _apiService = ApiService();

  bool get _useMockData =>
      AppConstants.baseUrl.contains('your-api-url') ||
      AppConstants.baseUrl.contains('localhost');

  Future<List<FoodRequest>> fetchRequests({String? beneficiaryId}) async {
    if (_useMockData) {
      return Future<List<FoodRequest>>.delayed(
        const Duration(milliseconds: 350),
        () => _mockRequests
            .where(
              (request) => beneficiaryId == null
                  ? true
                  : request.beneficiaryId == beneficiaryId,
            )
            .toList(),
      );
    }

    final response = await _apiService.get(
      AppConstants.requestsEndpoint,
      queryParams:
          beneficiaryId != null ? {'beneficiaryId': beneficiaryId} : null,
    );

    return (response['requests'] as List)
        .map((json) => FoodRequest.fromJson(json))
        .toList();
  }

  Future<FoodRequest> createRequest(Map<String, dynamic> requestData) async {
    if (_useMockData) {
      return Future<FoodRequest>.delayed(
        const Duration(milliseconds: 250),
        () => _mockRequests.first.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          beneficiaryId: requestData['beneficiaryId'] ?? 'mock-beneficiary',
          beneficiaryName: requestData['beneficiaryName'] ?? 'Mock Beneficiary',
          requestedServings: requestData['requestedServings'] ?? 1,
          status: RequestStatus.pending,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    final response = await _apiService.post(
      AppConstants.requestsEndpoint,
      body: requestData,
    );

    return FoodRequest.fromJson(response['request']);
  }

  Future<FoodRequest> updateRequest(
    String requestId,
    Map<String, dynamic> updates,
  ) async {
    if (_useMockData) {
      return Future<FoodRequest>.delayed(
        const Duration(milliseconds: 200),
        () => _mockRequests.first.copyWith(
          id: requestId,
          status: updates['status'] != null
              ? RequestStatus.values.firstWhere(
                  (status) => status.name == updates['status'],
                  orElse: () => RequestStatus.pending,
                )
              : RequestStatus.pending,
          updatedAt: DateTime.now(),
          notes: updates['notes'] ?? _mockRequests.first.notes,
        ),
      );
    }

    final response = await _apiService.put(
      '${AppConstants.requestsEndpoint}/$requestId',
      body: updates,
    );

    return FoodRequest.fromJson(response['request']);
  }

  Future<void> cancelRequest(String requestId) async {
    if (_useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      return;
    }

    await _apiService.delete(
      '${AppConstants.requestsEndpoint}/$requestId',
    );
  }

  List<FoodRequest> get _mockRequests => [
        FoodRequest(
          id: 'request-1',
          listingId: 'listing-1',
          beneficiaryId: 'beneficiary-1',
          beneficiaryName: 'Maya Ali',
          providerId: 'provider-1',
          providerName: 'Green Basket Café',
          foodTitle: 'Fresh Veggie Bowls',
          requestedServings: 4,
          status: RequestStatus.approved,
          notes: 'Family of 4',
          rejectionReason: null,
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
          deliveryAgentId: 'delivery-1',
          deliveryAgentName: 'Luis Gomez',
        ),
        FoodRequest(
          id: 'request-2',
          listingId: 'listing-2',
          beneficiaryId: 'beneficiary-2',
          beneficiaryName: 'Community Shelter',
          providerId: 'provider-2',
          providerName: 'Community Bakery',
          foodTitle: 'Whole Grain Bread Loaves',
          requestedServings: 10,
          status: RequestStatus.pending,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
      ];
}
