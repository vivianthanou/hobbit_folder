//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:hobbit/firebase_options.dart';
import 'pages/initial.dart'; 
import 'pages/explore_page.dart';
import 'pages/event.dart';
import 'pages/chat.dart';
import 'pages/profile_page.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
    ChangeNotifierProvider(
      create: (context) => ProfileData(),
      child:MaterialApp(
      // Determine the initialRoute based on the user's authentication status
      initialRoute:'/initial',
      routes: {
        '/initial': (context) => Initial(),
        //'/explore': (context) => Explore(),
        //'/event': (context) => Event(),
        '/chat': (context) => Chat(),
        //'/profile': (context) => ProfilePage(),
      },
    )
    );
  }
}
