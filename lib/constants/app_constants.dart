class AppConstants {
  // API Base URL - Update this with your actual backend URL
  static const String baseUrl = 'http://your-api-url.com/api';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String foodListingsEndpoint = '/food-listings';
  static const String requestsEndpoint = '/requests';
  static const String deliveriesEndpoint = '/deliveries';
  static const String usersEndpoint = '/users';
  
  // App Settings
  static const String appName = 'NutriLink';
  static const int requestTimeout = 30; // seconds
  static const double defaultRadius = 5.0; // km for nearby search
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';
  
  // Pagination
  static const int pageSize = 20;
  
  // Image
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
}
