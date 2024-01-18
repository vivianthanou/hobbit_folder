import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hobbit/pages/explore.dart';
import 'package:hobbit/pages/profile_page.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:location/location.dart';
import 'package:hobbit/pages/map.dart';
//import 'package:http/http.dart;
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'dart:ui' as ui;
import 'package:flutter/services.dart';
//import 'package:flutter/gestures.dart';

class CreateEvent extends StatefulWidget {
  final int id;
  CreateEvent({Key? key, required this.id}) : super(key: key);
  @override
  State<CreateEvent> createState() => _EventState();
}

class _EventState extends State<CreateEvent> {
  LatLng _location = const LatLng(0.0, 0.0);
  TextEditingController _textTitleController = TextEditingController();
  TextEditingController _textDescriptionController = TextEditingController();
  String? _selectedOption;
  DateTime _dateTime = DateTime.now();
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 8, minute: 30);
  Uint8List? _selectedImage;

  List<String> options = [
    'Basketball',
    'Football',
    'Volleyball',
    'Skateboard',
    'Hiking',
    'Bowling',
    'Biking',
    'Running',
    'Sightseeing',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 100.0,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _textTitleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                    const SizedBox(height: 4.0),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Choose A Category'),
              DropdownButton<String>(
                value: _selectedOption,
                onChanged: (String? newValue) {
                  _defaultImage(newValue!);
                  setState(() {
                    _selectedOption = newValue;
                  });
                },
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                      onPressed: _showDatePicker,
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("Choose Date",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 116, 114, 114),
                                  fontSize: 16)),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                        "${_dateTime.day} / ${_dateTime.month} / ${_dateTime.year}",
                        style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                      onPressed: _showTimePicker,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("Pick Time",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 106, 106, 106),
                                  fontSize: 16)),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      _timeOfDay.format(context).toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 325.0,
                child: MapPage(onMarkerCreated: _updateMarkerLocation),
              ),
              Container(
                height: 110.0,
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    'Marker Coordinates: ${_location.latitude}, ${_location.longitude}',
                    style: const TextStyle(fontSize: 16.0)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedImage == null /* && _selectedOption == null */)
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Please Select Image",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  else
                    Image(
                      image: MemoryImage(_selectedImage!),
                      width: 300,
                      height: 300,
                    ),

                  MaterialButton(
                      onPressed: () {
                        _handleImageUpload();
                      },
                      color: const Color.fromARGB(255, 253, 253, 253),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text("Image from Gallery",
                            style: TextStyle(
                              color: Color.fromARGB(255, 135, 135, 135),
                              fontSize: 16,
                            )),
                      )),
                  MaterialButton(
                      onPressed: () {
                        _handleOpenCamera();
                      },
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text("Image from Camera",
                            style: TextStyle(
                              color: Color.fromARGB(255, 137, 137, 137),
                              fontSize: 16,
                            )),
                      )),
                  // const SizedBox(height: 20,),
                ],
              ),
              Container(
                height: 100.0,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _textDescriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 4.0),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 243, 117, 33)),
                onPressed: () {
                  // Call the function to save the event
                  _createEvent(context);
                },
                child: const Text(
                  'Create Event',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ],
          ),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Explore(id: widget.id)));
              },
            ),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.push_pin),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateEvent(id: widget.id)));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(id: widget.id)));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _defaultImage(String cat) async {
    String? imageUrl;
    switch (cat) {
      case 'Basketball':
        imageUrl =
            'https://i.pinimg.com/564x/f5/c3/9a/f5c39a98bde8aefe463aeddf343c127f.jpg';
        break;
      case 'Football':
        imageUrl =
            'https://static.vecteezy.com/system/resources/previews/004/693/432/non_2x/simple-football-sport-icon-on-white-background-free-vector.jpg';
        break;
      case 'Volleyball':
        imageUrl =
            'https://uxwing.com/wp-content/themes/uxwing/download/sport-and-awards/ball-volleyball-icon.png';
        break;

      case 'Skateboard':
        imageUrl = 'https://icons.veryicon.com/png/o/sport/motion/skate-9.png';
        break;
      case 'Hiking':
        imageUrl =
            'https://cdn-icons-png.flaticon.com/512/2017/2017204.png?ga=GA1.1.1857019778.1704805348&';
        break;
      case 'Bowling':
        imageUrl = 'https://cdn-icons-png.flaticon.com/512/750/750980.png';
        break;
      case 'Biking':
        imageUrl = 'https://cdn-icons-png.flaticon.com/512/923/923743.png';
        break;
      case 'Running':
        imageUrl =
            'https://t4.ftcdn.net/jpg/04/49/34/51/360_F_449345108_z4ANLnFkRERqbR05RvnqMid2HHk1UHT1.jpg';
        break;
      case 'Sightseeing':
        imageUrl =
            'https://cdn4.iconfinder.com/data/icons/sightseeing/512/15_tourist_travel_vacation_tour_sightseeing_camping-512.png';
        break;
    }
    if (imageUrl!.isNotEmpty) {
      try {
        Uint8List imageBytes = await networkImageToUint8List(imageUrl);
        setState(() {
          _selectedImage = imageBytes;
        });
      } catch (e) {
        // Handle errors, e.g., by showing an error message
      }
    }
  }

  void _handleImageUpload() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? returnedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (returnedImage != null) {
      Uint8List imageBytes = await returnedImage.readAsBytes();
      setState(() {
        _selectedImage = imageBytes;
      });
    }
  }

  void _handleOpenCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? returnedImage =
        await _picker.pickImage(source: ImageSource.camera);

    if (returnedImage != null) {
      Uint8List imageBytes = await returnedImage.readAsBytes();
      setState(() {
        _selectedImage = imageBytes;
      });
    }
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2030))
        .then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _timeOfDay = value;
        });
      }
    });
  }

  void _updateMarkerLocation(LatLng newLocation) {
    setState(() {
      _location = newLocation;
    });
  }

  void _createEvent(BuildContext context) async {
    String title = _textTitleController.text;
    String category = _selectedOption ?? 'default_category';
    String date =
        "${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}";
    String time =
        "${_timeOfDay.hour.toString().padLeft(2, '0')}:${_timeOfDay.minute.toString().padLeft(2, '0')}:00";
    String location = '${_location.latitude}, ${_location.longitude}';
    double latitude = _location.latitude; // Assuming this is a float
    double longitude = _location.longitude;
    String image = base64Encode(_selectedImage!);
    String description = _textDescriptionController.text;



    final url = Uri.parse('http://192.168.120.2:5000/create_event');

    Map<String, dynamic> eventData = {
      'host_id': widget.id,
      'title': title,
      'category': category,
      'date': date,
      'time': time,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'image': image
    };

    String data = jsonEncode(eventData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: data,
    );

    if (response.statusCode == 200) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventConfirmationPage(),
          ),
        );
      }
    } else {
      String responseBody = response.body;
      print('Request failed with status: ${response.statusCode}.');
      print('Response body: $responseBody');

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Event was not Created"),
            content: const Text("Invalid Information"),
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
}

class EventConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFDAB9), // Peach color background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.event_available, // Placeholder for the custom icon
              size: 120.0,
              color: Colors.orange,
            ),
            Text(
              'Event Created',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            Icon(
              Icons.event_available, // Placeholder for the custom icon
              size: 120.0,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}

Future<Uint8List> networkImageToUint8List(String imageUrl) async {
  final response = await HttpClient().getUrl(Uri.parse(imageUrl));
  final HttpClientResponse httpClientResponse = await response.close();

  if (httpClientResponse.statusCode == 200) {
    final List<int> bytes = await httpClientResponse.fold<List<int>>(
        <int>[], (bytes, List<int> data) => bytes..addAll(data));
    return Uint8List.fromList(bytes);
  } else {
    throw Exception('Failed to fetch network image');
  }
}
