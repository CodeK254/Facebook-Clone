import 'package:facebook/Screens/home.dart';
import 'package:facebook/Screens/loading.dart';
import 'package:facebook/Screens/login.dart';
import 'package:facebook/Screens/post_input.dart';
import 'package:facebook/Screens/profile.dart';
import 'package:facebook/Screens/register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => HomeScreen(),
        '/upload': (context) => UploadScreen(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/profile': (context) => UserProfile(),
      },
    ),
  );
}