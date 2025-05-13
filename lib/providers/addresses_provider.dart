import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_app/db/addresses_db.dart';
import 'package:maps_app/global/toast.dart';

import 'package:maps_app/models/address_model.dart';
import 'package:maps_app/theme/colors.dart';

/// Holds the currently selected address (e.g., for editing or displaying).
final selectedAdddressProvider = StateProvider<AddressModel?>((ref) => null);

/// Manages the list of addresses and interacts with the local database.
class AddressNotifier extends StateNotifier<List<AddressModel>> {
  AddressNotifier(this.ref) : super([]) {
    getAddresses(); // Load addresses on initialization
  }

  final Ref ref;

  /// Fetch all saved addresses from the database and update state.
  Future<void> getAddresses() async {
    final addresses = await AddressesDatabase().getAddresses();
    state = addresses;
  }

  /// Add a new address to the database and refresh state.
  Future<void> addAddress(AddressModel address) async {
    try {
      await AddressesDatabase().insertAddress(address);
      await getAddresses();
      showToast(message: 'Address added successfully', backgroundColor: AppColors.greenAccentColor);
    } catch (e) {
      showToast(message: 'Failed to add address', backgroundColor: AppColors.redAccentColor);
    }
  }

  /// Update an existing address and refresh state.
  Future<void> updateAddress(AddressModel address) async {
    try {
      await AddressesDatabase().updateAddress(address);
      await getAddresses();
      showToast(message: 'Address updated successfully', backgroundColor: AppColors.infoColor);
    } catch (e) {
      showToast(message: 'Failed to update address', backgroundColor: AppColors.redAccentColor);
    }
  }

  /// Delete an address by ID and refresh state.
  Future<void> deleteAddress(int? id) async {
    try {
      await AddressesDatabase().deleteAddress(id!);
      await getAddresses();
      showToast(message: 'Address deleted successfully', backgroundColor: AppColors.redAccentColor);
    } catch (e) {
      showToast(message: 'Failed to delete address', backgroundColor: AppColors.redAccentColor);
    }
  }
}

/// Provides the address list managed by [AddressNotifier].
final addressesProvider = StateNotifierProvider<AddressNotifier, List<AddressModel>>((ref) {
  return AddressNotifier(ref);
});
