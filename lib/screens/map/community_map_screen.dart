import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../services/location_service.dart';

class CommunityMapScreen extends StatefulWidget {
  const CommunityMapScreen({super.key});

  @override
  State<CommunityMapScreen> createState() => _CommunityMapScreenState();
}

class _CommunityMapScreenState extends State<CommunityMapScreen> {
  final MapController _mapController = MapController();
  latlng.LatLng _mapCenter = const latlng.LatLng(20.0, 0.0);
  double _zoom = 2.5;
  User? _selectedUser;
  bool _isCentering = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      if (userProvider.users.isEmpty) {
        userProvider.fetchUsers();
      }
      _centerOnUser();
    });
  }

  Future<void> _centerOnUser() async {
    setState(() => _isCentering = true);
    try {
      final details = await LocationService.getCurrentLocation();
      final target = latlng.LatLng(details.latitude, details.longitude);
      setState(() {
        _mapCenter = target;
        _zoom = 13;
      });
      _mapController.move(target, _zoom);
    } catch (_) {
      // Silent failure; UI already shows global map.
    } finally {
      if (mounted) {
        setState(() => _isCentering = false);
      }
    }
  }

  List<Marker> _buildMarkers(
    List<User> users,
    AppLocalizations strings,
  ) {
    return users
        .where((user) => user.latitude != null && user.longitude != null)
        .map((user) {
          return Marker(
            point: latlng.LatLng(user.latitude!, user.longitude!),
            width: 48,
            height: 48,
            child: GestureDetector(
              onTap: () => setState(() => _selectedUser = user),
              child: Icon(
                Icons.location_on,
                size: 40,
                color: _markerColor(user.role),
              ),
            ),
          );
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.communityMap),
        actions: [
          IconButton(
            tooltip: strings.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<UserProvider>().fetchUsers(),
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.isLoading && userProvider.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProvider.error != null && userProvider.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 36),
                  const SizedBox(height: 8),
                  Text(strings.networkError),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => userProvider.fetchUsers(),
                    child: Text(strings.retry),
                  ),
                ],
              ),
            );
          }

          final markers = _buildMarkers(userProvider.users, strings);

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _mapCenter,
                  initialZoom: _zoom,
                  onTap: (_, __) => setState(() => _selectedUser = null),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.nutri_link',
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          strings.communityMapSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          children: [
                            _LegendDot(
                              color: Colors.blue,
                              label: strings.foodProvider,
                            ),
                            _LegendDot(
                              color: Colors.green,
                              label: strings.beneficiary,
                            ),
                            _LegendDot(
                              color: Colors.orange,
                              label: strings.deliveryAgent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_selectedUser != null)
                _UserCallout(
                  user: _selectedUser!,
                  roleLabel: _roleLabel(_selectedUser!.role, strings),
                  onClose: () => setState(() => _selectedUser = null),
                ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'locate_me',
            onPressed: _isCentering ? null : _centerOnUser,
            child: _isCentering
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.small(
            heroTag: 'refresh_users',
            onPressed: () => context.read<UserProvider>().fetchUsers(),
            child: const Icon(Icons.people),
          ),
        ],
      ),
    );
  }

  Color _markerColor(UserRole role) {
    switch (role) {
      case UserRole.provider:
        return Colors.blue;
      case UserRole.deliveryAgent:
        return Colors.orange;
      case UserRole.admin:
        return Colors.purple;
      case UserRole.beneficiary:
      default:
        return Colors.green;
    }
  }

  String _roleLabel(UserRole role, AppLocalizations strings) {
    switch (role) {
      case UserRole.provider:
        return strings.foodProvider;
      case UserRole.deliveryAgent:
        return strings.deliveryAgent;
      case UserRole.admin:
        return strings.admin;
      case UserRole.beneficiary:
      default:
        return strings.beneficiary;
    }
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _UserCallout extends StatelessWidget {
  const _UserCallout({
    required this.user,
    required this.roleLabel,
    required this.onClose,
  });

  final User user;
  final String roleLabel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 24,
      child: Dismissible(
        key: ValueKey(user.id),
        direction: DismissDirection.down,
        onDismissed: (_) => onClose(),
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          user.profileImage != null ? NetworkImage(user.profileImage!) : null,
                      child: user.profileImage == null
                          ? Text(user.fullName.isNotEmpty ? user.fullName[0] : '?')
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            roleLabel,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                          if (user.address != null)
                            Text(
                              user.address!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (user.phoneNumber.isNotEmpty)
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _launchUrl(Uri.parse('tel:${user.phoneNumber}')),
                          icon: const Icon(Icons.call),
                          label: Text(AppLocalizations.of(context)!.call),
                        ),
                      ),
                    if (user.phoneNumber.isNotEmpty && user.email.isNotEmpty)
                      const SizedBox(width: 12),
                    if (user.email.isNotEmpty)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _launchUrl(Uri.parse('mailto:${user.email}')),
                          icon: const Icon(Icons.mail),
                          label: Text(AppLocalizations.of(context)!.message),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      // ignore failure silently for now
    }
  }
}
