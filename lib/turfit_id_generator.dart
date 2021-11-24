import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:turfit/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

Map<dynamic,dynamic> newTurfitID = {"turfit":0};

Future futurefotTurfitID;


class TurfitIdPage extends StatefulWidget
{
  @override
  _TurfitIdPageState createState() => _TurfitIdPageState();
}

class _TurfitIdPageState extends State<TurfitIdPage>
{
  final FirebaseAuth authnow = FirebaseAuth.instance;
  User usernow;

  final dbref_for_cloud = FirebaseFirestore.instance;
  DatabaseReference dbref_for_realTime= FirebaseDatabase.instance.reference();

  Map<String,dynamic> maptostoreuserdetails = {"details":{"name":"null","phone":"null","turfitID":"null"},"history":{
    "turfname":"null",
    "slotno":"null",
    "time":"null",
    "bookedOn":"null",
    "bookedFor":"null",
    "cost":"null",
  }};

  Map<String,dynamic> maptostoreuserdetailsforTurfs = {"name":"null","phone":"null","email":"null"};


  //uses transaction to generate turfit id
  Future<dynamic> getTurfitID()async
  {
    usernow =await authnow.currentUser;
    await FirebaseFirestore.instance.runTransaction((transaction)async
    {
      DocumentReference postRef = FirebaseFirestore.instance.collection('A').doc("counter");
      DocumentSnapshot snapshot = await transaction.get(postRef);
      newTurfitID['turfit']= snapshot.data()['count'];
      await transaction.update(postRef,{'count' : newTurfitID['turfit'] + 1});
    });


    maptostoreuserdetails['details']['name']=usernow.displayName.toString();
    maptostoreuserdetails['details']['phone']=usernow.phoneNumber.toString();
    maptostoreuserdetails['details']['turfitID']=newTurfitID['turfit'].toString();

    maptostoreuserdetailsforTurfs['name'] = usernow.displayName.toString();
    maptostoreuserdetailsforTurfs['phone'] = usernow.phoneNumber.toString();
    maptostoreuserdetailsforTurfs['email'] = usernow.email.toString();

    await dbref_for_cloud.collection("users").doc(usernow.email.toString()).set(maptostoreuserdetails);
    await dbref_for_cloud.collection("turfitId").doc(newTurfitID['turfit'].toString()).set(maptostoreuserdetailsforTurfs);


    return newTurfitID;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futurefotTurfitID = getTurfitID();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future:futurefotTurfitID ,
        builder: (context,snapshot)
        {
          if (snapshot.connectionState == ConnectionState.waiting)
            return ProgressUI();
          else if (snapshot.hasData){
            //we get a snapshot and store it in a map
            print('The values is fetched for the turfit ID');
            //map_of_TurfsDetail = snapshot.data;
            return TurfitIDUI();
          }
          else if (snapshot.hasError)
            return ErrorPageWid();
          else
            print(snapshot.data);
          return Container(color: Colors.green,);
        },
      ),
    );
  }
}

class ErrorPageWid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text('Error occurred! Re-install the app and sign in with different Google ID and Phone number.'
                '\n\nThis was due to weak/no internet connection.\n\nOr try again.\n\n\n',
            style: TextStyle(
              color: Colors.red[900],
            ),),
          ),
          Container(
            height: 55,
            width: 150,
            child: RaisedButton(
              elevation: 3,
              child: Text('Re-try',style: TextStyle(color: Colors.white),),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              color: Colors.red[900],
              onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) =>TurfitIdPage()),
                        (Route<dynamic> route) => false);
              },
            ),
          ),
        ],
      ),
    ),);
  }
}


class TurfitIDUI extends StatefulWidget {
  @override
  _TurfitIDUIState createState() => _TurfitIDUIState();
}

class _TurfitIDUIState extends State<TurfitIDUI> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width:200,
            child: Lottie.asset("assets/turfitani.json",repeat: true),
          ),
          Text(
            'Your permanent Turfit ID is:',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Comfortaa'
            ),
          ),
          SizedBox(height: 5,),
          Text(
            '${newTurfitID['turfit']}',
            style: TextStyle(
              color: Colors.green[400],
              fontSize: 40,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Use turfit ID while booking!',
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Comfortaa'
            ),
          ),
          SizedBox(height: 20,),
          Container(
            height: 55,
            width: 150,
            child: RaisedButton(
              elevation: 3,
              child: Text('Lets go!',style: TextStyle(color: Colors.white),),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              color: Colors.green,
              onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) =>HomeScreen()),
                        (Route<dynamic> route) => false);
              },
            ),
          )
        ],
      ),
    );
  }
}

class ProgressUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWanderingCubes(
        color: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }
}






