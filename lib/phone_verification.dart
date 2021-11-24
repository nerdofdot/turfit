import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:turfit/onboarding_screen.dart';

//global key for scaffold snackbar
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

User _user;

class PhoneAuth extends StatefulWidget
{
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth>
{

  //form key for validation of phone number in form field
  final formkey = new GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //called in init state to get current users info.
  Future getUserAuthInfo() async
  {
    _user = await _auth.currentUser;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserAuthInfo();
  }

  String phoneno,verificationID,smsCode;
  bool codeSent = false;
  //code sent is for OTP sent

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Lottie.asset("assets/phoneanim.json",repeat: true),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: EdgeInsets.fromLTRB(43, 0, 80, 15),
                  child: Text('Enter the correct OTP and press\nVERIFY button just once.',
                  style: TextStyle(
                    color: Colors.grey[600]
                  ),),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(40, 0, 80, 5),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.left,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: "Enter 10 digit Phone number",border:OutlineInputBorder(borderRadius: BorderRadius.circular(10),),),
                    onChanged: (val){
                      setState(() {
                          this.phoneno = val;
                      });
                    },
                    validator: (String value)
                    {
                      if(value.length!=10)
                        {
                          return 'Phone number should be 10 digits only.';
                        }
                      else
                        return null;
                    },
                  ),
                ),
                codeSent?Padding(
                  padding:  EdgeInsets.fromLTRB(40, 5, 80, 10),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: "Enter OTP",border:OutlineInputBorder(borderRadius: BorderRadius.circular(10),),fillColor: Colors.green),
                    onChanged: (val){
                      setState(() {
                        this.smsCode = val;
                      });
                    },
                  ),
                ):Container(),
                Padding(
                  padding: EdgeInsets.fromLTRB(45, 5, 0, 0),
                  child: Container(
                    height: 55,
                    width: 200,
                    child: RaisedButton(
                      color: Colors.grey[700],
                      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone,color: Colors.grey[400],),
                            Text('  Verify',
                            style: TextStyle(
                              color: Colors.white
                            ),),
                          ],
                        ),
                      ),
                      onPressed: ()
                      {
                        if(formkey.currentState.validate())
                        {
                          codeSent ? verifyphonewithotp(smsCode, verificationID) : verifyphone(phoneno);
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ) ,
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content:Row(
      children: [
        Icon(Icons.info_rounded),
        Text("   "+value),
      ],
    ),
    ));
  }

  void check_If_Already_Verified()async
  {
    if(_user.phoneNumber!=null)
      {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>OnBoardingPage()),
                (Route<dynamic> route) => false);
      }
    else
      {
        showInSnackBar("Check your internet or OTP!");
        Navigator.pushReplacementNamed(context, "/phonever");
      }
  }

  verifyphonewithotp(smsCode,verid) async
  {
    print('done  verifying with otp');
    AuthCredential authCredential = await PhoneAuthProvider.credential(verificationId: verid, smsCode: smsCode);
    _user.linkWithCredential(authCredential).whenComplete((){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>OnBoardingPage()),
              (Route<dynamic> route) => false);
    }).catchError((onError) async{
      print('Error occurred with otp');
      print(onError);
      check_If_Already_Verified();
    });
  }


  Future<void> verifyphone(phoneno) async
  {
    final PhoneVerificationCompleted verified = (AuthCredential authresult)
    {
      print('done verifying');
      _user.linkWithCredential(authresult).whenComplete(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => OnBoardingPage()),
                (Route<dynamic> route) => false);
      }).catchError((onError) {
        print('Error occurred without OTP');
        print(onError);
        check_If_Already_Verified();
      });
    };

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException)
    {
      print(authException);
      print('The verification has failed');
      showInSnackBar("Error. Check your internet or OTP.");
      //display snackbaar
    };

    //called when an OTP sms is sent
    final PhoneCodeSent smsSent = (String verId,[int forcedResend])
    {
        this.verificationID=verId;
        setState(() {
          this.codeSent = true;
        });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId)
    {
      this.verificationID=verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber:"+91"+phoneno.toString(),
        timeout:Duration(seconds: 90) ,
        verificationCompleted: verified,
        verificationFailed:verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout).catchError(()=>showInSnackBar("Error Occurred! Retry"));
  }
}
