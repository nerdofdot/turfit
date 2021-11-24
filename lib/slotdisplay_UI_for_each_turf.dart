import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:turfit/get_turf_info.dart';
import 'package:url_launcher/url_launcher.dart';

Map selected_turf_details;
Map<dynamic,dynamic> fetched_info_of_selected_turf;
GetInfoForTurf getInfoForTurf = GetInfoForTurf();
DateTime selectedDate = DateTime.now();
Future futureforselectedTurfDate;
int prevMonth;

class ListForSlotsofTurf extends StatefulWidget {
  @override
  _ListForSlotsofTurfState createState() => _ListForSlotsofTurfState();
}

void getSelectedTurfInfo()async
{
  //pass year month day
  futureforselectedTurfDate= getInfoForTurf.fetch_Selected_Turf_Info(selected_turf_details['map']['name'],"${selectedDate.year} ${selectedDate.month}");
}


class _ListForSlotsofTurfState extends State<ListForSlotsofTurf> {



  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    //calling function on top
    //this function return dates for a turf from FS
  }

  @override
  Widget build(BuildContext context)
  {
    // Recives map from the main screen Turf page
    //map contains info of only one turf
    //use 'map'
    selected_turf_details = ModalRoute.of(context).settings.arguments;
    print(selected_turf_details);

    getSelectedTurfInfo();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 15,
        automaticallyImplyLeading: true,
        toolbarHeight: 100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.zero,topRight: Radius.zero,bottomLeft: Radius.zero,bottomRight: Radius.circular(200))),
        title: Text(
          '${selected_turf_details['map']['name']}',
          style: TextStyle(
              color: Colors.green[100],
              fontSize: 29,
          ),
        ),
      ),
      body: SlotsListViewForAParticularTurf(),
    );
  }
}

class SlotsListViewForAParticularTurf extends StatefulWidget {
  @override
  _SlotsListViewForAParticularTurfState createState() => _SlotsListViewForAParticularTurfState();
}

class _SlotsListViewForAParticularTurfState extends State<SlotsListViewForAParticularTurf> {

  DateTime dateToday = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prevMonth = dateToday.month;
  }

  Future<void> _selectDate(BuildContext context) async {

    final DateTime picked = await showDatePicker(
        context: context,
        helpText: 'SELECT A DATE TO BOOK A TURF SLOT!',
        fieldLabelText: 'Your slot is waiting!',
        initialDate: selectedDate,
        firstDate: DateTime(dateToday.year, dateToday.month,dateToday.day),
        lastDate: DateTime(dateToday.year,dateToday.month,dateToday.day).add(Duration(days: 14)));

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        if(selectedDate.month!=prevMonth)
        {
          print(prevMonth);
          prevMonth = selectedDate.month;
          print(prevMonth);
          futureforselectedTurfDate= getInfoForTurf.fetch_Selected_Turf_Info(selected_turf_details['map']['name'],"${selectedDate.year} ${selectedDate.month}");
        }

      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: FlatButton.icon(
                    icon: Icon(Icons.calendar_today_rounded,color: Colors.grey[800],),
                    onPressed: (){
                      _selectDate(context);
                    },
                    label: Text('Tap to select date.',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    highlightColor: Colors.green[100],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
              child: Text("${selectedDate.toLocal().day}"+"/"+"${selectedDate.toLocal().month}"+"/"+"${selectedDate.toLocal().year}",
                style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 23,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder(
            future: futureforselectedTurfDate,
            builder: (context,snapshot)
            {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: SpinKitFoldingCube(size: 70,color: Colors.green[300],));
              else if (snapshot.hasData){
                //we get a snapshot and store it in a map
                print('Data for slot booking received from Firestore');
                fetched_info_of_selected_turf = snapshot.data;
                //impimp
                if(fetched_info_of_selected_turf.containsKey("day${selectedDate.day}"))
                  {
                    return ListViewOfSlots();
                  }
                else
                  return AllSlotsAvailUI();//display all slots available contact turf

              }
              else if (snapshot.hasError)
                return NoInfoAvailableUI();//display No info available currently
              else
                return AllSlotsAvailUI();//display all slots available contact turf
            },
          ),
        ),
      ],
    );
  }
}

class ListViewOfSlots extends StatefulWidget {
  @override
  _ListViewOfSlotsState createState() => _ListViewOfSlotsState();
}

class _ListViewOfSlotsState extends State<ListViewOfSlots> {
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: fetched_info_of_selected_turf['day${selectedDate.day}']['total_slots'],
      shrinkWrap: true,
      itemBuilder: (context,index)
      {
        return CardViewForEachSlot(index: index,);
      },
    );

  }
}
class NoInfoAvailableUI extends StatelessWidget {

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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      color: Colors.red[400],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(child: Lottie.asset("assets/noslotsavailableanimation.json",repeat: true,),padding: EdgeInsets.fromLTRB(15, 0, 0, 0),),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
            child: Text('No information available\nwith us for this date.\nContact the turf.',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,

              ),),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.phone,color: Colors.red[900],),
                    Text('CONTACT',style: TextStyle(color: Colors.red[900]),),
                  ],
                ),
                highlightColor: Colors.red[100],
                onPressed:(){
                  _launchCaller("tel:"+selected_turf_details['map']['phone']['number1'].toString());
                }
            ),
          ),
        ],
      ),
    );
  }
}


class AllSlotsAvailUI extends StatelessWidget
{
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      color: Colors.green[400],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 50, 0, 0),
            child: Text('All slots available\nfor this date.\nContact the turf.',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,

            ),),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.phone,color: Colors.green[900],),
                    Text('BOOK NOW',style: TextStyle(color: Colors.green[900]),),
                  ],
                ),
                highlightColor: Colors.green[100],
                onPressed:(){
                  _launchCaller("tel:"+selected_turf_details['map']['phone']['number1'].toString());
                }
            ),
          ),
          Lottie.asset("assets/allslotsavailableanimation.json",repeat: true),
        ],
      ),
    );
  }
}



class CardViewForEachSlot extends StatelessWidget
{

  final int index;

  CardViewForEachSlot({this.index});
  
  getTiminginstr(String startTime,String endTime)
  {

    Map<String,String> allTimingsStr = {"6":"6 A.M","6.5":"6:30 A.M","7":"7 A.M","7.5":"7:30 A.M","8":"8 A.M",
      "8.5":"8:30 A.M","9":"9 A.M","9.5":"9:30 A.M","10":"10 A.M","10.5":"10:30 A.M",
      "11":"11 A.M","11.5":"11:30 A.M","12":"12 P.M","12.5":"12:30 P.M","13":"1 P.M","13.5":"1:30 P.M","14":"2 P.M","14.5":"2:30 P.M",
      "15":"3 P.M","15.5":"3:30 P.M","16":"4 P.M","16.5":"4:30 P.M","17":"5 P.M","17.5":"5:30 P.M","18":"6 P.M","18.5":"6:30 P.M",
      "19":"7 P.M","19.5":"7:30 P.M","20":"8 P.M","20.5":"8:30 P.M","21":"9 P.M","21.5":"9:30 P.M","22":"10 P.M","22.5":"10:30 P.M",
      "23":"11 P.M","23.5":"11:30 P.M","0":"12 A.M","0.5":"12:30 A.M",
    "1":"1 A.M","1.5":"1:30 A.M","2":"2 A.M","2.5":"2:30 A.M","3":"3 A.M","3.5":"3:30 A.M","4":"4 A.M","4.5":"4:30 A.M","5":"5 A.M","5.5":"5:30 A.M",};

    String startTimestr = allTimingsStr[startTime];
    String endTimestr = allTimingsStr[endTime];
    String timing_of_slot = startTimestr+" - "+endTimestr;
    return timing_of_slot;
    
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 5, 12, 0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        color:fetched_info_of_selected_turf['day${selectedDate.day}']['slot${index+1}']['isDisabled']?Colors.grey[300]:fetched_info_of_selected_turf['day${selectedDate.day}']['slot${index+1}']['isBooked']?Colors.grey[300]:Colors.white,
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Text(
                'Slot '+'${index+1}',
                style: TextStyle(
                  color:Colors.grey[400],
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
              child: Text(
                getTiminginstr(fetched_info_of_selected_turf['day${selectedDate.day}']['slot${index+1}']['start_time'].toString(), fetched_info_of_selected_turf['day${selectedDate.day}']['slot${index+1}']['end_time'].toString()),
                style: TextStyle(
                  color:fetched_info_of_selected_turf['day${selectedDate.day}']['slot${index+1}']['isDisabled']?Colors.grey:fetched_info_of_selected_turf['day${selectedDate.day}']['slot${index+1}']['isBooked']?Colors.grey:Colors.green[300],
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(17, 2, 0, 10),
                  child: Text(
                    "Book with Turfit",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                fetched_info_of_selected_turf['day${selectedDate.day}']['slot${index+1}']['isDisabled']?BookNowDisabledButton():fetched_info_of_selected_turf['day${selectedDate.day}']['slot${index+1}']['isBooked']?BookNowDisabledButton():BookNowButton(),
              ],
            ),
          ],
        ),
        ),
      );
  }
}

class BookNowButton extends StatelessWidget {

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: [
              Icon(Icons.phone,color: Colors.green[900],),
              Text('BOOK',style: TextStyle(color: Colors.green[900]),),
            ],
          ),
          highlightColor: Colors.green[100],
          onPressed:(){
            _launchCaller("tel:"+selected_turf_details['map']['phone']['number1'].toString());
          }
        ),
        FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Icon(Icons.phone,color: Colors.green[900],),
                Text('BOOK',style: TextStyle(color: Colors.green[900]),),
              ],
            ),
            highlightColor: Colors.green[100],
            onPressed:(){
              _launchCaller("tel:"+selected_turf_details['map']['phone']['number2'].toString());
            }
        ),
      ],
    );
  }
}

class BookNowDisabledButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          onPressed: null,
          child: Row(
            children: [
              Icon(Icons.phone,color: Colors.grey[600],),
              Text('BOOK',style: TextStyle(color: Colors.grey[600]),),
            ],
          ),
        ),
      ],
    );
  }
}




