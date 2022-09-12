import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../components/rounded_button.dart';
import '../constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  // User user;
  String email;
  String password;
  String error = '';
  String newError = '';
  bool showSpinner = false;
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // This is the ending point of the Hero Widget.
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: showPassword,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              TextButton(
                onPressed: () {
                  if (showPassword == true) {
                    setState(() {
                      showPassword = false;
                    });
                  }
                  else {
                    setState(() {
                      showPassword = true;
                    });
                  }
                }, child: Text('Show password'),
              ),
              SizedBox(
                height: 10.0,
              ),
              RoundedButton(
                onTap: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final loggedInUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (loggedInUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                    error = '';
                    newError = '';
                  } catch (e) {
                    setState(() {
                      error = e.toString().split(' ')[0].split('/')[1];
                      newError = '[$error';
                      showSpinner = false;
                    });
                  }
                },
                color: Colors.lightBlueAccent,
                ButtonText: 'Log in',
              ),
              SizedBox(height: 15),
              Center(child: Text(newError, style: kErrorMessage,)),
            ],
          ),
        ),
      ),
    );
  }
}
