import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:turfit/get_turf_info.dart';
import 'package:turfit/turfit_id_generator.dart';

bool regenerated = false;

class ListForHistoryOfTurfBooking extends StatefulWidget {
  @override
  _ListForHistoryOfTurfBookingState createState() => _ListForHistoryOfTurfBookingState();
}
Future<dynamic> futureForConfiramtionStatus;
Map<dynamic,dynamic> confirmationStatusmap;
GetInfoForTurf getInfoForTurf = GetInfoForTurf();


class _ListForHistoryOfTurfBookingState extends State<ListForHistoryOfTurfBooking>
{

  getConfirmation()async
  {
    futureForConfiramtionStatus = regenerated?getInfoForTurf.getConfirmationStatusRegen():getInfoForTurf.getConfirmationStatus();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConfirmation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: futureForConfiramtionStatus,
        builder: (context,snapshot)
        {
          if (snapshot.connectionState == ConnectionState.waiting)
            return ProgressUI();
          else if (snapshot.hasData){
            //we get a snapshot and store it in a map
            print('Confirmation status received from FireStore');
            confirmationStatusmap = snapshot.data;
            print(confirmationStatusmap);
            return ConfirmationUI();
          }
          else if (snapshot.hasError)
            return ErrorPageStatus();
          else
            print(snapshot.data);
          return ReGenerateTurfitIDUI();
        },
      )
    );
  }
}

class ErrorPageStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Error Occurred!\nCheck your internet connection.',
          style: TextStyle(
            color: Colors.red[900],
          ),),
      ),
    );
  }
}

class ConfirmationUI extends StatefulWidget {
  @override
  _ConfirmationUIState createState() => _ConfirmationUIState();
}

class _ConfirmationUIState extends State<ConfirmationUI> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
          child: Text(
            'Confirmation Status',
            style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Comfortaa',
                fontSize: 20
            ) ,
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(12, 5, 12, 0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 5,
            child: ConfirmationInfo(),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(12, 5, 12, 0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 5,
            child: TurfIdUi(),
          ),
        ),
      ],
    );
  }
}




class ConfirmationInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Turf Name',
            style: TextStyle(
                color: Colors.green[700],
                fontSize: 18,
                fontFamily: 'Comfortaa'
            ),
          ),
          Text(
              '${confirmationStatusmap['history']['turfname']}'
          ),
          SizedBox(height: 10,),
          Text(
            'Booked on:',
            style: TextStyle(
                color: Colors.green[700],
                fontSize: 18,
                fontFamily: 'Comfortaa'
            ),
          ),
          Text(
              '${confirmationStatusmap['history']['bookedOn']}'
          ),
          SizedBox(height: 10,),
          Text(
            'Booked for:',
            style: TextStyle(
                color: Colors.green[700],
                fontSize: 18,
                fontFamily: 'Comfortaa'
            ),
          ),
          Text(
              '${confirmationStatusmap['history']['bookedFor']}'
          ),
          SizedBox(height: 10,),
          Text(
            'Timing:',
            style: TextStyle(
                color: Colors.green[700],
                fontSize: 18,
                fontFamily: 'Comfortaa'
            ),
          ),
          Text(
              '${confirmationStatusmap['history']['time']}'
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}

class TurfIdUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your permanent Turfit id:',
            style: TextStyle(
                color: Colors.green[700],
                fontSize: 18,
                fontFamily: 'Comfortaa'
            ),
          ),
          Text(
              '${confirmationStatusmap['details']['turfitID']}',
            style: TextStyle(
              color: Colors.red[800],
              fontSize: 19
            ),
          ),
          SizedBox(height: 10,),
          Text(
            'Donot Share this id.\n\nYou can book many Turf slots but you will only see the Confirmation status for the latest Turf slot booked.\n\n'+
                'Even if you have booked 2 slots only one will show up!\n\nCancellation status is not shown',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13
            ),
          ),
        ],
      ),
    );
  }
}

class ReGenerateTurfitIDUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('Sorry! Your Turfit ID was not created.\nThis ID is very important to book a turf slot.\n\nTap to re-generate the ID!',textAlign: TextAlign.center,),
            ),
            Container(
              height: 55,
              width: 175,
              child: RaisedButton(
                elevation: 3,
                child: Text('Re-create Turfit ID',style: TextStyle(color: Colors.white),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                color: Colors.red[900],
                onPressed: (){
                  regenerated = true;
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>TurfitIdPage()),
                          (Route<dynamic> route) => false);
                },
              ),
            )
          ],
        ),
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




