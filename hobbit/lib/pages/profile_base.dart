import 'package:flutter/material.dart';
//import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'edit_profile_page.dart';
import 'api_service.dart';
import 'Initial.dart';
import 'Login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileBase(),
    );
  }
}


class ProfileBase extends StatefulWidget {
  final ApiService apiService = ApiService('http://127.0.0.1:5000');

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileBase> {
  Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    
  }

  Future<Map<String, dynamic>> fetchUserByUsername(String username) async {
          final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/user/$username'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON
    return Map<String, dynamic>.from(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load user details');
  }
}
  

  
  void _showEditProfilePage(BuildContext context) {
    // Use Navigator to push the Edit Your Profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(),
      ),
    );
  }

  

 Widget buildSettingsOption(BuildContext context, String option) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        onTap: () {
          if (option == 'Edit Your Profile') {
            // Modified: Passed context to the _showEditProfilePage method
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => EditProfilePage(),
              ),
            );
          }
          else if (option == 'Change Account') {
            // Modified: Passed context to the _showEditProfilePage method
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => LoginPage(onTap: null,),
              ),
            );
          }
          else if (option == 'Logout') {
            // Modified: Passed context to the _showEditProfilePage method
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => Initial(),
              ),
            );
          }
          
        },
        
        child: Text(
          option,
          style: TextStyle(
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
    return Scaffold(
      body: ListView(
        children: [ 
          //Settings, Profile Picture, Username and Description
           Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // CircleAvatar in the center
                Center(
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: NetworkImage('https://placekitten.com/300/300'),
                    ),
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
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ProfileBase(),
                    ),
                    );
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
      

        SizedBox(height: 20),
        Center(
          child: 
          // Username
            Text(
            user.containsKey('username') ? user['username'] : 'Loading...',  // Display username or 'Loading...' if not fetched yet
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        

// Usage in your widget
SizedBox(height: 20),
FutureBuilder<Map<String, dynamic>>(
  future: fetchUserByUsername('username_here'), // Replace 'username_here' with the actual username
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator(); // While data is being fetched, show a loading indicator
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      final user = snapshot.data!;

      return Center(
        child: Text(
          user.containsKey('username') ? user['username'] : 'Loading...',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
    }
  },
), 

        SizedBox(height: 10),
        // Description
          Center(
            child:  
              Text(
                'Description about the user goes here.',
                style: TextStyle(fontSize: 16),
              ),
          ),
        SizedBox(height: 20),
        // Interests Section
        Text(
            '   Your Interests',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

        //Interests
        Padding(
          padding: EdgeInsets.fromLTRB(8.0, 10.0 , 8.0, 8.0),
          child: SizedBox(
            height:50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildInterestBox("Basketball"),
                buildInterestBox("Skateboard"),
                buildInterestBox("Football"),
                buildInterestBox("Volleyball"),
              ]
            )
          ),
        ),
        
        //User's Calendar
        Padding(
            padding: EdgeInsets.fromLTRB(8.0, 10.0 , 8.0, 8.0),
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
              'Events Created By You',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            ],
          ),
        ),
        Padding(
  padding: EdgeInsets.all(16.0),
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: Container(
                height: 0.5 * 200,// Adjust the height of the circular image
                width: double.infinity, // Adjust the width of the circular image
                decoration: BoxDecoration(
                  color: Colors.white, // You can set a background color if needed
                ),
                child: Image.network(
                  'https://placekitten.com/300/300', // Replace with your image URL
                  fit: BoxFit.cover,
                  
                ),
              ),
            ),
            Text(
              'Category',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 10.0,
        left: 16.0,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Events Title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Date',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Time',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Location',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)




        ]
      ),   
    );
  }
}

Widget buildInterestBox(String interest) {
  return Padding(
    padding: EdgeInsets.all(5.0),
    child: Container(
      height: 50,
      width: 100,
      color: Color.fromARGB(150, 255, 212, 170),
      child: Center(
        child: Text(
          interest,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
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
        title: Text('Your Calendar'),
        backgroundColor: Color.fromARGB(255, 255, 119, 0),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Today'),
            Tab(text: 'This Week'),
            Tab(text: 'All'),
            Tab(text: 'Previous'),
          ],
          indicator: BoxDecoration(
            color: Color.fromARGB(255, 191, 73, 0), // Set the background color of the tabs
          ),
        ),
      ),
      body: Container(
        child: TabBarView(
          controller: _tabController,
          children: [
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
    )
  );
  }
}