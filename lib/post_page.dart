import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:turfit/get_turf_info.dart';
import 'package:url_launcher/url_launcher.dart';

class PostPage3 extends StatefulWidget
{
  @override
  _PostPage3State createState() => _PostPage3State();
}

Future futureforposts;
GetInfoForTurf getInfoForTurf = GetInfoForTurf();
Map<dynamic,dynamic> postDetailsinmap ;

class _PostPage3State extends State<PostPage3> {


  bool checkIfNull()
  {
    if(postDetailsinmap == null)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureforposts = getInfoForTurf.getPosts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: futureforposts,
        builder: (context,snapshot)
        {
          if (snapshot.connectionState == ConnectionState.waiting)
            return LoadingPosts();
          else if (snapshot.hasData){
            //we get a snapshot and store it in a map
            print('Data of post fetched from Real time DB');
            postDetailsinmap = snapshot.data;
            print(postDetailsinmap);
            return checkIfNull()?NoEvents():ListViewForPosts();
          }
          else if (snapshot.hasError)
            return ErrorPagePost();
          else
            print(snapshot.data);
          return NoEvents();
        },
      )
    );
  }
}

class ErrorPagePost extends StatelessWidget {
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

class NoEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No upcoming events....',style: TextStyle(color: Colors.grey,),),
          SpinKitChasingDots(
            color: Colors.green[200],
            duration: Duration(seconds: 3),
          ),
        ],
      ),
    );
  }
}


class ListViewForPosts extends StatefulWidget {
  @override
  _ListViewForPostsState createState() => _ListViewForPostsState();
}

class _ListViewForPostsState extends State<ListViewForPosts>
{

  bool checkIfNull()
  {
    if(postDetailsinmap == null)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10,0, 5),
          child: Text('Turf feed',
          style: TextStyle(
              color: Colors.grey,
              fontFamily: 'Comfortaa',
              fontSize: 20
          ),)

        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: checkIfNull()?0:postDetailsinmap.length,
            itemBuilder: (context,index)
            {
              return CardForPosts(index: index,);
            },
          ),
        ),
      ],
    );
  }
}

class CardForPosts extends StatelessWidget {
  final int index;
  CardForPosts({this.index});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 5, 12, 0),
      child: Card(
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(padding: EdgeInsets.all(15),child:TextInfoForPostsInCard(index: index,) ,),
      ),
    );
  }
}

class TextInfoForPostsInCard extends StatelessWidget
{
  final int index;
  TextInfoForPostsInCard({this.index});

  _launchCaller(String url) async
  {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Row(
          children: [
            Text(
              'Turf Name:      ',
              style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 16,
                  fontFamily: 'Comfortaa',
                  fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10,bottom: 0),
              child: Text(
                postDetailsinmap['post${index+1}']['turfName'].toString(),
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: 16,
                    fontFamily: 'Comfortaa',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            Text(
                'Tournament:   ',
              style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 16,
                  fontFamily: 'Comfortaa',
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Padding(
                padding:  const EdgeInsets.only(left: 10,bottom: 0),
                child: Text(
                  postDetailsinmap['post${index+1}']['tour'].toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.brown,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Comfortaa'
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            Text(
                'Sport:              ',
              style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 16,
                  fontFamily: 'Comfortaa',
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding:  const EdgeInsets.only(left: 10,bottom: 0),
              child: Text(
                postDetailsinmap['post${index+1}']['sport'].toString(),
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: 16,
                    fontFamily: 'Comfortaa'
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            Text(
                'Date:                ',
              style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 16,
                  fontFamily: 'Comfortaa',
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding:  const EdgeInsets.only(left: 9,bottom: 0),
              child: Text(
                postDetailsinmap['post${index+1}']['date'].toString(),
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: 16,
                    fontFamily: 'Comfortaa'
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
          child: Image.asset("assets/wreath.png",height: 60,width: 60,),
        ),
        Row(
          children: [
            Text(
                'Entry fee:        ',
              style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 16,
                  fontFamily: 'Comfortaa',
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding:  const EdgeInsets.only(left: 10,bottom: 0),
              child: Text(
                postDetailsinmap['post${index+1}']['fee'].toString(),
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: 16,
                    fontFamily: 'Comfortaa'
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10,),

        Row(
          children: [
            Text(
                'Winning Price:',
              style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 16,
                  fontFamily: 'Comfortaa',
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Padding(
                padding:  const EdgeInsets.only(left: 9,bottom: 0),
                child: Text(
                  postDetailsinmap['post${index+1}']['price'].toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.brown,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Comfortaa'
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20,),

        FlatButton.icon(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          icon: Icon(Icons.call,size: 20,color: Colors.green,),
          highlightColor: Colors.green[100],
          onPressed:(){
            _launchCaller("tel: "+ postDetailsinmap['post${index+1}']['contact'].toString());
          } ,
          label: Text('CONTACT',style: TextStyle(color: Colors.green[800]),),
        )
      ],
    );
  }
}

class LoadingPosts extends StatelessWidget {
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




