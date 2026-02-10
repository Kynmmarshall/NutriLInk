import '../constants/app_constants.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class UserService {
  UserService();

  final ApiService _apiService = ApiService();

  bool get _useMockData =>
      AppConstants.baseUrl.contains('your-api-url') ||
      AppConstants.baseUrl.contains('localhost');

  Future<List<User>> fetchUsers() async {
    if (_useMockData) {
      return Future<List<User>>.value(_mockUsers);
    }

    try {
      final response = await _apiService.get(AppConstants.usersEndpoint);
      final data = response['users'] ?? response['data'] ?? [];

      return (data as List)
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Fall back to mock users if the API is unreachable so the map remains usable.
      return _mockUsers;
    }
  }

  List<User> get _mockUsers => [
        User(
          id: 'mock-provider',
          fullName: 'Green Basket Café',
          email: 'provider@nutrilink.dev',
          phoneNumber: '+1 555 123 4567',
          address: '123 Market Street, San Francisco',
          role: UserRole.provider,
          profileImage: 'https://i.pravatar.cc/150?img=12',
          createdAt: DateTime.now().subtract(const Duration(days: 12)),
          latitude: 37.7749,
          longitude: -122.4194,
        ),
        User(
          id: 'mock-beneficiary',
          fullName: 'Hope Community Shelter',
          email: 'beneficiary@nutrilink.dev',
          phoneNumber: '+1 555 987 0023',
          address: 'Sunset District, San Francisco',
          role: UserRole.beneficiary,
          profileImage: 'https://i.pravatar.cc/150?img=32',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          latitude: 37.781,
          longitude: -122.42,
        ),
        User(
          id: 'mock-delivery',
          fullName: 'Luis Gomez',
          email: 'delivery@nutrilink.dev',
          phoneNumber: '+1 555 765 4411',
          address: 'Mission District, San Francisco',
          role: UserRole.deliveryAgent,
          profileImage: 'https://i.pravatar.cc/150?img=7',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          latitude: 37.768,
          longitude: -122.414,
        ),
      ];
}
