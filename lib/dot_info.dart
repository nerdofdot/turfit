import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DotInfoPage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:AboutDot() ,
    );
  }
}
class AboutDot extends StatelessWidget {

  List <String> urls = ["https://www.instagram.com/dotdevelopingteam/",
    "https://www.facebook.com/Dotdevelopingteam-119380963227164","https://youtu.be/S0Dq4n6PTRc"];


  launchURL(value) async {
    if (await canLaunch(urls[value])) {
      await launch(urls[value]);
    } else {
      throw 'Could not launch ${urls[value]}';
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Center(
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/dotlogo.png',
                    height: 200.0,
                    width: 200.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,),
            Center(child: Text('Connect with DOT now!',style: TextStyle(color: Colors.grey[500],fontFamily: 'Comfortaa'),)),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Image(image: AssetImage('assets/instagramlogo.png'),color: Colors.grey[700],),
                      iconSize: 40,
                      onPressed:(){
                        launchURL(0);
                      },
                      highlightColor: Colors.deepPurple[50],
                    ),
                    IconButton(
                      icon: Image(image: AssetImage('assets/facebooklogo.png'),color: Colors.grey[700],),
                      iconSize: 40,
                      onPressed:(){
                        launchURL(1);
                      },
                      highlightColor: Colors.blue[50],
                    ),
                    IconButton(
                      icon: Image(image: AssetImage('assets/youlogo.png'),color: Colors.grey[700],),
                      iconSize: 42,
                      onPressed:(){
                        launchURL(2);
                      },
                      highlightColor: Colors.red[50],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(child: Text('Turfit by dotdevelopingteam.',style: TextStyle(color: Colors.grey[600],fontFamily: 'Comfortaa'),)),
            SizedBox(height: 60,),
            Center(child: Text('How to book a slot on Turfit?',style: TextStyle(color: Colors.grey[600],fontFamily: 'Comfortaa',fontSize: 16,fontWeight: FontWeight.w600),)),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left:40,top: 10,right: 40 ,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Step 1: Select a turf',style: TextStyle(color: Colors.grey[600],fontFamily: 'Comfortaa',fontSize: 14,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Text('Step 2: Select a date',style: TextStyle(color: Colors.grey[600],fontFamily: 'Comfortaa',fontSize: 14,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Text('Step 3: Check availability',style: TextStyle(color: Colors.grey[600],fontFamily: 'Comfortaa',fontSize: 14,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Text('Step 4: Call the turf',style: TextStyle(color: Colors.grey[600],fontFamily: 'Comfortaa',fontSize: 14,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Text('Step 5: Tell them your TURFIT ID and slot you want',style: TextStyle(color: Colors.grey[600],fontFamily: 'Comfortaa',fontSize: 14,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Text('Step 6: Pay them with UPI',style: TextStyle(color: Colors.grey[600],fontFamily: 'Comfortaa',fontSize: 14,fontWeight: FontWeight.w500),),
                  Text('(UPI QR Code is provided in turf info)',style: TextStyle(color: Colors.red[900],fontFamily: 'Comfortaa',fontSize: 13,fontWeight: FontWeight.w600),),
                  SizedBox(height: 10,),
                  Text('Step 7: Wait for confirmation',style: TextStyle(color: Colors.grey[600],fontFamily: 'Comfortaa',fontSize: 14,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Text('Step 8: Slot booked!',style: TextStyle(color: Colors.grey[600],fontFamily: 'Comfortaa',fontSize: 14,fontWeight: FontWeight.w600),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

