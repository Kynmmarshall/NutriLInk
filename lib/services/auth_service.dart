import '../models/user_model.dart';
import '../constants/app_constants.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        AppConstants.loginEndpoint,
        body: {
          'email': email,
          'password': password,
        },
        includeAuth: false,
      );

      // Save token and user data
      if (response['token'] != null) {
        await StorageService.saveToken(response['token']);
      }
      if (response['user'] != null) {
        await StorageService.saveUserData(response['user']);
      }

      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Register
  Future<Map<String, dynamic>> register({
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
      final response = await _apiService.post(
        AppConstants.registerEndpoint,
        body: {
          'fullName': fullName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'role': role.name,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
        },
        includeAuth: false,
      );

      // Save token and user data
      if (response['token'] != null) {
        await StorageService.saveToken(response['token']);
      }
      if (response['user'] != null) {
        await StorageService.saveUserData(response['user']);
      }

      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Logout
  Future<void> logout() async {
    await StorageService.clearAll();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return StorageService.getToken() != null;
  }

  // Get current user
  User? getCurrentUser() {
    final userData = StorageService.getUserData();
    if (userData != null) {
      return User.fromJson(userData);
    }
    return null;
  }

  // Update profile
  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (fullName != null) body['fullName'] = fullName;
      if (phoneNumber != null) body['phoneNumber'] = phoneNumber;
      if (address != null) body['address'] = address;
      if (latitude != null) body['latitude'] = latitude;
      if (longitude != null) body['longitude'] = longitude;

      final response = await _apiService.put(
        '${AppConstants.usersEndpoint}/$userId',
        body: body,
      );

      // Update stored user data
      if (response['user'] != null) {
        await StorageService.saveUserData(response['user']);
      }

      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Change password
  Future<Map<String, dynamic>> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post(
        '${AppConstants.usersEndpoint}/$userId/change-password',
        body: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Forgot password
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/forgot-password',
        body: {'email': email},
        includeAuth: false,
      );

      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/reset-password',
        body: {
          'token': token,
          'newPassword': newPassword,
        },
        includeAuth: false,
      );

      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
