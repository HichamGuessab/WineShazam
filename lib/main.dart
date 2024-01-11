import 'package:flutter/material.dart';
import 'package:wine_shazam/main_page.dart';
import 'package:wine_shazam/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const purpleColor = Color(0xFFA065C3);

Future main() async {
  await dotenv.load(fileName: ".env");

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
      home: const LoginPage(),
      routes: {
        '/homepage': (context) => const MainPage(),
      },
    );
  }
}