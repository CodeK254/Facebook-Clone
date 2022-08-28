import 'package:facebook/Screens/home.dart';
import 'package:facebook/constants.dart';
import 'package:facebook/models/api_response.dart';
import 'package:facebook/models/user.dart';
import 'package:facebook/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;

  TextEditingController 
    _emailController = TextEditingController(),
    _passwordController = TextEditingController(),
    _confirmPasswordController = TextEditingController(),
    _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    void _saveAndRedirectToHome(User user) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('token', user.token ?? '');
      await pref.setInt('userId', user.id ?? 0);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
    }

    void _registerUser() async {
      ApiResponse response = await registerUser(_nameController.text, _emailController.text, _passwordController.text);
      if(response.error == null){
        _saveAndRedirectToHome(response.data as User);
      } else {
        setState(() {
          loading = !loading;
        });
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
          kNavigate(context, 'login', 'Login'),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          children: [
            TextFormField(
              controller: _nameController,
              validator: ((value) => value!.isEmpty ? 'Username is required' : null),
              decoration: kInputDecoration("Name")
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.visiblePassword,
              validator: ((value) => value!.isEmpty ? 'Email is required' : null),
              decoration: kInputDecoration('Email'),
            ),
            SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              controller: _passwordController,
              validator: ((value) => value!.isEmpty ? 'Password requires atleast 6 characters' : null),
              decoration: kInputDecoration("Password")
            ),
            SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              controller: _confirmPasswordController,
              keyboardType: TextInputType.visiblePassword,
              validator: ((value) => value != _passwordController.text ? 'Confirmation Password does not match' : null),
              decoration: kInputDecoration('Confirm Password'),
            ),
            SizedBox(height: 20),
            loading ?
              Center(
                child: CircularProgressIndicator(
                  color: Colors.blue[900],
                  backgroundColor: Colors.white,
                ),
              ) 
            : TextButton(
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  setState(() {
                    loading = !loading;
                  });
                  _registerUser();
                }
              }, 
              child: kText('Register'),
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