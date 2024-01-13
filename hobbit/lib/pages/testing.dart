import 'package:flutter/material.dart';
//import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'profile_page.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  
  

  String _userProfileImage = 'https://placekitten.com/300/300';

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _verifyEmailController = TextEditingController();

  //stt.SpeechToText _speech = stt.SpeechToText(); // Initialize directly
  
  @override
  Widget build(BuildContext context) {
    ProfilePage profilePage = ProfilePage(); // Create an instance of ProfilePage

    // Now you can use the buildSettingsOption method
    Widget settingsOption = profilePage.buildSettingsOption(context, 'Some Option');

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FocusScope(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User Profile Image and Change Photo button
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(_userProfileImage),
                    ),
                    InkWell(
                      onTap: () {
                    // Handle 'Back' option tap
                      Navigator.pop(context);
                    },
                    child: settingsOption
                    ),
                    Positioned(
                      bottom: 0.0,
                      child: SizedBox(
                        width: 60.0,
                        height: 60.0,
                        child: IconButton(
                          onPressed: () {
                          //  _showImagePickerOptions(context);
                          },
                          icon: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.photo_camera),
                              Text(
                                'Change Photo',
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Username with speech-to-text button
                SizedBox(height: 20),
                Text('Username'),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Enter New Username',
                        ),
                      ),
                    ),
                /*    IconButton(
                      icon: Icon(Icons.mic),
                      onPressed: _startListening,
                    ), */
                  ],
                ),

                // Description
                SizedBox(height: 20),
                Text('Description'),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Write something about yourself',
                  ),
                ),

                // Email
                SizedBox(height: 20),
                Text('Email'),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter New Email',
                  ),
                ),

                // Verify Email
                SizedBox(height: 20),
                Text('Verify Email'),
                TextField(
                  controller: _verifyEmailController,
                  decoration: InputDecoration(
                    hintText: 'Enter New Email',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*                  P R O B L E M S  W I T H  F L U T T E R
  void _startListening() async {
    if (!_speech.isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('SpeechToText status: $status');
        },
        onError: (error) {
          print('SpeechToText error: $error');
        },
      );

      if (available) {
        _speech.listen(
          onResult: (result) {
            setState(() {
              _usernameController.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      _speech.stop();
    }
  }
}
*/


void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Upload Photo'),
                onTap: () {
                  // Handle upload photo
                  _handleImageUpload();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Open Camera'),
                onTap: () {
                  // Handle open camera
                  _handleOpenCamera();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Placeholder functions for handling actions
  void _handleImageUpload() {
    // Add your logic to handle image upload
    print('Upload photo selected');
  }

  void _handleOpenCamera() {
    // Add your logic to handle opening camera
    print('Open camera selected');
  }
