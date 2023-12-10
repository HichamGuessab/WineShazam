import 'package:flutter/material.dart';
import 'package:wine_shazam/login_page.dart';

const purpleColor = Color(0xFFA065C3);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WineShazam',
      theme: ThemeData(
      useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage()
    );
  }
}