//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hobbit/components/my_textfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';

class RegisterPage extends StatefulWidget{
  

  final void Function()? onTap;
  

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final TextEditingController firstNameController=TextEditingController();
  final TextEditingController lastNameController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController usernameController=TextEditingController();
  final TextEditingController phoneController=TextEditingController();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final TextEditingController confirmPwController=TextEditingController();
  

  List<String> interests = [
    "Basketball",
    "Football",
    "Volleyball",
    "Skateboard",
    "Hiking",
    "Bowling",
    "Biking",
    "Running",
    "Sightseeing"
  ];

  Set<String> selectedInterests = {};

String? _validateField(String value, String fieldName) {
    if (value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null; // Return null if validation succeeds
  }

Future<void> registerUser(String firstName, String lastName, String email, String username, String phone,
      String password) async {
    String? firstNameError = _validateField(firstName, 'First Name');
    String? lastNameError = _validateField(lastName, 'Last Name');
    String? emailError = _validateField(email, 'Email');
    String? usernameError = _validateField(username, 'Username');
    String? passwordError = _validateField(password, 'Password');
    String? phoneError = _validateField(phone, 'Phone');
    String? confirmPasswordError = _validateField(confirmPwController.text, 'Confirm Password');

  
    if(passwordController.text!=confirmPwController.text){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sign Up Failed'),
            content: const Text('Passwords do not match.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

  final url = Uri.parse('http://192.168.43.86:5000/signup');

    Map<String, dynamic> userData = {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'username': usernameController.text,
        'password': passwordController.text,
        'phone_number': phoneController.text,
        'date_of_birth': dateController.text,
        'email': emailController.text,
        'interests': selectedInterests.toList(),
      };

    String data = jsonEncode(userData);
    
// Send user data to your server (replace 'your_server_url' with your actual server URL)
    final response = await http.post(url,
    headers:<String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: data,
    );

      
      if (response.statusCode == 200) {
        if(context.mounted) {
          // User registered successfully on the server
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(onTap: null,)),
          );
        }
      } else {
      // Login failed
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("SignUp Failed"),
            content: const Text(
                "You are trying to sign up with invalid information"),
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
              
              const SizedBox(height: 30),

            Container(
    height: MediaQuery.of(context).size.height * 0.4, // Adjust the height as needed
    padding: EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyTextField(hintText: "First Name", obscureText: false, controller: firstNameController),
          SizedBox(height: 10),
          MyTextField(hintText: "Last Name", obscureText: false, controller: lastNameController),
          SizedBox(height: 10),
          TextField(
                controller: dateController, //editing controller of this TextField
                decoration: InputDecoration( 
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                    ),
                   //icon: Icon(Icons.calendar_today), //icon of text field
                   hintText: "Date of birth" //label text of field
                ),
                readOnly: true,  //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context, initialDate: DateTime(2020),
                      firstDate: DateTime(1920), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2021)
                  );
                  
                  if(pickedDate != null ){
                      print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); 
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                         dateController.text = formattedDate; //set output date to TextField value. 
                      });
                  }else{
                      print("Date is not selected");
                  }
                },
             ),
      
          SizedBox(height: 10),
          MyTextField(hintText: "Username", obscureText: false, controller: usernameController),
          SizedBox(height: 10),
          MyTextField(hintText: "Phone Number", obscureText: false, controller: phoneController),
          SizedBox(height: 10),
          MyTextField(hintText: "Email", obscureText: false, controller: emailController),
          SizedBox(height: 10),
          MyTextField(hintText: "Password", obscureText: true, controller: passwordController),
          SizedBox(height: 10),
          MyTextField(hintText: "Confirm Password", obscureText: true, controller: confirmPwController),
          SizedBox(height: 10),

           Container(
            child: Wrap(
            spacing: 5.0,
            children: interests
            .map((interest) => ChoiceChip(
                  label: Text(interest),
                  selected: selectedInterests.contains(interest),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedInterests.add(interest);
                      } else {
                        selectedInterests.remove(interest);
                      }
                    });
                  },
                ))
            .toList(),
      ),
    ),
        // Area to show multiple choices
 
          // Add more widgets if needed
        ],
      ),
    ),
  ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Forgot Passowrd?", style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
              const SizedBox(height: 25),
              
              //register Button
              ElevatedButton(
              onPressed: () {
                registerUser(
                  firstNameController.text,
                lastNameController.text,
                emailController.text,
                usernameController.text,
                passwordController.text,
                phoneController.text
                );
              },
              child: const Text('Sign Up'), 
            ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text("Login Here",
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
