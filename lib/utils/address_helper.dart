import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/global/toast.dart';
import 'package:maps_app/models/address_model.dart';
import 'package:maps_app/providers/addresses_provider.dart';


// Utility class for handling address-related operations
class AddressHelper {
  // Fetches address details from coordinates and updates the selected address provider
  Future<void> getAddressFromLatLng(LatLng latLng, WidgetRef ref) async {
    try {
      // Get a list of placemarks from the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      // If we have at least one placemark, use it
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // Create an AddressModel from the placemark data
        final tappedAddress = AddressModel(
          thoroughfare: place.thoroughfare,
          street: place.street,
          locality: place.locality,
          subAdministrativeArea: place.subAdministrativeArea,
          administrativeArea: place.administrativeArea,
          country: place.country,
          postalCode: place.postalCode,
          isoCountryCode: place.isoCountryCode,
        );

        // Update the selected address provider
        ref.read(selectedAdddressProvider.notifier).update((state) => tappedAddress);
      }
    } catch (e) {
      // Show a toast if address fetching fails
      showToast(message: 'Could not get address');
    }
  }

  // Clears the currently selected address
  Future<void> clearAddress(WidgetRef ref) async {
    ref.read(selectedAdddressProvider.notifier).update((state) => null);
  }
}
