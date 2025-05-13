import 'package:flutter/material.dart';
import 'package:maps_app/screens/screens.dart';

class AppRouter {
  // Define the routes for navigation in the app
  static const String homeScreenRoute = '/home';

  // Map of route names to widget builders
  static Map<String, Widget Function(BuildContext)> routes = {
    homeScreenRoute: (context) => const HomeScreen(), 
  };
}

