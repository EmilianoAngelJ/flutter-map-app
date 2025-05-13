import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PlacesService {
  // Load API key and base URL from .env file
  final apiKey = dotenv.env['GOOGLE_API_KEY'];
  final baseUrl = dotenv.env['GOOGLE_PLACES_BASE_URL'];

  // Fetch autocomplete suggestions based on user input
  Future<List<Map<String, dynamic>>> getSuggestions(String input) async {
    final url = '$baseUrl/autocomplete/json?input=$input&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final predictions = json['predictions'] as List;
      // Return a list of suggestion maps
      return predictions.map((p) => p as Map<String, dynamic>).toList();
    } else {
      // Throw an error if the API call fails
      throw Exception('Failed fetching suggestions');
    }
  }

  // Fetch detailed information for a selected place by its ID
  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final url = '$baseUrl/details/json?placeid=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // Return the full place details from the API response
      return json['result'];
    } else {
      // Throw an error if the API call fails
      throw Exception('Failed fetching place details');
    }
  }
}