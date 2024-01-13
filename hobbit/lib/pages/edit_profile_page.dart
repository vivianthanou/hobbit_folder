import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:typed_data';
import 'package:provider/provider.dart';


class EditProfilePage extends StatefulWidget {
  //, required this.onDone
 // final Function(String) onDone;
  final int id;
  EditProfilePage({Key? key, required this.id}) : super(key: key);
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();

}

class _EditProfilePageState extends State<EditProfilePage> {

  //String _userProfileImage = 'https://placekitten.com/300/300';
  String? _selectedOption;
  stt.SpeechToText _speech = stt.SpeechToText();
  Uint8List? _image;
  bool _isListening = false;
  

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
  
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  Widget build(BuildContext context) {
    final  profileData = Provider.of<ProfileData>(context, listen: false);
  _image ??= profileData.profileImage;
  _usernameController ??= TextEditingController(text: profileData.username );
  _descriptionController ??= TextEditingController(text: profileData.description);

      return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FocusScope(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User Profile Image and Change Photo button
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Center(
                        child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        const Color.fromARGB(255, 242, 238, 238).withOpacity(0.5), // Adjust the opacity value (0.0 to 1.0)
                        BlendMode.srcATop,
                      ),
                      child: 
                      CircleAvatar(
                      radius: 60,
                      backgroundImage: 
                      _image != null ? 
                      MemoryImage(_image!) 
                      : const NetworkImage('https://placekitten.com/300/300')as ImageProvider<Object>,
                      )
                      //  _image != null ?
                      //    CircleAvatar(
                      //   radius:60,
                      //    backgroundImage: MemoryImage(_image!),
                      //    )
                      //    :
                      //   const CircleAvatar(
                      //   radius: 60,
                      //   backgroundImage: NetworkImage('https://placekitten.com/300/300'),
                      //  ),
                    ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 60.0,
                          height: 100.0,
                          child: IconButton(
                            onPressed: () {
                              _showImagePickerOptions(context);
                            },
                            icon: const  Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.photo_camera),
                                Text(
                                  'Change Photo',
                                  style: TextStyle(fontSize: 8.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        child: const Text("Cancel"),
                        onPressed:() {
                          Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProfilePage(id: widget.id),
                          ),
                        );
                      },
                    ),
                    ],
                  ),
              
                  // Username with speech-to-text button
                const SizedBox(height: 20),
                 const  Text('Username'),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter New Username',
                          ),
                          // Disable the text field when speech recognition is active
                          enabled: !_isListening,
                        ),
                      ),
                      IconButton(
                        icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                        onPressed: () {
                          // Toggle speech recognition
                          _toggleListening();
                        },
                      ),
                    ],
                  ),
              
                  // Description
                  const SizedBox(height: 20),
                  const Text('Description'),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Write something about yourself',
                    ),
                  ),
              
                 
                  
                //Add A New Interest
                const SizedBox(height: 20),
                const Text('Add a New Interest'),
                DropdownButton<String>(
                  value: _selectedOption,
                  onChanged: (String? newValue) { 
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
                Center(
                  child: ElevatedButton(
                    child: const Text("Done"),
                     onPressed: () {
                     // Pass the updated username back to the previous page
                   // final profileData = Provider.of<ProfileData>(context, listen: false);
                    if(_usernameController.text!='') profileData.updateUsername(_usernameController.text, widget.id);
                    if(_descriptionController.text!='') profileData.updatedDescription(_descriptionController.text, widget.id);
                    if(_image!=null) profileData.updateProfileImage(_image!, widget.id);
                    if(_selectedOption!=null) profileData.updateInterests(_selectedOption!, widget.id);
                 
                    Navigator.pop(context);
                    Navigator.pop(context);
                    },
                    //   onPressed:() {
                    //     widget.onDone(_usernameController.text);
                    //     print(_usernameController.text);
                    //     Navigator.push(context, MaterialPageRoute(
                    //     builder: (context) => ProfilePage(),
                    //     ),
                    //   );
                    // },
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    
  }

  // Function to show the options to change profile photo
  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return 
          Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Upload Photo'),
                onTap: () {
                  // Handle upload photo
                  _handleImageUpload();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Open Camera'),
                onTap: () {
                  // Handle open camera
                  _handleOpenCamera();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        
      },
    );
  }

 void _toggleListening() {
    if (_isListening) {
      // Stop speech recognition
      _speech.stop();
    } else {
      // Start speech recognition
      _startListening();
    }

    // Toggle the listening state
    setState(() {
      _isListening = !_isListening;
    });
  }

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
    }
  }
  
void _handleImageUpload() async {
  
  final ImagePicker _picker = ImagePicker();
  final XFile? returnedImage = await _picker.pickImage(source: ImageSource.gallery);
  
  if (returnedImage != null) {
    Uint8List imageBytes = await returnedImage.readAsBytes();
    setState(() {
      _image = imageBytes;
    });
  }
  }
  
  void _handleOpenCamera() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? returnedImage = await _picker.pickImage(source: ImageSource.camera);
  
  if (returnedImage != null) {
    Uint8List imageBytes = await returnedImage.readAsBytes();
    setState(() {
      _image = imageBytes;
    });
  }
}
}