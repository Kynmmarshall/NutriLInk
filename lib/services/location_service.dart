import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationDetails {
  const LocationDetails({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  final double latitude;
  final double longitude;
  final String? address;
}

class LocationException implements Exception {
  LocationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class LocationService {
  const LocationService._();

  static Future<LocationDetails> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException('Location permission permanently denied.');
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 20),
    );

    String? address;
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final buffer = StringBuffer();
        if ((place.street ?? '').isNotEmpty) buffer.write(place.street);
        if ((place.subLocality ?? '').isNotEmpty) {
          if (buffer.length > 0) buffer.write(', ');
          buffer.write(place.subLocality);
        }
        if ((place.locality ?? '').isNotEmpty) {
          if (buffer.length > 0) buffer.write(', ');
          buffer.write(place.locality);
        }
        if ((place.country ?? '').isNotEmpty) {
          if (buffer.length > 0) buffer.write(', ');
          buffer.write(place.country);
        }
        address = buffer.isEmpty ? null : buffer.toString();
      }
    } catch (_) {
      address = null;
    }

    return LocationDetails(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
    );
  }
}
