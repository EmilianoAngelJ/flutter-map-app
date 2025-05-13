import 'package:maps_app/global/toast.dart';
import 'package:maps_app/models/models.dart';
import 'package:maps_app/services/places_services.dart';
import 'package:maps_app/theme/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SuggestionsHelper {
  final PlacesService _placesService = PlacesService();

  // Processes a selected suggestion to fetch its details and return a SuggestionModel
  Future<SuggestionModel?> selectSuggestion(Map<String, dynamic> suggestion) async {
    try {
      final placeId = suggestion['place_id'];
      
      // Get detailed information about the place
      final details = await _placesService.getPlaceDetails(placeId);

      // Extract latitude and longitude from the result
      final location = details['geometry']['location'];
      final lat = location['lat'];
      final lng = location['lng'];

      // Extract types and description from the suggestion
      final type = suggestion['types'];
      final description = suggestion['description'];

      // Create and return a SuggestionModel with location, type, and description
      return SuggestionModel(
        location: LatLng(lat, lng),
        type: determineSuggestionType(type),
        description: description
      );
      
    } catch (e) {
      // Show error toast if anything fails
      showToast(
        message: 'Failed to fetch suggestions',
        backgroundColor: AppColors.redAccentColor,
      );
      return null;
    }
  }
}

// Determines the type of suggestion based on the list of place types
SuggestionType determineSuggestionType(List<dynamic> type) {
  if (type.contains('country')) return SuggestionType.country;
  if (type.contains('administrative_area_level_1')) return SuggestionType.state;
  if (type.contains('locality') || type.contains('administrative_area_level_2')) {
    return SuggestionType.city;
  }
  if (type.contains('route') || type.contains('premise')) {
    return SuggestionType.address;
  }

  // Fallback to address if no specific type is matched
  return SuggestionType.address; 
}
