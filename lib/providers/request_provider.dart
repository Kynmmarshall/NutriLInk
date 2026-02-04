import 'package:flutter/material.dart';

import '../models/food_request_model.dart';
import '../services/request_service.dart';

class RequestProvider with ChangeNotifier {
  final RequestService _requestService = RequestService();

  List<FoodRequest> _requests = [];
  bool _isLoading = false;
  String? _error;

  List<FoodRequest> get requests => _requests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRequests({String? beneficiaryId}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _requests = await _requestService.fetchRequests(
        beneficiaryId: beneficiaryId,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createRequest(Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final request = await _requestService.createRequest(data);
      _requests.insert(0, request);

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

  Future<bool> updateRequest(String requestId, Map<String, dynamic> updates) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updated = await _requestService.updateRequest(requestId, updates);
      final index = _requests.indexWhere((request) => request.id == requestId);
      if (index != -1) {
        _requests[index] = updated;
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

  Future<bool> cancelRequest(String requestId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _requestService.cancelRequest(requestId);
      _requests.removeWhere((request) => request.id == requestId);

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

  int get completedRequests => _requests
      .where((request) => request.status == RequestStatus.completed)
      .length;

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
