import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'models/delivery_model.dart';
import 'providers/auth_provider.dart';
import 'providers/delivery_provider.dart';
import 'providers/food_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/request_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/beneficiary/beneficiary_dashboard_screen.dart';
import 'screens/beneficiary/beneficiary_food_feed_screen.dart';
import 'screens/beneficiary/beneficiary_profile_screen.dart';
import 'screens/beneficiary/beneficiary_request_tracking_screen.dart';
import 'screens/delivery/delivery_active_deliveries_screen.dart';
import 'screens/delivery/delivery_available_tasks_screen.dart';
import 'screens/delivery/delivery_dashboard_screen.dart';
import 'screens/delivery/delivery_detail_screen.dart';
import 'screens/home/home_shell.dart';
import 'screens/provider/provider_dashboard_screen.dart';
import 'screens/provider/provider_add_listing_screen.dart';
import 'screens/provider/provider_manage_listings_screen.dart';
import 'screens/provider/provider_profile_screen.dart';
import 'theme/app_theme.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await NotificationService.instance.initialize();
  runApp(const NutriLinkApp());
}

class NutriLinkApp extends StatelessWidget {
  const NutriLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (_, themeProvider, localeProvider, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'NutriLink',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: '/',
            routes: {
              '/': (_) => const SplashScreen(),
              '/onboarding': (_) => const OnboardingScreen(),
              '/login': (_) => const LoginScreen(),
              '/register': (_) => const RegisterScreen(),
              '/home': (_) => const HomeShell(),
              '/provider-dashboard': (_) => const ProviderDashboardScreen(),
              '/provider/add-listing': (_) => const ProviderAddListingScreen(),
              '/provider/manage-listings': (_) => const ProviderManageListingsScreen(),
              '/provider/profile': (_) => const ProviderProfileScreen(),
              '/beneficiary-dashboard': (_) => const BeneficiaryDashboardScreen(),
              '/beneficiary/feed': (_) => const BeneficiaryFoodFeedScreen(),
              '/beneficiary/requests': (_) => const BeneficiaryRequestTrackingScreen(),
              '/beneficiary/profile': (_) => const BeneficiaryProfileScreen(),
              '/delivery-dashboard': (_) => const DeliveryDashboardScreen(),
              '/delivery/tasks': (_) => const DeliveryAvailableTasksScreen(),
              '/delivery/active': (_) => const DeliveryActiveDeliveriesScreen(),
              '/delivery/details': (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                if (args is Delivery) {
                  return DeliveryDetailScreen(delivery: args);
                }
                return const DeliveryDashboardScreen();
              },
              '/admin-dashboard': (_) => const AdminDashboardScreen(),
            },
          );
        },
      ),
    );
  }
}
