//import 'dart:html';
//import 'dart:async';
//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hobbit/pages/event.dart';
import 'package:hobbit/pages/profile_page.dart';
//import 'package:location/location.dart';
import 'map.dart';
//import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
//import 'package:flutter/foundation.dart';


class Explore extends StatefulWidget {
  final int id;
  Explore({Key? key, required this.id}) : super(key: key);
  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  LatLng _location = LatLng(0.0, 0.0);
  List<String> ? titles;

  @override
  void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final profileData = Provider.of<ProfileData>(context, listen: false);
    titles = profileData.interests;
    for (String interr in titles!){
    profileData.fetchCategoryEvents(interr);
    } // Fetch user events
  });
}
  @override
  Widget build(BuildContext context) {
    final profileData = Provider.of<ProfileData>(context);
    //List<String> interests = profileData.interests;
    //profileData.fetchCategoryEvents("Basketball");
    return Scaffold(
      body: 
      SingleChildScrollView(
      child:
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
          Column(
            children: [
              for (String inter in titles!)
              Column(
              children: [
                Text(inter),
                SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: Row(
                   children: profileData.categoryEvents[inter]?.map((event) {
                     return EventBox(event); // A widget that displays the event details
                   }).toList() ?? [],
          )
                )
              ],
              )
            ],
          )
        
        
        ]
      )
      ),
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
        MaterialPageRoute(builder: (context) => Explore(id: widget.id)));
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



class EventBox extends
StatelessWidget {
final Event2 event;

EventBox(this.event);

@override
Widget build(BuildContext context) {
return Container(
margin: EdgeInsets.all(8.0),
padding: EdgeInsets.all(10.0),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(10),
boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3)],
),
child: Column(
children: <Widget>[
Text(event.title!, style: TextStyle(fontWeight: FontWeight.bold)),
SizedBox(height: 5),
Text(event.date!),
SizedBox(height: 5),
Text(event.time!),
SizedBox(height: 5),
Text(event.location!),
],
),
);
}
}