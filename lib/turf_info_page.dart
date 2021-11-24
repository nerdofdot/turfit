import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class TurfInfoPage extends StatelessWidget {


  Map<dynamic,dynamic> selected_turf_info;

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch ${url}';
    }
  }




  @override
  Widget build(BuildContext context) {
    
    selected_turf_info = ModalRoute.of(context).settings.arguments;
    print(selected_turf_info);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 15,
        automaticallyImplyLeading: true,
        toolbarHeight: 100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.zero,topRight: Radius.zero,bottomLeft: Radius.zero,bottomRight: Radius.circular(200))),
        title: Text(
          selected_turf_info['map']['name'].toString(),
          style: TextStyle(
              color: Colors.green[100],
              fontSize: 35
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8,top: 25),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                      color: Colors.green[300],
                      child:ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network("https://drive.google.com/uc?export=view&id="+selected_turf_info['map']['image'],
                          loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: SpinKitChasingDots(
                                color: Colors.green[400],
                                size: 150,
                              ),
                            );
                          },),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Image.asset("assets/instagramlogo.png",color: Colors.white,height: 30,width: 30,),
                              highlightColor: Colors.white,
                              onPressed: (){
                                launchURL("https://www.instagram.com/"+selected_turf_info['map']['insta']+"/");
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.phone,size: 32,color: Colors.white,),
                              highlightColor: Colors.white,
                              onPressed: (){
                                launchURL("tel:"+selected_turf_info['map']['phone']['number1'].toString());
                              },
                            )
                          ],
                        ),
                        Text(
                          selected_turf_info['map']['address'].toString(),
                          style: TextStyle(color: Colors.white,),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30,bottom: 0),
              child: Text('For more info visit instagram or call them!',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontFamily: 'Comfortaa'
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5,bottom: 0),
              child: Text('Use Turfit and book '+selected_turf_info['map']['name']+" like a pro!",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontFamily: 'Comfortaa'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45,bottom: 0),
              child: Text('Pay with UPI by scanning the QR.',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontFamily: 'Comfortaa'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5,bottom: 10),
              child: Text('Scroll down to see it completely.',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontFamily: 'Comfortaa'
                ),
              ),
            ),
            Container(
              height: 300,
              width: 300,
              child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network("https://drive.google.com/uc?export=view&id="+selected_turf_info['map']['upi'],
                      loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SpinKitChasingDots(
                            color: Colors.red[400],
                            size: 150,
                          ),
                        );
                      },),
                  )
              ),
            ),
            Container(
              height: 300,
              width: 300,
              child: Lottie.asset("assets/socialmediaani.json",reverse: true),
            )

          ],
        ),
      ),
    );
  }
}
