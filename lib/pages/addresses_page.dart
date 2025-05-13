import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_app/theme/colors.dart';
import 'package:maps_app/models/models.dart';
import 'package:maps_app/providers/providers.dart';
import 'package:maps_app/widgets/widgets.dart';

/// Displays a list of saved addresses using Riverpod state management.
class AddressesPage extends ConsumerWidget {
  const AddressesPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressesProvider); // Watches list of addresses

    return Scaffold(
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text('Addresses'),
          )
        ],
        body: addresses.isEmpty 
          ? Center(child: Text('No addresses added yet')) // Empty state
          : ListView.builder(
              itemCount: addresses.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return AddressCard(address: addresses[index]); 
              },
            ),
      ),
    );
  }
}

/// A styled card displaying an individual address and actions (update/delete).
class AddressCard extends ConsumerWidget {
  final AddressModel address;

  const AddressCard({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          // Main content: details and action buttons
          children: [
            AddressDetails(address: address), 
            AddressActions(address: address), 
          ],
        ),
      ),
    );
  }
}

/// Displays the text details of an address in a formatted way.
class AddressDetails extends StatelessWidget {
  final AddressModel address;

  const AddressDetails({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          '${address.thoroughfare}, ${address.subAdministrativeArea}, ${address.administrativeArea}, ${address.country}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          'Postal code: ${address.postalCode}    Country ISO code: ${address.isoCountryCode}',
        ),
      ],
    );
  }
}

/// Contains buttons to delete or update the address.
class AddressActions extends ConsumerWidget {
  final AddressModel address;

  const AddressActions({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Delete button triggers deletion via provider
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[900],
          ),
          onPressed: () {
            ref.read(addressesProvider.notifier).deleteAddress(address.id);
          },
          child: Text('Delete'),
        ),
        // Opens bottom sheet for address update
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => UpdateAddressForm(address: address),
            );
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}
