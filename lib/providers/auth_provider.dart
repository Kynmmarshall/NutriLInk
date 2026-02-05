import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _loadUser();
  }

  void _loadUser() {
    _currentUser = _authService.getCurrentUser();
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response['user'] != null) {
        _currentUser = User.fromJson(response['user']);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required UserRole role,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _authService.register(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        role: role,
        address: address,
        latitude: latitude,
        longitude: longitude,
      );

      if (response['user'] != null) {
        _currentUser = User.fromJson(response['user']);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginAsGuest(UserRole role) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 400));

      _currentUser = User(
        id: 'guest-${role.name}',
        fullName: '${_roleDisplayName(role)} Guest',
        email: '${role.name}@guest.nutrilink',
        phoneNumber: '0000000000',
        address: 'Guest Mode',
        role: role,
        createdAt: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _error = 'Failed to start guest session';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String _roleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.provider:
        return 'Provider';
      case UserRole.beneficiary:
        return 'Beneficiary';
      case UserRole.deliveryAgent:
        return 'Delivery Agent';
      case UserRole.admin:
        return 'Admin';
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  Future<bool> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    if (_currentUser == null) return false;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _authService.updateProfile(
        userId: _currentUser!.id,
        fullName: fullName,
        phoneNumber: phoneNumber,
        address: address,
        latitude: latitude,
        longitude: longitude,
      );

      if (response['user'] != null) {
        _currentUser = User.fromJson(response['user']);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
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
