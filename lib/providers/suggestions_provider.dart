import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_app/models/models.dart';

/// Holds the currently selected map suggestion (e.g., a place or address).
final selectedSuggestionProvider = StateProvider<SuggestionModel?>((ref) => null);