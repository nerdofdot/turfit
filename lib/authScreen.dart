import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:turfit/onboarding_screen.dart';
import 'package:turfit/phone_verification.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


//user details
String name;
String email;
String imageUrl;

User user;


final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

//this key is for Scaffold snackbar display
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


// stful wid for auth screen
class AuthScreen extends StatefulWidget
{
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  Future<User> _signIn() async
  {
    //these lines are used to sign in the user with Google Auth
    await Firebase.initializeApp();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    // final AuthResult authResult = await auth.signInWithCredential(credential);
    // final User user = authResult.user;

    user = (await auth.signInWithCredential(credential)).user;
    if (user != null) {
      name = user.displayName;
      email = user.email;
      imageUrl = user.photoURL;
    }
    return user;
  }

  //call this func for snackbar display
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content:Row(
      children: [
        Icon(Icons.info_rounded),
        Text("   "+value),
      ],
    ),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 0, 90),
              child: Text(
                  'Turfit account',
                style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 30,
                  fontFamily: 'Comfortaa'
                ),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/TurfitLogo.png',
                        height: 200.0,
                        width: 200.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 100,),
                  Container(
                    height: 55,
                    width: 200,
                    child: RaisedButton(
                      color: Colors.grey[600],//HexColor("#7ED957"),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('assets/googlelogo.png',height: 30,width: 30,),
                          Text('Create Account',style: TextStyle(color: Colors.white),)
                        ],
                      ),
                      onPressed:()
                      {
                        //call signin function
                        _signIn().whenComplete(() {
                          if(user.phoneNumber!=null)
                            {
                              print('user has phone number verified');
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>OnBoardingPage()),
                                      (Route<dynamic> route) => false);
                            }
                          else
                            {
                              print('user has phone number not verified****');
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => PhoneAuth()),
                                      (Route<dynamic> route) => false);
                            }

                        }).catchError((onError) {
                          showInSnackBar("Error occurred. Check your internet!");
                          Navigator.pushReplacementNamed(context, "/auth");
                          
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    '*Only for Nashik city.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



