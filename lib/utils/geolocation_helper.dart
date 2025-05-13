import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/global/toast.dart';

/// A utility class that provides helper methods for working with maps and location.
class GeolocationHelper {
  /// Retrieves the user's current location as a [LatLng] object.
  ///
  /// This method checks if location services are enabled and requests
  /// location permissions if necessary. If the location is successfully
  /// retrieved, it returns the coordinates as [LatLng]. Otherwise, it returns null.
  static Future<LatLng?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Prompt the user to enable location settings
        await Geolocator.openLocationSettings();
        return null;
      }

      // Check and request location permission if not granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return null;
        }
      }

      // Get the current position with high accuracy
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      // Return the position as LatLng
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      // Show toast if there's an error
      showToast(message: 'Error getting location');
      return null;
    }
  }

  /// Animates the camera to the given position.
  ///
  /// The camera will smoothly zoom into the specified location with a default zoom level of 15.
  static void animateToPosition(GoogleMapController controller, LatLng position) {
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(position, 15),
    );
  }
}