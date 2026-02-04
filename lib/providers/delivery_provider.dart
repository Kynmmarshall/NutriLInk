import 'package:flutter/material.dart';

import '../models/delivery_model.dart';
import '../services/delivery_service.dart';

class DeliveryProvider with ChangeNotifier {
  final DeliveryService _deliveryService = DeliveryService();

  List<Delivery> _deliveries = [];
  bool _isLoading = false;
  String? _error;

  List<Delivery> get deliveries => _deliveries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDeliveries({String? deliveryAgentId}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _deliveries = await _deliveryService.fetchDeliveries(
        deliveryAgentId: deliveryAgentId,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateDelivery(
    String deliveryId,
    Map<String, dynamic> updates,
  ) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updated = await _deliveryService.updateDelivery(
        deliveryId,
        updates,
      );

      final index = _deliveries.indexWhere((delivery) => delivery.id == deliveryId);
      if (index != -1) {
        _deliveries[index] = updated;
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

  Future<bool> assignDelivery(Map<String, dynamic> assignmentData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final delivery = await _deliveryService.assignDelivery(assignmentData);
      _deliveries.insert(0, delivery);

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

  int get activeDeliveries => _deliveries
      .where((delivery) =>
          delivery.status == DeliveryStatus.deliveryInProgress ||
          delivery.status == DeliveryStatus.accepted)
      .length;

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
