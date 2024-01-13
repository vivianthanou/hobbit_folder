//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobbit/components/my_button.dart';
import 'package:hobbit/components/my_textfield.dart';
import 'package:hobbit/pages/explore_page.dart';
import 'package:hobbit/pages/profile_page.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'helper_function.dart';
import 'explore_page.dart';
import 'manager.dart';

class LoginPage extends StatefulWidget{
  
  final void Function()? onTap;

   LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final TextEditingController emailController=TextEditingController();

  final TextEditingController passwordController=TextEditingController();

  //login method
Future<void> login(String email, String password) async {
    
  final url = Uri.parse('http://192.168.43.86:5000/login');

    Map<String, dynamic> userData = {
        'password': password,    
        'email': email,   
      };

    String data = jsonEncode(userData);
    
// Send user data to your server (replace 'your_server_url' with your actual server URL)
    final response = await http.post(url,
    headers:<String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: data,
    );
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        
        
        var responseData = json.decode(response.body);
        int id = responseData[0];
        
        if(context.mounted) {
          // User registered successfully on the server
        
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(id: id)),

      );
      

        }
     } 
      
      else {
      // Login failed
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Login Failed"),
            content: const Text(
                "Wrong Email or Password"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }

     
    } 

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo of hobbit
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),
          
              //app name
              const Text("Hobb-it",
              style: TextStyle(fontSize: 20)),
              
              const SizedBox(height: 50),
          
              //email textField
              MyTextField(hintText: "Email", obscureText: false, controller: emailController),
              
              const SizedBox(height: 10),
              //password textField
              MyTextField(hintText: "Password", obscureText: true, controller: passwordController),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Forgot Passowrd?", style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
              const SizedBox(height: 25),

              MyButton(text: "Login", onTap:() { login(emailController.text, passwordController.text);},
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text("Register Here",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      )
    );
  }
}