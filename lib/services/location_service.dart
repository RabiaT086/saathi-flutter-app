import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationResult {
  final double latitude;
  final double longitude;
  final String readableLocation;
  final String mapsUrl;
  final bool isLive;

  const LocationResult({
    required this.latitude,
    required this.longitude,
    required this.readableLocation,
    required this.mapsUrl,
    required this.isLive,
  });
}

class LocationService {
  // Default fallback to FUUAST Main Campus, Gulshan-e-Iqbal, Karachi
  static const double defaultLat = 24.9180;
  static const double defaultLng = 67.0971;
  static const String defaultAddress = 'Federal Urdu University, Gulshan Campus, Karachi';

  /// Fetches current GPS location with permission checks
  static Future<LocationResult> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _fallbackLocation('Location service is disabled on device');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _fallbackLocation('Location permission denied by user');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _fallbackLocation('Location permissions are permanently denied');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 6),
        ),
      );

      final mapsUrl = 'https://maps.google.com/?q=${position.latitude},${position.longitude}';
      final readable = 'Lat: ${position.latitude.toStringAsFixed(5)}, Long: ${position.longitude.toStringAsFixed(5)}';

      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        readableLocation: readable,
        mapsUrl: mapsUrl,
        isLive: true,
      );
    } catch (e) {
      debugPrint('LocationService fetch error: $e');
      return _fallbackLocation(defaultAddress);
    }
  }

  static LocationResult _fallbackLocation(String note) {
    return LocationResult(
      latitude: defaultLat,
      longitude: defaultLng,
      readableLocation: defaultAddress,
      mapsUrl: 'https://maps.google.com/?q=$defaultLat,$defaultLng',
      isLive: false,
    );
  }
}
