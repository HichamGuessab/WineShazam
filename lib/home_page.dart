import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wine_shazam/main.dart';

void main() {
  runApp(const MyApp());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 9
          ),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            onTabChange: (index) {
              print(index);
            },
            padding: const EdgeInsets.all(20.0),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home'
              ),
              GButton(
                icon: Icons.barcode_reader,
                text: 'Scanner'
              ),
              GButton(
                icon: Icons.favorite_border,
                text: ' Favorites',
                // active: Icons.favorite
              ),
              GButton(
                icon: Icons.search,
                text: 'Search'
              ),
          ]),
        ),
      ),
    );
  }
}
