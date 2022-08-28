import 'package:facebook/Screens/home.dart';
import 'package:facebook/Screens/login.dart';
import 'package:facebook/constants.dart';
import 'package:facebook/models/api_response.dart';
import 'package:facebook/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Loading extends StatefulWidget {
  const Loading({ Key? key }) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void _loadUserInfo() async {
    print('Loading user info');
    String token = await getToken();
    if(token == '') {
      print('No token found');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
    } else {
      print(token);
      ApiResponse response = await userDetails();
      if(response.error == null){
        print('User info loaded');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
      }
      else if(response.error == unauthorized){
        print(response.error);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
      }
      else{
        print('An error occurred while processing');
        Fluttertoast.showToast(msg: "An error occurred while processing");
      }
    }
  }

  @override

  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.15,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/logo2.png'),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                SizedBox(height: 5),
                LinearProgressIndicator(
                  color: Colors.blue,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}