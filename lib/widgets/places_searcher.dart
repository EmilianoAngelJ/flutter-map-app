import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_app/models/models.dart';
import 'package:maps_app/providers/providers.dart';
import 'package:maps_app/services/places_services.dart';
import 'package:maps_app/theme/colors.dart';
import 'package:maps_app/utils/suggestion_helper.dart';

class AddressesSearchBar extends ConsumerStatefulWidget {
  final TextEditingController? controller;

  const AddressesSearchBar({
    super.key,
    this.controller,
  });

  @override
  ConsumerState<AddressesSearchBar> createState() => _AddresesSearchBarState();
}

class _AddresesSearchBarState extends ConsumerState<AddressesSearchBar> {
  bool _hasText = false; // Tracks if the text field contains input
  bool _isProgrammaticChange = false; // Used to prevent triggering onTextChanged when updating programmatically
  List<Map<String, dynamic>> _suggestions = []; // Stores place suggestions
  final PlacesService _placesService = PlacesService(); // Service to fetch suggestions from Google Places API
  final SuggestionsHelper _suggestionsHelper = SuggestionsHelper(); // Helper to convert raw suggestions into model

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged); // Attach text change listener
  }

  // Called whenever the text field value changes
  void _onTextChanged() async {
    if (_isProgrammaticChange) return; // Skip if change was made programmatically

    final text = widget.controller?.text ?? '';
    final hasText = text.isNotEmpty;

    List<Map<String, dynamic>> suggestions = [];

    // Fetch suggestions if text is not empty
    if (hasText) {
      suggestions = await _placesService.getSuggestions(text);
    }

    setState(() {
      _hasText = hasText;
      _suggestions = suggestions;
    });
  }

  // Called when user taps outside the input field
  void _onTapOutside(PointerUpEvent event) {
    FocusScope.of(context).unfocus(); 
    setState(() {
      _hasText = false;
      _suggestions = [];
    });
  }

  // Called when user taps on a suggestion
  Future<void> _selectSuggestion(Map<String, dynamic> suggestion) async {
    final SuggestionModel? suggestionModel = await _suggestionsHelper.selectSuggestion(suggestion);

    if (suggestionModel != null) {
      _isProgrammaticChange = true;
      widget.controller?.text = suggestion['description']; 
      _isProgrammaticChange = false;

      setState(() {
        _hasText = false;
        _suggestions = [];
      });

      // Save selected suggestion in a provider for use in the map
      ref.read(selectedSuggestionProvider.notifier).update((state) => suggestionModel);

      if (!mounted) return;
      FocusScope.of(context).unfocus(); // Dismiss keyboard
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged); // Clean up listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The main search input
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                controller: widget.controller,
                decoration: _buildInputDecoration(context), // Custom input styling
                onTapUpOutside: _onTapOutside, // Detect taps outside
              ),
            ),
          ),
        ),

        // Suggestion list shown below input
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _suggestions.isNotEmpty
            ? _suggestionsList()
            : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // Builds the list of suggestions below the search bar
  Container _suggestionsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = _suggestions[index];
          return ListTile(
            title: Text(suggestion['description']),
            onTap: () => _selectSuggestion(suggestion), // Handle tap on suggestion
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: AppColors.greenAccentColor.withAlpha(80),
            height: 1,
          );
        },
      ),
    );
  }

  // Custom input field decoration
  InputDecoration _buildInputDecoration(BuildContext context) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.primaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      hintText: 'Search for a place',
      prefixIcon: const Icon(
        Icons.search,
        color: AppColors.greenAccentColor,
      ),
      suffixIcon: _hasText
        ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              // Clear input and suggestions
              widget.controller?.clear();
              setState(() {
                _hasText = false;
                _suggestions = [];
              });
              FocusScope.of(context).unfocus(); 
            },
          )
        : null,
    );
  }
}
