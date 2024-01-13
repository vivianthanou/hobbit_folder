import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hobbit/pages/profile_page.dart';
import 'map.dart';
import 'package:flutter/material.dart';
import 'package:hobbit/pages/event.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;


class ExplorePage extends StatefulWidget {
  final int id;
  ExplorePage({super.key, required this.id});
  @override
  State<ExplorePage> createState() => _ExploreState();
}

class _ExploreState extends State<ExplorePage> {
  LatLng _location = LatLng(0.0, 0.0);
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: 
      SafeArea(
        child:
        Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:[
          SizedBox(
            height: 50.0,
            width: double.infinity
            ),
          SizedBox(
           height: 325.0,
           child: MapPage(onMarkerCreated: _updateMarkerLocation),
            ),
          SizedBox(
          height: 100.0,
          child: 
            Text('Marker Coordinates: ${_location.latitude}, ${_location.longitude}'),
          ),
        ]
      )
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 163, 203, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             IconButton(
              color: Colors.white,
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => ExplorePage(id: widget.id)));
              },
            ),
            IconButton(
              color: const Color.fromARGB(255, 253, 110, 0),
              icon: const Icon(Icons.push_pin),
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => Event(id: widget.id)));
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
               Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage(id: widget.id)));
              },
            ),
          ],
        ),
      ),
    );
  }
  void _updateMarkerLocation(LatLng newLocation) {
  setState(() {
    _location = newLocation;
  });
}
}


