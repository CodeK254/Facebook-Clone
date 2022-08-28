import 'dart:io';

import 'package:facebook/constants.dart';
import 'package:facebook/models/api_response.dart';
import 'package:facebook/services/post_service.dart';
import 'package:facebook/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  TextEditingController _caption = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
    // Pick an image
  _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

   _createPost() async {
    String? image = _imageFile != null ? getStringImage(_imageFile) : null;
    ApiResponse response = await createPost(_caption.text, image);

    if (response.error == null) {
      Fluttertoast.showToast(
        msg: "Post created successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
      );
      Navigator.pushReplacementNamed(context, "/home");
    } else if(response.error == unauthorized){
      logoutUser().then((value) => Navigator.pushReplacementNamed(context, "/login"));
    }
    else {
      print(response.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
        title: Text(
          'Create post',
          style: GoogleFonts.playfairDisplay(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: GestureDetector(
              onTap: () async {
                await _createPost();
                Navigator.pushReplacementNamed(context, "/home");
              },
              child: Text(
                'POST',
                style: GoogleFonts.firaSans(
                  textStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            )
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/logo2.png'),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Username Here',
                    style: GoogleFonts.firaSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03, vertical: MediaQuery.of(context).size.height * 0.005),
                    color: Colors.blueGrey[50],
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.black,
                          size: 15,
                        ),
                        Text(
                          'Public',
                          style: GoogleFonts.rancho(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            color: Colors.blueGrey[50],
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Caption is required';
                }
                return null;
              },
              controller: _caption,
              maxLines: 10,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                // labelText: 'Caption',
                hintText: 'What is on your mind?',
                hintStyle: GoogleFonts.firaSans(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                labelStyle: GoogleFonts.firaSans(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    letterSpacing: 2,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.card_giftcard,
                  color: Colors.yellow,
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Text(
                    'Add or remove photos',
                    style: GoogleFonts.firaSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // image: DecorationImage(
              //   image: _image != null ? FileImage(_image!) ,
              //   fit: BoxFit.cover,
              // ),
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: _imageFile != null ? Image.file(_imageFile!, fit: BoxFit.cover) : Text('No image selected'),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              if(_formKey.currentState!.validate()) {
                await _createPost();
                Navigator.pop(context);
              }
            }, 
            child: Text(
              'POST',
              style: GoogleFonts.firaSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}