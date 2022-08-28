import 'package:flutter/material.dart';

// --------STRING CONSTANTS URLS----------
import 'package:google_fonts/google_fonts.dart';

const String baseURL = "http://192.168.0.200:8000/api";
const String loginURL = baseURL + "/login";
const String registerURL = baseURL + "/register";
const String userURL = baseURL + "/user";
const String logoutURL = baseURL + "/logout";
const String postsURL = baseURL + "/posts";
// const String postURL = postsURL + "/{id}";
// const String g_and_p_commentsURL = postURL + "/comments";
const String e_and_d_commentsURL = baseURL + "/comments";

// -------- ERRORS ----------
const String serverError  = "Server error";
const String  unauthorized = "Unauthorized";
const String somethingWentWrong = "Something went wrong, try again!";


// -------- DECORATION ----------
InputDecoration kInputDecoration (String label){
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    labelText: label,
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
  );
}

// -------- BUTTONS ----------

Text kText(String label){
  return Text(
    label,
    style: GoogleFonts.firaSans(
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    ),
  );
}

// -------- ACTIONS ----------
GestureDetector kNavigate(BuildContext context, String route, String label) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/$route');
    },
    child: Container(
      margin: EdgeInsets.only(right: 10),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '$label',
          style: GoogleFonts.rancho(
            textStyle: TextStyle(
            color: Colors.brown,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            ),
          ),
        ),
      ),
    ),
  );
}