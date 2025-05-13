/// Represents addresses with various location details.
class AddressModel {
  final int? id; 
  final String? thoroughfare; 
  final String? street; 
  final String? locality; 
  final String? subAdministrativeArea; 
  final String? administrativeArea; 
  final String? country; 
  final String? postalCode; 
  final String? isoCountryCode; 

  AddressModel({
    this.id,
    this.thoroughfare,
    this.street,
    this.locality,
    this.subAdministrativeArea,
    this.administrativeArea,
    this.country,
    this.postalCode,
    this.isoCountryCode,
  });

  /// Useful for debugging - prints all address fields.
  @override
  String toString() {
    return 'AddressModel(id: $id, thoroughfare: $thoroughfare, street: $street, locality: $locality, subAdministrativeArea: $subAdministrativeArea, administrativeArea: $administrativeArea, country: $country, postalCode: $postalCode, isoCountryCode: $isoCountryCode)';
  }

  /// Converts AddressModel to a Map for database insertion.
  Map<String, dynamic> toMap() => {
    'id': id,
    'thoroughfare': thoroughfare,
    'street': street,
    'locality': locality,
    'subAdministrativeArea': subAdministrativeArea,
    'administrativeArea': administrativeArea,
    'country': country,
    'postalCode': postalCode,
    'isoCountryCode': isoCountryCode,
  };

  /// Creates AddressModel from a Map retrieved from the database.
  factory AddressModel.fromMap(Map<String, dynamic> map) => AddressModel(
    id: map['id'] as int?,
    thoroughfare: map['thoroughfare'] as String?,
    street: map['street'] as String?,
    locality: map['locality'] as String?,
    subAdministrativeArea: map['subAdministrativeArea'] as String?,
    administrativeArea: map['administrativeArea'] as String?,
    country: map['country'] as String?,
    postalCode: map['postalCode'] as String?,
    isoCountryCode: map['isoCountryCode'] as String?,
  );
}
