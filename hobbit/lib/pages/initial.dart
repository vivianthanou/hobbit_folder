import 'package:flutter/material.dart';
import 'package:hobbit/auth/login_or_register.dart';

class Initial extends StatefulWidget {
  @override
  State<Initial> createState() => _InitialState();
}

class _InitialState extends State<Initial> {

  bool showLoginPage = false;
  void togglePages(){
    setState((){
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo here
            Icon(
              Icons.person,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            SizedBox(height: 20), // Adjust the spacing as needed

            // Your "Start" button
            ElevatedButton(
              onPressed: () {
                // Navigate to the login page when the "Start" button is pressed
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginOrRegister()));
              },
              child: Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}
