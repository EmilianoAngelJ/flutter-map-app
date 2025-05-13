import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Represents a location suggestion with a type and optional description.
class SuggestionModel {
  final LatLng location; // Coordinates of the suggestion
  final SuggestionType type; // Type of location (e.g., country, city)
  final String? description; // Optional description (e.g., address string)

  SuggestionModel({
    required this.location, 
    required this.type,
    required this.description,
  });

  /// Returns a zoom level based on the suggestion type.
  double get suggestedZoom {
    switch (type) {
      case SuggestionType.country:
        return 4;  // Wide zoom for countries
      case SuggestionType.state:
        return 7;  // Medium zoom for states/regions
      case SuggestionType.city:
        return 14; // Closer zoom for cities
      case SuggestionType.address:
        return 18; // Close-up zoom for precise addresses
    }
  }
}

/// Enum representing the type of suggested location.
enum SuggestionType {
  country,
  state,
  city,
  address
}
