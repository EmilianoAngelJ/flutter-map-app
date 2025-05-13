import 'package:flutter/material.dart';
import 'package:maps_app/widgets/widgets.dart';

/// Main screen showing the map view with search and addresses details.
class MapPage extends StatelessWidget {
  const MapPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Controller to handle user input in the search bar
    final TextEditingController searchController = TextEditingController();

    return Stack(
      children: [
        GoogleMapView(), // Displays the interactive map
        DraggableSheet(), // Bottom sheet for showing address info
        AddressesSearchBar(controller: searchController), // Search bar at top
      ],
    );
  }
}
