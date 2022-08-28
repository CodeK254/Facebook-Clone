import 'package:facebook/services/user_services.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: (){
            logoutUser().then((value) => Navigator.pushReplacementNamed(context, '/login'));
          },
          child: Text('User Profile')
        ),
      ),
    );
  }
}