// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maps_app/models/address_model.dart';
import 'package:maps_app/providers/providers.dart';

class UpdateAddressForm extends ConsumerStatefulWidget {
  final AddressModel? address; // Address to be updated, passed to this widget
  const UpdateAddressForm({
    super.key,
    this.address, // Optional address passed to the form
  });

  @override
  UpdateAddressFormState createState() => UpdateAddressFormState();
}

class UpdateAddressFormState extends ConsumerState<UpdateAddressForm> {
  // Controllers for each text field
  late final TextEditingController thoroughfareController;
  late final TextEditingController localityController;
  late final TextEditingController subAdministrativeAreaController;
  late final TextEditingController administrativeAreaController;
  late final TextEditingController countryController;
  late final TextEditingController postalCodeController;
  late final TextEditingController isoCodeController;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing address values if available
    thoroughfareController = TextEditingController(text: widget.address?.thoroughfare);
    localityController = TextEditingController(text: widget.address?.locality);
    subAdministrativeAreaController = TextEditingController(text: widget.address?.subAdministrativeArea);
    administrativeAreaController = TextEditingController(text: widget.address?.administrativeArea);
    countryController = TextEditingController(text: widget.address?.country);
    postalCodeController = TextEditingController(text: widget.address?.postalCode);
    isoCodeController = TextEditingController(text: widget.address?.isoCountryCode);
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    thoroughfareController.dispose();
    localityController.dispose();
    subAdministrativeAreaController.dispose();
    administrativeAreaController.dispose();
    countryController.dispose();
    postalCodeController.dispose();
    isoCodeController.dispose();
    super.dispose();
  }

  // Method to handle form submission
  void _submit() {
    if (_formKey.currentState!.validate()) { // Validate the form
      // Create an updated AddressModel with the values from the controllers
      final updateAddress = AddressModel(
        id: widget.address?.id, // Keep the existing address id
        thoroughfare: thoroughfareController.text,
        locality: localityController.text,
        subAdministrativeArea: subAdministrativeAreaController.text,
        administrativeArea: administrativeAreaController.text,
        country: countryController.text,
        postalCode: postalCodeController.text,
        isoCountryCode: isoCodeController.text,
      );

      // Use the Riverpod provider to update the address
      ref.read(addressesProvider.notifier).updateAddress(updateAddress);

      // Close the form and return to the previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.7),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Form(
            key: _formKey, // Assign the form key for validation
            child: Column(
              spacing: 20, 
              children: [
                // Text form fields for each part of the address
                TextFormField(
                  controller: thoroughfareController,
                  decoration: InputDecoration(labelText: 'Street'),
                ),
                TextFormField(
                  controller: subAdministrativeAreaController,
                  decoration: InputDecoration(labelText: 'City'),
                ),
                TextFormField(
                  controller: administrativeAreaController,
                  decoration: InputDecoration(labelText: 'State/Province'),
                ),
                TextFormField(
                  controller: countryController,
                  decoration: InputDecoration(labelText: 'Country'),
                ),
                TextFormField(
                  controller: postalCodeController,
                  decoration: InputDecoration(labelText: 'Postal Code'),
                ),
                TextFormField(
                  controller: isoCodeController,
                  decoration: InputDecoration(labelText: 'Country ISO Code'),
                ),
                // Save button to submit the form
                ElevatedButton(
                  onPressed: _submit, 
                  child: const Text('Save'),
                ),
                const SizedBox(height: 1), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}
