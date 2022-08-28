import 'dart:convert';

import 'package:facebook/models/user.dart';
import "package:facebook/services/user_services.dart";
import "package:facebook/models/post.dart";
import "package:facebook/models/api_response.dart";
import "package:http/http.dart" as http;
import "../constants.dart";
// --------- GET ALL POSTS ---------

Future<ApiResponse> getPosts() async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.get(
      Uri.parse(postsURL),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch(response.statusCode) {
      case 200:
        // apiResponse.data = jsonDecode(response.body)["posts"].map((post) => Post.fromJson(post)).toList();
        apiResponse.data = jsonDecode(response.body)["posts"];
        apiResponse.data as List<dynamic>;
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

// --------- CREATE A POST ---------

Future<ApiResponse> createPost(String caption, String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    print("Image 64 bit code: "+image.toString());
    String token = await getToken();
    print("Token found: $token");
    final response = await http.post(
      Uri.parse(postsURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: image != "" ?
      {
        "caption": caption,
        "image": image.toString(),
      } : 
      {
        "caption": caption,
      },
    );

    print("Response: ${response.statusCode}");

    switch(response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        print(apiResponse.data);
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

// --------- EDIT A POST ---------

Future<ApiResponse> editPost(int postId, String caption) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.post(
      Uri.parse("$postsURL" + "/$postId"),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body:
      {
        "caption": caption,
      },
    );

    switch(response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      case 401:
        apiResponse.error = unauthorized;
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// --------- DELETE A POST ---------

Future<ApiResponse> deletePost(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.delete(
      Uri.parse("$postsURL" + "/$postId"),
      headers: {
        'accept': 'application/json',
        "authorization": "Bearer $token",
      },
    );

    switch(response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      case 401:
        apiResponse.error = unauthorized;
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> likePost(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.post(
      Uri.parse("$postsURL" + "/$postId"+"/likes"),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("response: ${response.statusCode}");

    switch(response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      case 401:
        apiResponse.error = unauthorized;
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// --------- Get Comments -------------------

Future<ApiResponse> addComments(int id, String comment) async {
  ApiResponse apiResponse = new ApiResponse();

  try{
    String token = await getToken();

    final response = await http.post(Uri.parse("http://192.168.0.200:8000/api/posts/${id}/comments"), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
    body: {
      "comment": comment,
    });

    switch(response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body)['message'];
          break;

        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;

        case 401:
          apiResponse.error = unauthorized;
          break;

        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
  } catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}