import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'NutriLink'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Join us in reducing food waste and fighting hunger'**
  String get welcomeMessage;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Your Role'**
  String get selectRole;

  /// No description provided for @foodProvider.
  ///
  /// In en, this message translates to:
  /// **'Food Provider'**
  String get foodProvider;

  /// No description provided for @beneficiary.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary'**
  String get beneficiary;

  /// No description provided for @deliveryAgent.
  ///
  /// In en, this message translates to:
  /// **'Delivery Agent'**
  String get deliveryAgent;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @providerDescription.
  ///
  /// In en, this message translates to:
  /// **'Share surplus food'**
  String get providerDescription;

  /// No description provided for @beneficiaryDescription.
  ///
  /// In en, this message translates to:
  /// **'Access available meals'**
  String get beneficiaryDescription;

  /// No description provided for @deliveryDescription.
  ///
  /// In en, this message translates to:
  /// **'Deliver food and earn'**
  String get deliveryDescription;

  /// No description provided for @adminDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage platform'**
  String get adminDescription;

  /// No description provided for @guestLogin.
  ///
  /// In en, this message translates to:
  /// **'Guest mode'**
  String get guestLogin;

  /// No description provided for @guestLoginDescription.
  ///
  /// In en, this message translates to:
  /// **'Test each role without creating an account'**
  String get guestLoginDescription;

  /// No description provided for @providerDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Provider Dashboard'**
  String get providerDashboardTitle;

  /// No description provided for @providerDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your surplus food and impact metrics.'**
  String get providerDashboardSubtitle;

  /// No description provided for @activeListings.
  ///
  /// In en, this message translates to:
  /// **'Active Listings'**
  String get activeListings;

  /// No description provided for @manageListings.
  ///
  /// In en, this message translates to:
  /// **'Manage Listings'**
  String get manageListings;

  /// No description provided for @providerProfile.
  ///
  /// In en, this message translates to:
  /// **'Provider Profile'**
  String get providerProfile;

  /// No description provided for @recentListings.
  ///
  /// In en, this message translates to:
  /// **'Your Latest Listings'**
  String get recentListings;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noListings.
  ///
  /// In en, this message translates to:
  /// **'No listings yet'**
  String get noListings;

  /// No description provided for @shareFoodCta.
  ///
  /// In en, this message translates to:
  /// **'Start sharing surplus food to make an impact.'**
  String get shareFoodCta;

  /// No description provided for @findMealsNearby.
  ///
  /// In en, this message translates to:
  /// **'Find Meals Nearby'**
  String get findMealsNearby;

  /// No description provided for @beneficiaryDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Request and track nutritious meals from local partners.'**
  String get beneficiaryDashboardSubtitle;

  /// No description provided for @openRequests.
  ///
  /// In en, this message translates to:
  /// **'Open Requests'**
  String get openRequests;

  /// No description provided for @beneficiaryFeed.
  ///
  /// In en, this message translates to:
  /// **'Food Feed'**
  String get beneficiaryFeed;

  /// No description provided for @requestTracking.
  ///
  /// In en, this message translates to:
  /// **'Request Tracking'**
  String get requestTracking;

  /// No description provided for @beneficiaryProfile.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary Profile'**
  String get beneficiaryProfile;

  /// No description provided for @viewRequestHistory.
  ///
  /// In en, this message translates to:
  /// **'View Request History'**
  String get viewRequestHistory;

  /// No description provided for @noRequestsYet.
  ///
  /// In en, this message translates to:
  /// **'No requests yet. Your history will appear here.'**
  String get noRequestsYet;

  /// No description provided for @expandSearchMessage.
  ///
  /// In en, this message translates to:
  /// **'Check back soon or expand your search radius.'**
  String get expandSearchMessage;

  /// No description provided for @noNearbyFood.
  ///
  /// In en, this message translates to:
  /// **'No nearby food available right now.'**
  String get noNearbyFood;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @requestServings.
  ///
  /// In en, this message translates to:
  /// **'Requested servings'**
  String get requestServings;

  /// No description provided for @requestNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional notes'**
  String get requestNotes;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @requestCreated.
  ///
  /// In en, this message translates to:
  /// **'Request created successfully'**
  String get requestCreated;

  /// No description provided for @requestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get requestCancelled;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get cancelRequest;

  /// No description provided for @confirmCancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel this request?'**
  String get confirmCancelRequest;

  /// No description provided for @selectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select date & time'**
  String get selectDateTime;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @communityMap.
  ///
  /// In en, this message translates to:
  /// **'Community Map'**
  String get communityMap;

  /// No description provided for @communityMapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find nearby providers, beneficiaries, and delivery partners.'**
  String get communityMapSubtitle;

  /// No description provided for @addListing.
  ///
  /// In en, this message translates to:
  /// **'Add Listing'**
  String get addListing;

  /// No description provided for @myListings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get myListings;

  /// No description provided for @foodTitle.
  ///
  /// In en, this message translates to:
  /// **'Food Title'**
  String get foodTitle;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// No description provided for @expiryTime.
  ///
  /// In en, this message translates to:
  /// **'Expiry Time'**
  String get expiryTime;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locationCaptureTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Your Location'**
  String get locationCaptureTitle;

  /// No description provided for @locationCaptureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We use your exact location to display you on the community map.'**
  String get locationCaptureSubtitle;

  /// No description provided for @locationCaptureButton.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get locationCaptureButton;

  /// No description provided for @locationCaptureFetching.
  ///
  /// In en, this message translates to:
  /// **'Detecting your location...'**
  String get locationCaptureFetching;

  /// No description provided for @locationCaptureSuccess.
  ///
  /// In en, this message translates to:
  /// **'Location captured'**
  String get locationCaptureSuccess;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Please capture your location to continue.'**
  String get locationRequired;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @foodType.
  ///
  /// In en, this message translates to:
  /// **'Food Type'**
  String get foodType;

  /// No description provided for @searchListings.
  ///
  /// In en, this message translates to:
  /// **'Search listings...'**
  String get searchListings;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get filterByStatus;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get allStatuses;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @reserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get reserved;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @updateListing.
  ///
  /// In en, this message translates to:
  /// **'Update Listing'**
  String get updateListing;

  /// No description provided for @editListing.
  ///
  /// In en, this message translates to:
  /// **'Edit Listing'**
  String get editListing;

  /// No description provided for @deleteListingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete listing?'**
  String get deleteListingConfirm;

  /// No description provided for @deleteListingMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteListingMessage;

  /// No description provided for @availableFood.
  ///
  /// In en, this message translates to:
  /// **'Available Food'**
  String get availableFood;

  /// No description provided for @nearbyFood.
  ///
  /// In en, this message translates to:
  /// **'Nearby Food'**
  String get nearbyFood;

  /// No description provided for @searchFood.
  ///
  /// In en, this message translates to:
  /// **'Search food...'**
  String get searchFood;

  /// No description provided for @requestFood.
  ///
  /// In en, this message translates to:
  /// **'Request Food'**
  String get requestFood;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get myRequests;

  /// No description provided for @trackRequest.
  ///
  /// In en, this message translates to:
  /// **'Track Request'**
  String get trackRequest;

  /// No description provided for @availableToday.
  ///
  /// In en, this message translates to:
  /// **'Available Today'**
  String get availableToday;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @availableTasks.
  ///
  /// In en, this message translates to:
  /// **'Available Tasks'**
  String get availableTasks;

  /// No description provided for @myDeliveries.
  ///
  /// In en, this message translates to:
  /// **'My Deliveries'**
  String get myDeliveries;

  /// No description provided for @activeDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Active Deliveries'**
  String get activeDeliveries;

  /// No description provided for @pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocation;

  /// No description provided for @dropoffLocation.
  ///
  /// In en, this message translates to:
  /// **'Dropoff Location'**
  String get dropoffLocation;

  /// No description provided for @acceptTask.
  ///
  /// In en, this message translates to:
  /// **'Accept Task'**
  String get acceptTask;

  /// No description provided for @startDelivery.
  ///
  /// In en, this message translates to:
  /// **'Start Delivery'**
  String get startDelivery;

  /// No description provided for @completeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Complete Delivery'**
  String get completeDelivery;

  /// No description provided for @deliveryCenter.
  ///
  /// In en, this message translates to:
  /// **'Delivery Center'**
  String get deliveryCenter;

  /// No description provided for @deliveryDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Accept tasks, view routes, and update delivery statuses.'**
  String get deliveryDashboardSubtitle;

  /// No description provided for @availableTasksDescription.
  ///
  /// In en, this message translates to:
  /// **'Claim an available task to start delivering.'**
  String get availableTasksDescription;

  /// No description provided for @noDeliveryTasks.
  ///
  /// In en, this message translates to:
  /// **'No delivery tasks at the moment.'**
  String get noDeliveryTasks;

  /// No description provided for @assignToMe.
  ///
  /// In en, this message translates to:
  /// **'Assign to me'**
  String get assignToMe;

  /// No description provided for @taskAccepted.
  ///
  /// In en, this message translates to:
  /// **'Task accepted'**
  String get taskAccepted;

  /// No description provided for @startPickup.
  ///
  /// In en, this message translates to:
  /// **'Start Pickup'**
  String get startPickup;

  /// No description provided for @markPickedUp.
  ///
  /// In en, this message translates to:
  /// **'Pickup Done'**
  String get markPickedUp;

  /// No description provided for @startDriving.
  ///
  /// In en, this message translates to:
  /// **'Start Delivery'**
  String get startDriving;

  /// No description provided for @markDelivered.
  ///
  /// In en, this message translates to:
  /// **'Mark Delivered'**
  String get markDelivered;

  /// No description provided for @statusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Status updated'**
  String get statusUpdated;

  /// No description provided for @pickupInProgress.
  ///
  /// In en, this message translates to:
  /// **'Pickup in progress'**
  String get pickupInProgress;

  /// No description provided for @pickedUp.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get pickedUp;

  /// No description provided for @deliveryInProgress.
  ///
  /// In en, this message translates to:
  /// **'Delivery in progress'**
  String get deliveryInProgress;

  /// No description provided for @deliveryDetails.
  ///
  /// In en, this message translates to:
  /// **'Delivery Details'**
  String get deliveryDetails;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @viewRoute.
  ///
  /// In en, this message translates to:
  /// **'View Route'**
  String get viewRoute;

  /// No description provided for @contactProvider.
  ///
  /// In en, this message translates to:
  /// **'Contact Provider'**
  String get contactProvider;

  /// No description provided for @contactBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Contact Beneficiary'**
  String get contactBeneficiary;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @listingManagement.
  ///
  /// In en, this message translates to:
  /// **'Listing Management'**
  String get listingManagement;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @impactStats.
  ///
  /// In en, this message translates to:
  /// **'Impact Statistics'**
  String get impactStats;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @totalListings.
  ///
  /// In en, this message translates to:
  /// **'Total Listings'**
  String get totalListings;

  /// No description provided for @mealsDelivered.
  ///
  /// In en, this message translates to:
  /// **'Meals Delivered'**
  String get mealsDelivered;

  /// No description provided for @mealsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Meals Available'**
  String get mealsAvailable;

  /// No description provided for @foodWasteReduced.
  ///
  /// In en, this message translates to:
  /// **'Food Waste Reduced'**
  String get foodWasteReduced;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @radiusPreference.
  ///
  /// In en, this message translates to:
  /// **'Preferred search radius'**
  String get radiusPreference;

  /// No description provided for @savedPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved'**
  String get savedPreferences;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get systemTheme;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @listingCreated.
  ///
  /// In en, this message translates to:
  /// **'Listing created successfully'**
  String get listingCreated;

  /// No description provided for @listingUpdated.
  ///
  /// In en, this message translates to:
  /// **'Listing updated successfully'**
  String get listingUpdated;

  /// No description provided for @listingDeleted.
  ///
  /// In en, this message translates to:
  /// **'Listing deleted successfully'**
  String get listingDeleted;

  /// No description provided for @requestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent successfully'**
  String get requestSent;

  /// No description provided for @deliveryAccepted.
  ///
  /// In en, this message translates to:
  /// **'Delivery accepted'**
  String get deliveryAccepted;

  /// No description provided for @deliveryCompleted.
  ///
  /// In en, this message translates to:
  /// **'Delivery completed successfully'**
  String get deliveryCompleted;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get confirmDelete;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogout;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @seeLess.
  ///
  /// In en, this message translates to:
  /// **'See Less'**
  String get seeLess;

  /// No description provided for @expiresIn.
  ///
  /// In en, this message translates to:
  /// **'Expires in'**
  String get expiresIn;

  /// No description provided for @postedBy.
  ///
  /// In en, this message translates to:
  /// **'Posted by'**
  String get postedBy;

  /// No description provided for @requestedBy.
  ///
  /// In en, this message translates to:
  /// **'Requested by'**
  String get requestedBy;

  /// No description provided for @deliveredBy.
  ///
  /// In en, this message translates to:
  /// **'Delivered by'**
  String get deliveredBy;

  /// No description provided for @vegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get vegetables;

  /// No description provided for @fruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get fruits;

  /// No description provided for @grains.
  ///
  /// In en, this message translates to:
  /// **'Grains'**
  String get grains;

  /// No description provided for @dairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get dairy;

  /// No description provided for @meat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get meat;

  /// No description provided for @prepared.
  ///
  /// In en, this message translates to:
  /// **'Prepared Meal'**
  String get prepared;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @fresh.
  ///
  /// In en, this message translates to:
  /// **'Fresh'**
  String get fresh;

  /// No description provided for @cooked.
  ///
  /// In en, this message translates to:
  /// **'Cooked'**
  String get cooked;

  /// No description provided for @packaged.
  ///
  /// In en, this message translates to:
  /// **'Packaged'**
  String get packaged;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @away.
  ///
  /// In en, this message translates to:
  /// **'away'**
  String get away;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
