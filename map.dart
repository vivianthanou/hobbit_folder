//import 'dart:html';
import 'dart:async';
//import 'dart:convert';

//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  final Function(LatLng) onMarkerCreated;
  const MapPage({super.key, required this.onMarkerCreated});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Marker? _marker;
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  
  static const LatLng _pGooglePlex = LatLng(38.124833333333335, 23.85861111111111);
  LatLng? _currentP;
  
  
 // void _updateMarkerPosition(pos) {
 //setState(() {
 //   _location = pos;
 // });
//}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationUpdates();
  }
  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _currentP == null 
      ? const Center(
        child: Text("Loading..."),
      )
      : GoogleMap(
        onMapCreated: ((GoogleMapController controler) => _mapController.complete(controler)),
        initialCameraPosition: CameraPosition(
        target: _pGooglePlex,
        zoom: 13,
        ),
        markers: {
          Marker(
            markerId: MarkerId("_currentLocation"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            position: _currentP!,
            ),
          if (_marker != null) _marker!,
        },
        onLongPress: (LatLng details) {
        //_updateMarkerPosition(details);
        _addMarker(details);
        
        },
        
        
        ),
        
      floatingActionButton: FloatingActionButton(
      backgroundColor: Theme.of(context).canvasColor,
      foregroundColor: Color.fromARGB(255, 227, 228, 230),
      onPressed: () => _cameraToPosition(_currentP!),
     
      child: const Icon(Icons.center_focus_strong, color: Color.fromARGB(255, 102, 102, 102),),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition),);
  }

Future<void> getLocationUpdates() async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await _locationController.serviceEnabled();
  if (serviceEnabled) {
    serviceEnabled = await _locationController.requestService();
  }
  else {
    return;
  }

  permissionGranted = await _locationController.hasPermission();
  if (permissionGranted == PermissionStatus.denied){
    permissionGranted = await _locationController.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  _locationController.onLocationChanged.listen((LocationData currentLocation) {
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      setState(() {
        _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        //_cameraToPosition(_currentP!);
      }); 
    }
  });
}
void _addMarker(LatLng pos) {
  String Loc ='${pos.latitude},${pos.longitude}';
  print(Loc);
    setState(() {
     
      _marker = Marker(
      markerId: const MarkerId("marker"),
      //infoWindow: InfoWindow(title: Loc),
      icon: BitmapDescriptor.defaultMarker,
      position: pos,
      );
   });
   widget.onMarkerCreated(pos);
} 

}