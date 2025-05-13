import 'package:flutter/material.dart';
import 'package:maps_app/pages/pages.dart';

// Main screen with bottom navigation between Map and Addresses pages
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; 

  // List of pages to display
  final List<Widget> _pages = [
    MapPage(),
    AddressesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Preserves state of each tab using IndexedStack
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _bottomNavBar(), 
    );
  }

  // Builds the bottom navigation bar
  BottomNavigationBar _bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex, // Highlights selected item
      onTap: (index) {
        setState(() {
          _currentIndex = index; // Updates selected index
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Addresses',
        ),
      ],
    );
  } 
}
