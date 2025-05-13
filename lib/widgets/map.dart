import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_app/models/models.dart';
import 'package:maps_app/providers/providers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/utils/utils.dart';

class GoogleMapView extends ConsumerStatefulWidget {
  const GoogleMapView({super.key});

  @override
  ConsumerState<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends ConsumerState<GoogleMapView> {
  GoogleMapController? _mapController; // Controller to manage Google Map
  LatLng? _currentPosition;            // User's current location
  bool _isMapCreated = false;          // Flag to check if map is fully initialized
  final Set<Marker> _markers = {};           // Set to hold markers on the map

  // Default initial position (San Francisco)
  final LatLng _initialPosition = LatLng(37.7749, -122.4194);

  @override
  void initState() {
    super.initState();
    _getGeolocation(); // Fetch the location as soon as widget is initialized

    // Escucha los cambios del provider y mueve la cámara si cambia la ubicación seleccionada
    ref.listenManual<SuggestionModel?>(selectedSuggestionProvider, (prev, next) {
      if (next != null && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(next.location, next.suggestedZoom),
        );
      }
    });
  }

  /// Method to retrieve the user's current location and updates the map accordingly.
  Future<void> _getGeolocation() async {
    final position = await GeolocationHelper.getCurrentLocation();
    if (position != null) {
      setState(() => _currentPosition = position);
      if (_isMapCreated && _mapController != null) {
        GeolocationHelper.animateToPosition(_mapController!, position);
      }
    }
  }

  /// Called once the Google Map is fully initialized
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _isMapCreated = true;

    // Move the camera to the user's current location if available
    if (_currentPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15),
      );
    }
  }

  /// This method retrieves the address from the tapped coordinates
  void _onMapPressed(LatLng latLng) {
    AddressHelper().getAddressFromLatLng(latLng, ref);
    
    // adds marker 
    setState(() {
      _markers.clear(); 
      _markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
        )
      );
    });
  }

  /// Clear markers when the map is tapped
  void _onMapTapped(LatLng latLng) {
    AddressHelper().clearAddress(ref);
    setState(() {
      _markers.clear(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated, // Callback to set up controller
      initialCameraPosition: CameraPosition(
        target: _currentPosition ?? _initialPosition,  // Fallback if current position is not ready
        zoom: _currentPosition != null ? 15.0 : 3.0,   // Closer zoom if location is known
      ),
      onLongPress: _onMapPressed, // Callback for when the map is pressed
      onTap: _onMapTapped,
      markers: _markers,
      mapType: MapType.hybrid,          
      myLocationEnabled: true,             
      myLocationButtonEnabled: false, 
      zoomControlsEnabled: false,     
    );
  }
}