import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'homeScreen.dart';


class LoadingForSplashScreen extends StatefulWidget
{
  @override
  _LoadingForSplashScreenState createState() => _LoadingForSplashScreenState();
}

class _LoadingForSplashScreenState extends State<LoadingForSplashScreen>
{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;

  // get User authentication status here
  // it checks if user is using the app and is in database.
  Future initializeUser() async
  {
    await Firebase.initializeApp();
    final User firebaseUser = await FirebaseAuth.instance.currentUser;
    await firebaseUser.reload();
    _user = await _auth.currentUser;
  }

  navigateUser() async
  {
    // checking whether user already loggedIn or not
    if (_auth.currentUser != null)
    {
      // &&  FirebaseAuth.instance.currentUser.reload() != null
      Timer(Duration(milliseconds: 300),
            () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen(),),
                (Route<dynamic> route) => false),
        //if user is available go to home screen
      );
    }
    else
    {
      //if user is NOT  available go to Authentication of new user screen
      Timer(Duration(milliseconds: 300),
              () => Navigator.pushReplacementNamed(context, "/auth"));
    }
  }

  @override
  void initState()
  {
    super.initState();
    //2 functions called
    initializeUser();
    navigateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Turfit.',
            style: TextStyle(
              color: Colors.green[300],
              fontSize: 55,
            ),
          ),
          Text(
            'by dotdevelopingteam',
            style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16
            ),
          ),
          SizedBox(height: 40,),
          SpinKitFadingCube(
            color: Colors.green[300],
            size: 100,
            duration: Duration(seconds: 2),
          )
        ],
      ),
    );

  }
}


