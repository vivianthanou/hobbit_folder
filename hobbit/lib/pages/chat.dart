import 'package:flutter/material.dart';
import 'event.dart';
import 'profile_page.dart';
import 'explore_page.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: 
       Container(
        color: Color.fromARGB(255, 138, 177, 236), 
        child: const Center(
        child: Text('Chat'),
       ),
       ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 163, 203, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             IconButton(
              color: const Color.fromARGB(255, 253, 110, 0),
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, '/explore');
              },
            ),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.push_pin),
              onPressed: () {
                Navigator.pushNamed(context, '/event');
              },
            ),
            IconButton(
              color: const Color.fromARGB(255, 253, 110, 0),
              icon: const Icon(Icons.message),
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
            ),
            IconButton(
              color: const Color.fromARGB(255, 253, 110, 0),
              icon: const Icon(Icons.account_circle),
             onPressed: () {
              Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
      
    );
  }
}
