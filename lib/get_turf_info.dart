import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:turfit/user_history.dart';



class GetInfoForTurf
{
  final dbref_for_cloud = FirebaseFirestore.instance;
  DatabaseReference dbref_for_realTime= FirebaseDatabase.instance.reference();

  final FirebaseDatabase database = FirebaseDatabase();

  //stores complete info of static FB database in map
  Map<dynamic,dynamic> fetchinfoofturfinmap;
  //stores data for specific turfs in a map
  Map<dynamic,dynamic> selectecTurfInfoinMap;


  Map<dynamic,dynamic> cofirmationStatusDetails;

  Map<dynamic,dynamic> postDetails ;



  final AsyncMemoizer _memoizer = AsyncMemoizer();

  // Map<String,dynamic> slotsinfo =
  // {
  //   "slot17":{
  //     "start_time":22,
  //     "end_time":23,
  //     "name":"null",
  //     "phone":"null",
  //     "isBooked":false,
  //     "isDisabled":false,
  //     "date":" ",
  //   }
  // };



  Future<dynamic> fetch_Turf_info() {
    return this._memoizer.runOnce(() async
    {
      //await dbref_for_realTime.reference().child("aturfs/turf12/pattern").update(slotsinfo);
      ///////////////////////
      database.setPersistenceEnabled(false);
      //reading all the turfs from FB This value is constant
      fetchinfoofturfinmap = await database.reference().child("aturfs").once().then((value) => value.value);
      print('Data fetched from real time DB in memoizer*************************call back');
      await Future.delayed(Duration(milliseconds: 300));
      return fetchinfoofturfinmap;
    });
  }


  Future<dynamic> fetch_Selected_Turf_Info(String turfName,String yearMonth) async
  {
    Map<dynamic,dynamic> fetchInfoOfDates = await dbref_for_cloud.collection(turfName).doc(yearMonth).get().then((value) => value.data());
    print('call back***************************************callback++++++++++++++++++++++');
    return fetchInfoOfDates;
  }



  Future<dynamic> getConfirmationStatus() async
  {
    return this._memoizer.runOnce(() async {
      //database.setPersistenceEnabled(false);
      final FirebaseAuth authnow = FirebaseAuth.instance;
      User usernow;
      usernow = await authnow.currentUser;
      cofirmationStatusDetails = await dbref_for_cloud.collection("users").doc(usernow.email.toString()).get().then((value) => value.data());
      await Future.delayed(Duration(milliseconds: 300));
      print('callback********************confirmation status*****************');
      return cofirmationStatusDetails;
    });
  }

  Future<dynamic> getConfirmationStatusRegen() async
  {
      //database.setPersistenceEnabled(false);
      final FirebaseAuth authnow = FirebaseAuth.instance;
      User usernow;
      usernow = await authnow.currentUser;
      cofirmationStatusDetails = await dbref_for_cloud.collection("users").doc(usernow.email.toString()).get().then((value) => value.data());
      await Future.delayed(Duration(milliseconds: 300));
      print('callback********************confirmation status regen*****************');
      return cofirmationStatusDetails;
  }



  Future<dynamic> getPosts () async
  {
    return this._memoizer.runOnce(() async {
      database.setPersistenceEnabled(false);
      postDetails = await database.reference().child("posts").once().then((value) => value.value);
      await Future.delayed(Duration(milliseconds: 300));
      return postDetails;
    });
  }



}