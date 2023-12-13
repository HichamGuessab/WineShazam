import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wine_shazam/login_page.dart';
import 'package:wine_shazam/main.dart';
import 'package:wine_shazam/pages/barcode_page.dart';
import 'package:wine_shazam/pages/favorites_page.dart';
import 'package:wine_shazam/pages/home_page.dart';
import 'package:wine_shazam/pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _currentPage = 0;

  setCurrentPage(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: [
        const HomePage(),
        const BarCodePage(),
        const FavoritesPage(),
        const SearchPage(),
      ][_currentPage],

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
            onTabChange: (index) => setCurrentPage(index),
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
