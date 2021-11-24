import 'package:flutter/material.dart';
import 'package:turfit/dot_info.dart';
import 'package:turfit/loading.dart';
import 'package:turfit/post_page.dart';
import 'firebase_notification_handler.dart';
import 'get_turf_info.dart';
import 'user_history.dart';
import 'package:navigation_dot_bar/navigation_dot_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ToApp();
  }
}

class ToApp extends StatefulWidget {
  @override
  _ToAppState createState() => _ToAppState();
}


Map<dynamic,dynamic> map_of_TurfsDetail;

// this class has a future builder based on values returned from the DB about turf info
// the data is stored in Firebase real time
class _ToAppState extends State<ToApp> {
  Future<dynamic> future_for_turf_info;
  GetInfoForTurf getInfoForTurf = GetInfoForTurf();

  void getInfoNow() async
  {

    future_for_turf_info = getInfoForTurf.fetch_Turf_info();
    //await Future.delayed(Duration(seconds: 1));
    await new FirebaseNotifications().setUpFirebase();
  }



  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    getInfoNow();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:future_for_turf_info,
      builder: (context,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting)
          return Loading();
        else if (snapshot.hasData){
          //we get a snapshot and store it in a map
          print('Data recieved in future builder for turf info from real time DB');
          map_of_TurfsDetail = snapshot.data;
          return TurfsListOnMainPageUI();
        }
        else if (snapshot.hasError)
          return ErrorPageHome();
        else
          print(snapshot.data);
        return ErrorPageHome();
      },
    );
  }
}

class ErrorPageHome extends StatelessWidget {
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



//this is the whole main page
class TurfsListOnMainPageUI extends StatefulWidget {
  @override
  _TurfsListOnMainPageUIState createState() => _TurfsListOnMainPageUIState();
}

class _TurfsListOnMainPageUIState extends State<TurfsListOnMainPageUI>
{

  List widget_List =[ListViewForTurfName(),ListForHistoryOfTurfBooking(),PostPage3(),DotInfoPage4()];
  int _currentindex =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[400],
          elevation: 15,
          automaticallyImplyLeading: true,
          toolbarHeight: 100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.zero,topRight: Radius.zero,bottomLeft: Radius.zero,bottomRight: Radius.circular(200))),
          title: Text(
            'Turfit.',
            style: TextStyle(
                color: Colors.green[100],
                fontSize: 45
            ),
          ),
        ),
        body: widget_List[_currentindex],
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8),
          child: BottomNavigationDotBar(
            activeColor: Colors.green,
            color: Colors.green[200],
            items: [BottomNavigationDotBarItem(icon: Icons.list_alt_rounded, onTap: () {
              setState(() {
                _currentindex = 0;
              });
            }),
              BottomNavigationDotBarItem(icon: Icons.person_outline_rounded, onTap: () {
                setState(() {
                  _currentindex = 1;
                });
              }),
              BottomNavigationDotBarItem(icon: Icons.star_border_rounded, onTap: () {
                setState(() {
                  _currentindex = 2;
                });
              }),
              BottomNavigationDotBarItem(icon: Icons.info_outline, onTap: () {
                setState(() {
                  _currentindex = 3;
                });
              }),],

          ),
        )
    );
  }
}

//this is puerly list view
class ListViewForTurfName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: map_of_TurfsDetail.length,
            shrinkWrap: true,
            itemBuilder: (context,index)
            {
              return CardViewForEachTurf(index: index,);
            },
          ),)
      ],
    );
  }
}

class CardViewForEachTurf extends StatelessWidget {

  int index;

  CardViewForEachTurf({this.index});

  //this function returns the color of card in card with slots left
  colorOfTheSlotLeftBox(number)
  {
    if(number%3==0)
    {
      return Colors.lightGreen[600];
    }
    else if(number%3==1)
    {
      return Colors.lightGreen[400];
    }
    else
      return Colors.lightGreen[500];
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.fromLTRB(12, 5, 12, 0),
      child: Card(
          color: map_of_TurfsDetail['turf'+'${index+1}']['access']?(map_of_TurfsDetail['turf'+'${index+1}']['open']?Colors.white:Colors.grey[300]):Colors.grey[300],
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          child: ListTile(
            onTap: (){
              Navigator.pushNamed(context, "/slotsui",arguments: {'map':map_of_TurfsDetail['turf'+'${index+1}'],});
            },
            enabled: map_of_TurfsDetail['turf'+'${index+1}']['access']?(map_of_TurfsDetail['turf'+'${index+1}']['open']?true:false):false,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: TextInfoForListTileUI(index: index,),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.info_rounded),
                            iconSize: 33,
                            color: Colors.lightGreen[500],
                            highlightColor:Colors.lightGreen[100],
                            onPressed: (){
                              Navigator.pushNamed(context, "/turfinfo",arguments: {'map':map_of_TurfsDetail['turf'+'${index+1}'],});
                            },
                          ),
                          Text('Turf\'s info',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),)
                        ],
                      )
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}

class TextInfoForListTileUI extends StatelessWidget {
  final int index;

  TextInfoForListTileUI({this.index});



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          map_of_TurfsDetail['turf'+'${index+1}']['name'],
          style: TextStyle(
            color: map_of_TurfsDetail['turf'+'${index+1}']['access']?(map_of_TurfsDetail['turf'+'${index+1}']['open']?Colors.green[700]:Colors.grey[500]):Colors.grey[500],
            fontWeight: FontWeight.w600,
            fontSize: 19,
            fontFamily: 'Comfortaa',
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(3, 7, 120, 7),
            child: Text(
              map_of_TurfsDetail['turf'+'${index+1}']['address'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(3, 2, 0, 10),
            child: RichText(
              text: TextSpan(
                  children: [
                    TextSpan(text: map_of_TurfsDetail['turf'+'${index+1}']['advance'].toString()+"%",style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.w600,fontSize: 18) ),
                    TextSpan(text:" advance payment.",style:TextStyle(color: Colors.grey[800],fontSize: 16,fontWeight: FontWeight.w300,))
                  ]
              ),
            )
        ),
      ],
    );
  }
}
