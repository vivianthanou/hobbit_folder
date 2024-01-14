import 'package:flutter/material.dart';
import 'package:hobbit/pages/event.dart';
//import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'edit_profile_page.dart';
//import 'api_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;


class ProfileData extends ChangeNotifier {

  String _username = "username";
  String get username => _username;

  void updateUsername(String newName,int userId) async {
    //PAGE
    _username = newName;
    notifyListeners();
    
    //DATABASE
    var url = Uri.parse('http://192.168.2.5:5000/updateUsername');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'userId': userId, 'newUsername': newName}),
    );

    if (response.statusCode == 200) {
      print('Username updated successfully in the database');
    } else {
      print('Failed to update username in the database');
      // Optionally, handle failed update (e.g., revert the username change locally)
    }
  }


  String _description = "";
  String get description => _description;

  void updatedDescription(String newDescription,int userId) async {
    //PAGE
    _description = newDescription;
    notifyListeners();
    
    //DATABASE
    var url = Uri.parse('http://192.168.2.5:5000/updateDescription');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'userId': userId, 'newDescription': newDescription}),
    );

    if (response.statusCode == 200) {
      print('Description updated successfully in the database');
    } else {
      print('Failed to update Descripton in the database');
      // Optionally, handle failed update (e.g., revert the username change locally)
    }
  }


  Uint8List? _profileImage;
  Uint8List? get profileImage => _profileImage;
  

  void updateProfileImage(Uint8List newImage, int userId) async {
    _profileImage = newImage;
    notifyListeners();
    //DATABASE
    String newImage2 = base64Encode(newImage);
    var url = Uri.parse('http://192.168.2.5:5000/updateImage');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'userId': userId, 'newImage': newImage2}),
    );
    if (response.statusCode == 200) {
      print('Description updated successfully in the database');
    } else {
      print('Failed to update Descripton in the database');
      // Optionally, handle failed update (e.g., revert the username change locally)
    }
    
  }


  List<String> _interests = [];
  List<String> get interests => _interests;

  void updateInterests(String newInterest, int userId) async {
    if (_interests.contains(newInterest) == false){
    _interests.add(newInterest);
    notifyListeners();


    var url = Uri.parse('http://192.168.2.5:5000/updateInterests');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'userId': userId, 'newInterest': newInterest}),
    );

    if (response.statusCode == 200) {
      print('Interests updated successfully in the database');
    } else {
      print('Failed to update Interests in the database');
      // Optionally, handle failed update (e.g., revert the username change locally)
    }
    }
  }


  Future<void> fetchUserData(int userId) async {
    var url = Uri.parse('http://192.168.2.5:5000/getdata?userId=$userId');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _username = data['username'];
       notifyListeners();
      _description = data['user_description'];
       notifyListeners();
      _profileImage = base64Decode(data['photo']);
       notifyListeners();
      _interests = (data['interests'] as String).split(','); // Parse the interests string into a list
    notifyListeners();
    } 
    else {
      print('Failed to fetch user data');
    }
  }

  List<Event2> _userEvents = [];
  List<Event2> get userEvents => _userEvents;

  Future<void> fetchUserEvents(int userId) async {
    var url = Uri.parse('http://192.168.2.5:5000/getUserEvents?userId=$userId');
    var response = await http.get(url);

     if (response.statusCode == 200) {
    List<dynamic> eventData = json.decode(response.body);
    // Ensure that each item in eventData is actually a Map<String, dynamic>
    if (eventData.every((element) => element is Map<String, dynamic>)) {
      _userEvents = eventData.map((data) => Event2.fromJson(data)).toList();
    } else {
      print('Data format is not as expected');
    }
      notifyListeners();
    } else {
      print('Failed to fetch user events');
    }
  }
}
class Event2 {
final String ? title;
final String ? date;
final String ? time;
final String ? location;
// Add other fields as necessary

Event2({this.title, this.date, this.time, this.location});

factory Event2.fromJson(Map<String, dynamic> json) {
return Event2(
title: json['title'],
date: json['date'],
time: json['time'],
location: json['location'],
// Initialize other fields as necessary
);
}
}


class ProfilePage extends StatefulWidget {
  final int id;
  ProfilePage({Key? key, required this.id}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}



class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final profileData = Provider.of<ProfileData>(context, listen: false);
    profileData.fetchUserData(widget.id);
    profileData.fetchUserEvents(widget.id); // Fetch user events
  });
}
  //final profileData = Provider.of<ProfileData>;
  void _showEditProfilePage(BuildContext context) async {
    // Use Navigator to push the Edit Your Profile page
    //final profileData = Provider.of<ProfileData>(context, listen: false);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(id: widget.id),
      ),
    );
  //   if (updatedUsername != null) {
  //   _updateUsername(updatedUsername);
  // }
  }
 
  Widget buildSettingsOption(BuildContext context, String option) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        onTap: () {
          if (option == 'Edit Your Profile') {
            // Modified: Passed context to the _showEditProfilePage method
            _showEditProfilePage(context);
          }
        },
        child: Text(
          option,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  
  @override
  
  Widget build(BuildContext context) {
    final profileData = Provider.of<ProfileData>(context);
    
    //profileData.fetchUserData(widget.id);
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 215, 254),
      body: SingleChildScrollView(
        child: SafeArea(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
           //Settings, Profile Picture, Username and Description
           Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 42,),
                // CircleAvatar in the center
                //  CircleAvatar(
                //     radius: 90,
                //     backgroundImage: profileData.image,
                //     ),
                 if (profileData.profileImage != null)
          CircleAvatar(
            backgroundImage: MemoryImage(profileData.profileImage!),
            radius: 70,
          )
        else
          const CircleAvatar(
            // Default image if none selected
            backgroundImage: NetworkImage('https://placekitten.com/300/300'),
            radius: 70,
          ),
                // Settings button on the right
                InkWell(
                  onTap: () {
               showDialog(
        context: context,
        builder: (BuildContext context) {
        return Material(
        type: MaterialType.transparency,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: 400,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Color.fromARGB(255, 255, 197, 147),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ 
                buildSettingsOption(context, 'Edit Your Profile'),
                buildSettingsOption(context, 'Change Account'),
                buildSettingsOption(context, 'Logout'),
                ElevatedButton(
                  child: const Text("Back"),
                  onPressed:() {
                    Navigator.pop(context); 
                    //MaterialPageRoute(
                    //  builder: (context) => ProfilePage(),
                    //),
                    //);
                  },
                ),  
              ],
              
            ),
          ),
        ),
      );
    },
  );
               },

                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
           const SizedBox(height: 10),
           Center(
          child: 
          // Username
            Text(
              profileData.username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
        ),
           const SizedBox(height: 5),
           // Description
           Center(
            child:  
              Text(
                profileData.description,
                style: const TextStyle(fontSize: 16),
              ),
          ),
           const SizedBox(height: 5),
           // Interests Section
           const Text(
            '   Your Interests',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
           //Interests
           Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 10.0 , 8.0, 8.0),
          child: SizedBox(
            height:50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (String interest in profileData.interests) 
                  buildInterestBox(interest)
              ]
            )
          ),
        ),
           //User's Calendar
           Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 10.0 , 8.0, 8.0),
            child: SizedBox(
              height: 300,
              child: YourCalendarWidget(),
            ),
          ),
           //Events Created By You
            Padding(
          padding: EdgeInsets.fromLTRB(8.0, 10.0 , 12.0, 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
             Text(
                'Events Cd By You',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            
      //       Expanded(
      //   child: ListView.builder(
      //     itemCount: profileData.userEvents.length,
      //     itemBuilder: (context, index) {
      //       var event = profileData.userEvents[index];
      //       return buildEventContainer(event);
      //     },
      //   ),
      // ),
            ],
          ),
        ),
           Padding(
           padding: const EdgeInsets.all(16.0),
    child: Stack(
    children: [
      Container(
        height: 200, // Adjust the height as needed
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), // Circular border
          color: Colors.grey[300], // Background color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: Container(
                height: 0.5 * 200,// Adjust the height of the circular image
                width: double.infinity, // Adjust the width of the circular image
                //decoration: const  BoxDecoration(
                //  color: Colors.white, // You can set a background color if needed
              //  ),
               // child: Image.network(
                  //'https://placekitten.com/300/300', // Replace with your image URL
                 // fit: BoxFit.cover,
               // ),
              ),
            ),
            const Text(
              'Category',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 10.0,
        left: 16.0,
        child: 
        Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    children: [
      const Text(
        'Events  By You',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      
    ],
  ),
)
        // Container(
        //   padding: const EdgeInsets.all(16.0),
        //   child: const Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'title',
        //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //       ),
        //       Text(
        //         'Date',
        //         style: TextStyle(fontSize: 16),
        //       ),
        //       Text(
        //         'Time',
        //         style: TextStyle(fontSize: 16),
        //       ),
        //       Text(
        //         'Location',
        //         style: TextStyle(fontSize: 16),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    ],
  ),
)
        ]
        )
        )
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
              color: Colors.white,
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
}

Widget buildInterestBox(String interest) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      height: 50,
      width: 100,
      color: const Color.fromARGB(150, 255, 212, 170),
      child: Center(
        child: Text(
          interest,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

class YourCalendarWidget extends StatefulWidget {
  @override
  _YourCalendarWidgetState createState() => _YourCalendarWidgetState();
}

class _YourCalendarWidgetState extends State<YourCalendarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Calendar'),
        backgroundColor: const Color.fromARGB(255, 255, 119, 0),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'This Week'),
            Tab(text: 'All'),
            Tab(text: 'Previous'),
          ],
          indicator: const BoxDecoration(
            color: Color.fromARGB(255, 191, 73, 0), // Set the background color of the tabs
          ),
        ),
      ),
      body: 
         TabBarView(
          controller: _tabController,
          children: const [
            // Today's Events
            Center(child: Text('Today\'s Events')),

            // This Week's Events
            Center(child: Text('This Week\'s Events')),

            // All Events
            Center(child: Text('All Events')),

            // Previous Events
            Center(child: Text('Previous Events')),
        ],
      ),
    
  );
  }
}
Widget buildEventContainer(Event2 event) {
  return Container(
    // Define your container appearance
    child: Column(
      children: [
        Text(event.title!),
        Text(event.date!),
        Text(event.time!),
        Text(event.location!),
        // Add other event details
      ],
    ),
  );
}
