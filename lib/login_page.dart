import 'package:flutter/material.dart';
import 'package:wine_shazam/main.dart';

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
          if(usernameController.text == 'showDialog') {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  actions: [
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    )
                  ],
                  title: const Center(child: Text('Incorrect password')),
                  contentPadding: const EdgeInsets.all(20.0),
                  content: const Text('No connection, no wine...'),
                )
            );
          } else {
            // Home page redirection
          }
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
}