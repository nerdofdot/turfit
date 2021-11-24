import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget
{
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading>
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Eager to play!',
            style: TextStyle(
              color: Colors.green[300],
              fontSize: 30,
            ),
          ),
          SizedBox(height: 15,),
          Text(
            'Setting up Turfs...',
            style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16
            ),
          ),
          SizedBox(height: 40,),
          SpinKitSquareCircle(
            color: Colors.green[300],
            size: 100,
            duration: Duration(seconds: 1),
          )
        ],
      ),
    );

  }
}