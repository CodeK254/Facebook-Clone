import 'package:facebook/Screens/home.dart';
import 'package:facebook/constants.dart';
import 'package:facebook/models/api_response.dart';
import 'package:facebook/models/user.dart';
import 'package:facebook/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    void _saveAndRedirectToHome(User user) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('token', user.token ?? '');
      await pref.setInt('userId', user.id ?? 0);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
    }

    void _loginUser() async {
      ApiResponse response = await loginUser(_emailController.text, _passwordController.text);
      if(response.error == null){
        _saveAndRedirectToHome(response.data as User);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text("${response.error}"),
            actions: [
              TextButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.09,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'Facebook',
          style: GoogleFonts.firaSans(
            textStyle: TextStyle(
            color: Colors.blue[900],
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            ),
          ),
        ),
        actions: [
          kNavigate(context, 'register', "Register"),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          children: [
            TextFormField(
              controller: _emailController,
              validator: ((value) => value!.isEmpty ? 'Email is required' : null),
              decoration: kInputDecoration("Email")
            ),
            SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              validator: ((value) => value!.isEmpty ? 'Password requires atleast 6 characters' : null),
              decoration: kInputDecoration('Password'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  _loginUser();
                }
              }, 
              child: kText('Login'),
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
              ),
            ),
          ],
        )
      ),
    );
  }
}