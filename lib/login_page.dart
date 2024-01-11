import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_shazam/main.dart';
import '../models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            purpleColor,
            Colors.white,
          ],
        )
      ),
     child: Scaffold(
       backgroundColor: Colors.transparent,
       body: _page(),
     ),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon(),
            const SizedBox(height: 50),
            _inputField("Username", usernameController),
            const SizedBox(height: 20),
            _inputField("Password", passwordController, isPassword: true),
            const SizedBox(height: 50),
            _loginButton()
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2
        ),
        shape: BoxShape.circle
      ),
      child : const Icon(
        Icons.person,
        color: Colors.white,
        size: 120,
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white30)
    );

    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }


  Widget _loginButton() {
    return ElevatedButton(
        onPressed: () {
          debugPrint("Username : ${usernameController.text}");
          debugPrint("Password : ${passwordController.text}");
          // HTTP request and redirection or display based on response
          _loginWithCreadentials(
              usernameController.text,
              passwordController.text
          ).then((user) => {
            if(user != null) {
              SharedPreferences.getInstance().then((prefs) => {
                prefs.setString('user_username', user.username),
                prefs.setString('user_email', user.email),
                prefs.setInt('user_id', user.id),
                Navigator.pushNamed(context, '/homepage')
              })
            }
          });
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: purpleColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16)
        ),
        child: const SizedBox(
            width: double.infinity,
            child: Text(
              "Sign In",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20)
            )
        ),
    );
  }

  Future<User?> _loginWithCreadentials(String username, String password) async {
    final url = 'http://${dotenv.env['SHAZVINCORE_HOST']}:3000/api/user/login';

    try {
      final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "username": username,
            "password": password
          }));

      if (response.statusCode == 200) {
        // Handle the successful response if needed
        debugPrint('HTTP Request Successful: ${response.body}');

        return _jsonToUser(response.body);
      }
      debugPrint('HTTP Request Failed: ${response.statusCode}');
      return null;
    } catch (e) {
      rethrow;
      // Handle potential errors during the request
      debugPrint('HTTP Request Error: $e');
      return null;
    }
  }

  User? _jsonToUser(String jsonString) {
    final Map<String, dynamic> userMap = json.decode(jsonString);
    String createdAt = userMap['createdAt'] ?? '';
    String updatedAt = userMap['updatedAt'] ?? '';

    return User(
        id: userMap['id'] ?? -1,
        username: userMap['username'] ?? '',
        email: userMap['email'] ?? '',
        enabled: true,
        createdAt: DateTime.tryParse(createdAt),
        updatedAt: DateTime.tryParse(updatedAt)
    );
  }
}