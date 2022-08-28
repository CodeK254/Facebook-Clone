import 'dart:io';
import 'package:facebook/constants.dart';
import 'package:facebook/models/api_response.dart';
import 'package:facebook/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ----------USER LOGIN----------
Future<ApiResponse> loginUser(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {'accept': 'application/json'},
      body: {
        "email": email,
        "password": password,
      },
    );

    switch(response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
        
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch(e){
    apiResponse.error = somethingWentWrong;
  }

  return apiResponse;
}

// ----------USER REGISTER----------
Future<ApiResponse> registerUser(String name, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    final response = await http.post(
      Uri.parse(registerURL),
      headers: {'accept': 'application/json'},
      body: {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": password,
      },
    );

    switch(response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
        
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch(e){
    apiResponse.error = somethingWentWrong;
  }

  return apiResponse;
}

// ----------USER Details----------
Future<ApiResponse> userDetails() async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.get(
      Uri.parse(userURL),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch(response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;

      case 401:
        apiResponse.error = unauthorized; 
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch(e){
    apiResponse.error = somethingWentWrong;
  }

  return apiResponse;
}

// ----------USER TOKEN----------
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// ----------USER TOKEN----------
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// ---------- USER lOGOUT ----------
Future<bool> logoutUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

// ---------- GET IMAGE STRING ----------
String? getStringImage(File? file){
  if(file == null) 
    return null;
  else 
    return base64Encode(file.readAsBytesSync());
}