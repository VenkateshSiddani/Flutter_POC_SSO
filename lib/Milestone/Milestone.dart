

import 'dart:io';

import 'package:aid/Milestone/MilestoneModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:aid/constants.dart';
import 'package:aid/CommonMethods.dart';
import 'package:aid/Milestone/MilestoneAPI.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';
import 'package:aid/alert.dart';
import 'package:humanize/humanize.dart' as humanize;

import '../dialog_button.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

class MilestonePage extends StatefulWidget {
  MilestonePage({Key key, this.title, this.accessToken,this.employeeID}) : super(key: key);

  final String title;
  final String accessToken;
  final String employeeID;

  @override
  _MilestonePageState createState() => _MilestonePageState();
}

class _MilestonePageState extends State<MilestonePage> with TickerProviderStateMixin {
  Map<DateTime, List<Event>> _events;
  List<Event> _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  String get accessToken => widget.accessToken;
  bool _load = false;
  bool _isAlertShows = false;
  String get employeeID => widget.employeeID;
  MilestoneEvents milestoneEvents = MilestoneEvents();
  MyMileStone myMileStone = MyMileStone();
  int _cIndex = 0;
  List<MyWishes> myWishesForBirthday = List();
  TextEditingController _textFieldController = TextEditingController();
  bool _lights = false;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    fetchData();
    _events = {
      // _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
      // _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      // _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
      // _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      // _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
      // _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
      // _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      // _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      // _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
      // _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      // _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
      // _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      // _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
      // _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      // _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    };

    _selectedEvents = _events[_selectedDay] ?? List<Event>();
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  // void _onDaySelected(DateTime day, List events, List holidays) {
  //   print('CALLBACK: _onDaySelected');
  //   setState(() {
  //     _selectedEvents = events;
  //   });
  // }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      if(events.length > 0){
        _selectedEvents = events as List<Event>;
      }else {
        _selectedEvents = List<Event>(); // Initalizing with zero

      }
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load ? new Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),
          child: new Center(child: new CircularProgressIndicator())),
    ) : new Container();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new  Stack(
        children: [
          _changeTheView(_cIndex),
          new Align(
            child: loadingIndicator, alignment: Alignment.center,
          )
        ],
      ),
      bottomNavigationBar:BottomNavigationBar(
      currentIndex: _cIndex,
      type: BottomNavigationBarType.fixed ,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today,color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('My Milestones')
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day,color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('Milestones Calendar')
        )
      ],
      onTap: (index){
        _incrementTab(index);
      },
    ),
    );
  }
  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
      _changeTheView(_cIndex);
    });
  }

  _changeTheView(int index){
    if (index == 1){
      return  buildTheView();
    } else if (index == 0){
      return myMileStoneView();
    }
  }

  buildTheView(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        // Switch out 2 lines below to play with TableCalendar's settings
        //-----------------------
        _buildTableCalendar(),
        // _buildTableCalendarWithBuilders(),
        const SizedBox(height: 8.0),
        // _buildButtons(),
        _indicatorIdentification(),
        Expanded(child: _buildEventList()),
      ],
    );
  }

  myMileStoneView(){
    return new Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Expanded(child:new ListView.builder(  itemCount: 5,
            itemBuilder: (context, index) {
              return retunrMyViewBasedOnIdex(index);
            })
        ),
        // // new Expanded(child: myWishesList()),
        // myWishesList(),
      ],


    );
  }

  retunrMyViewBasedOnIdex(int index){
    if(index == 0){
      return  SizedBox(height: 45.0, child: new ListView.builder(itemCount: 1, physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              color : Colors.lightBlue[100],
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text("My Milestones", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );

          }));
    }else if (index == 1){
      return myMilesStone();
    }else if(index == 2){
      String title = "";
      String subTitle = '';
      if(_lights){
        subTitle = "Let others not view my birthday in the calendar";
        title = "Exclude Me";
      }else{
        subTitle = "Let others view my birthday in the calendar";
        title = "Include Me";
      }
      return MergeSemantics(
        child: ListTile(
          title: Text(title),
          subtitle: Text(subTitle),
          trailing: CupertinoSwitch(
            value: _lights,
            onChanged: (bool value) {
                isExlcuded(_lights, myMileStone.ID).then((value1){
                  if (value1) {
                    setState(() {
                      _lights = value;
                    });
                  }
                });
              }
          ),
          onTap: () {
            isExlcuded(_lights, myMileStone.ID).then((value1) {
              if(value1){
                setState(() {
                  _lights = !_lights;
                });
              }
            });

          },
        ),
      );
    }
    else if (index == 3){
      return SizedBox(height: 45.0, child: new ListView.builder(  itemCount: 1, physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              color : Colors.lightBlue[100],
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text("My Wishes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );

          }));
    } else if(index == 4) {
     return myWishesList();
    }
  }

  myMilesStone(){

   return SizedBox(height: 270, child: new Expanded(child:Container(
     color: Colors.white,
     child: ListView.builder(
         itemCount: 3,physics: const NeverScrollableScrollPhysics(),
         itemBuilder: (context, index) {
           return Card(
             elevation: 5,
             child: Container(
               color: Colors.white,
               // height: 500,
               child:  Padding(
                 padding: const EdgeInsets.all(10.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisSize: MainAxisSize.max,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     new Container(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           HeadeName('', FontWeight.bold, index,true),
                           itemName(FontWeight.normal, index, true), // Divider(),
                         ],
                       ),
                     ),
                     SizedBox(height: 10,),
                     myMilestoeMessage(index),
                   ],
                 ),
               ),
             ),
           );
         }
     ),
   )
   ),);
  }

  Map<String, String> get headers => {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };


  Future<bool> isExlcuded(bool isValue, int id) async{

    final isExcludedWishParameters = jsonEncode({
      'Id':id.toString(),
      'IsExclude':isValue.toString(),
      'Content-Type': 'application/json'
    });

    setState(() {
      _load = true; //
    });
    try {
      bool isExcluded = await isExcludedWish(KIsExcludedWish, body: isExcludedWishParameters, headers:headers );
      if (mounted && isExcluded)
        setState(() {
          Commonmethod.alertToShow("Data updated successfully", 'Success', context);
          _load = false;
        });
      else {
        Commonmethod.alertToShow("Data not updated successfully", 'Error', context);
        _load = false;
      }
      return isExcluded;
    } on SocketException catch (_) {
      // print('not connected');
      setState(() {
        _load = false;
      });
      Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);
      return false;
    }
  }


  myWishesList(){

    if (myWishesForBirthday.length  == 0) {
        return ListTile(
          title: Text("No Wishes", textAlign: TextAlign.center,),
      );
    }else {
      return SizedBox(height: 400.0, child: new ListView.builder(  itemCount: myWishesForBirthday.length ?? 0,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: _circleImaeNetwrok(myWishesForBirthday[index].Image ?? ""),
                title: Text(myWishesForBirthday[index].EmployeeName ?? ""),
                subtitle: Text(
                    myWishesForBirthday[index].Comments ?? ""),
              ),
            );

          }));
    }



  }

  myMilestoeMessage(int index) {
    String title = '';
    if (index == 0 && myMileStone != null){
      title = "${myMileStone.TotalYear.toString()} Years ${myMileStone.TotalMonth.toString()} Months ${myMileStone.Totaldays.toString()} Days since birth";
    }
    else if (index == 1 && myMileStone != null){
      title = "${myMileStone.TotalYearCognizant.toString()} Years ${myMileStone.TotalMonthCognizant.toString()} Months ${myMileStone.TotaldaysCognizant.toString()} Days in CTS";
    }
    else if (index == 2 && myMileStone != null){
      title = "${myMileStone.TotalYearAbbott.toString()} Years ${myMileStone.TotalMonthAbbott.toString()} Months ${myMileStone.TotaldaysAbbott.toString()} Days in Abbott";
    }
   return AutoSizeText(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal), textAlign: TextAlign.center,);
  }

  Widget itemName(FontWeight fontWeight, int index, bool makeBold) {
    FontWeight textWeight;

    textWeight = fontWeight;

    String title = '';
    if (myMileStone.DOB != null && index == 0) {
      DateTime date = DateTime.parse(myMileStone.DOB);
      title = DateFormat('dd MMMM yyyy').format(date);
    }
    else if (myMileStone.CognizantDOJ != null && index == 1){
      DateTime date = DateTime.parse(myMileStone.CognizantDOJ);
      title = DateFormat('dd MMMM yyyy').format(date);
    }else if(myMileStone.AbbottDOJ != null && index == 2 ){
      DateTime date = DateTime.parse(myMileStone.AbbottDOJ);
      title = DateFormat('dd MMMM yyyy').format(date);
    }
    // the Expanded widget lets the columns share the space
    Widget column = Expanded(
      child: Column(
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 16, fontWeight: textWeight), textAlign: TextAlign.center,),
        ],
      ),
    );
    return column;
  }

  Widget HeadeName(String name, FontWeight fontWeight, int index, bool makeBold){
    FontWeight textWeight;
    textWeight = fontWeight;
    String title = '';
    if (makeBold) {
      if (index == 0){
        title = 'Date of Birth';
      }else if(index == 1){
        title = 'Cognizant DOJ';
      }else if (index == 2){
        title = 'Abbott DOJ';
      }
    }

    Widget secondaryLeadName = Expanded(
      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 16, fontWeight: textWeight), textAlign: TextAlign.center,),
        ],
      ),
    );
    return secondaryLeadName;
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.week: 'Week',
      },
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.grey, // marker dot color
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400], // Top Month/Week calendar button color
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }
  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildButtons() {
    final dateTime = _events.keys.elementAt(_events.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text('Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    if (_selectedEvents.length > 0) {
      return new ListView.builder(itemCount: _selectedEvents.length ?? 0, itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              print('tapped $index');
              _displayDialog(context, _selectedEvents[index]);
            },
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: _eventCell(_selectedEvents[index].title.toString(), _selectedEvents[index].Type.toString(), _selectedEvents[index].DOB.toString(), _selectedEvents[index].Image.toString()),

          // child: _eventCell(event.toString()),
        ));
      });
    }else {
      return Text("No Events", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.center,);
    }
  }


  String getDescription(String typeOfEvent, String DOB){
    final birthday = DateTime.parse(DOB);
    final date2 = DateTime.now();
    final difference = date2.difference(birthday);
    String differenceInYears = (difference.inDays/365).floor().toString();

    String  descriptionMessage = "${humanize.ordinal(int.parse(differenceInYears))} Year";

    if(typeOfEvent == "Birthday") {
     return descriptionMessage = "${descriptionMessage} Birthaday";
    }else if (typeOfEvent == "Abbott"){
      return descriptionMessage = "${descriptionMessage} Anniversary in Abbott";
    }else if(typeOfEvent == "CTS"){
      return descriptionMessage = "${descriptionMessage} Anniversary in CTS";
    }else if (typeOfEvent == "Regional" || typeOfEvent == "National"){
      return descriptionMessage = "${descriptionMessage} Birthaday";
    }
  }
  _eventCell(String title, String typeOfEvent, String DOB, String imageURL){



    // return Card(
    //   elevation: 5,
    //   child: Container(
    //     // color: Colors.yellow.withAlpha(64)
    //     //  color: Colors.white,
    //       padding: const EdgeInsets.all(10.0),
    //       child: new Row(
    //         children: <Widget>[
    //           _circleImaeNetwrok(),
    //           SizedBox(width: 10,),
    //           Expanded(
    //             flex: 2,
    //             child: Container(
    //               width: double.infinity,
    //               child: AutoSizeText(title, maxFontSize: 19.0,style: new TextStyle(fontSize: 19.0,fontWeight: FontWeight.w400, color: Colors.black),),
    //             ),
    //           ),
    //           _circleContaierForIndication(typeOfEvent),
    //           SizedBox(width: 10,),
    //         ],
    //       )
    //   ),
    // );
    return Card(
      child: ListTile(
        leading: _circleImaeNetwrok(imageURL),
        title:  AutoSizeText(title, maxFontSize: 19.0,style: new TextStyle(fontSize: 19.0,fontWeight: FontWeight.w400, color: Colors.black),),
        subtitle: Text(getDescription(typeOfEvent, DOB)),
        trailing: _circleContaierForIndication(typeOfEvent),
      ),
    );
  }
  _displayDialog(BuildContext context ,Event event) {
    return customAlert1(context, event);
  }
  // Alert with multiple and custom buttons
  customAlert1(context, Event event) {
    Alert(
      context: context,
      type: AlertType.profile,
      title: event.title.toString(),
      textFieldController: _textFieldController, //as TextEditingController()
      desc: getDescription(event.Type.toString(), event.DOB.toString()),
     imageURL:(event.Image != null) ? event.Image : "",
      closeFunction: cancelAlert,
      buttons: [
        DialogButton(
          child: Text(
            "Send",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: () {
            // Navigator.pop(context);
            // _showDialog("AID", "Coming Soon");
            sendingGreeting(_textFieldController.text.toString(), event.employeeID.toString(), employeeID, event.Type.toString()).then((value) {
              if (value) {
                Commonmethod.alertToShow("Send wishes successfully", 'AID', context);
                _textFieldController = TextEditingController();
              }
            });
          },
          color: Colors.black12,
        ),

      ],
    ).sendWishesAlert();
  }


  cancelAlert(){
    _textFieldController = TextEditingController();
  }

  Future<bool>sendingGreeting(String wishesMessage,String employeeID, String submittedBy, String type) async{
    if (wishesMessage.length == 0) {
      Commonmethod.alertToShow(
          "Please enter comments", 'AID', context);
      return false;
    }
    Navigator.of(context).pop(); // To exit the the alert send greeting window alert
    final sendWishParameters = jsonEncode({
      'EmployeeId':employeeID,
      'SubmitterId':submittedBy,
      'Type':type,
      'Wishes':wishesMessage,
      'Content-Type': 'application/json'
    });

    setState(() {
      _load = true; //
    });
    try {
      bool isSaved = await sendWishes(KSendGreetings, body: sendWishParameters, headers:headers );
      if (mounted && isSaved)
        setState(() {
          // Commonmethod.alertToShow("Data updated successfully", 'Success', context);
          _load = false;
        });
      else {
        Commonmethod.alertToShow("Internal Server error. Please try again", 'Error', context);
        _load = false;
      }
      return isSaved;
    } on SocketException catch (_) {
      // print('not connected');
      setState(() {
        _load = false;
      });
      Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);
      return false;
    }
  }
  _circleContaierForIndication(String type){
    Color changeTheColor = Colors.white; // By default
    if(type == "Birthday") {
      changeTheColor = Colors.deepOrangeAccent;
    }else if (type == "Abbott"){
      changeTheColor = Colors.lightBlueAccent;
    }else if(type == "CTS"){
      changeTheColor = Colors.blue[900];
    }else if (type == "Regional" || type == "National"){
      changeTheColor = Colors.green;
    }
    return Container(
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
          color: changeTheColor,
          shape: BoxShape.circle
      ),
    );
  }

  _indicatorIdentification(){
    if (_selectedEvents.length.toInt() > 0){
      return Card(
        elevation: 5,
        color: Colors.blue[400],
        child: Container(
          color: Colors.white,
          child:  Padding(
            padding: const EdgeInsets.all(10.0),
            child :new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container( child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _circleContaierForIndication("Regional"),
                      SizedBox(width: 10,),
                      Text('Holidays'),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                        ),
                      ),
                      _circleContaierForIndication("Birthday"),
                      SizedBox(width: 10,),
                      Text('Birthday'),
                    ],
                  ),
                  ),
                  new Container(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _circleContaierForIndication("Abbott"),
                      SizedBox(width: 10,),
                      Text('Abbott Anniversary'),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                        ),
                      ),
                      _circleContaierForIndication("CTS"),
                      SizedBox(width: 10,),
                      // Text('CTS Anniversary', style: (TextStyle(textAlign: TextAlign.center)),),
                      Text("CTS Anniversary", textAlign: TextAlign.right,)

                    ],
                  ),
                  )
                ]

            ),

          ),
        ),
      );

    }else {
      return Card();
    }
  }

  // _circleContaierForIndication("Abbott"),
  // Text('Abbott Anniversary'),
  // _circleContaierForIndication("CTS"),
  // Text('CTS Anniversary'),
  _circleImaeNetwrok(String profileURL){
    // var image =  imageList.singleWhere((element) => element.resourceid == resourceID,orElse: () => null);
    // print(image);
    return Commonmethod.getCircularImage(profileURL, accessToken);
    return Container(
      child:  CircleAvatar(
        radius: 30.0,
        backgroundImage: AssetImage('Assets/profile_img.png'),
        // backgroundImage:
        // NetworkImage(image.Image),
        backgroundColor: Colors.transparent,
      ),
      //   child: CachedNetworkImage(
      //     imageUrl: image.Image,
      //     progressIndicatorBuilder: (context, url, downloadProgress) =>
      //         CircularProgressIndicator(value: downloadProgress.progress),
      //     placeholder: (context, url) => {return NetworkImage('')},
      //     errorWidget: (context, url, error) => Icon(Icons.error),
      //   )
      //   margin: EdgeInsets.all(1.0),
      //   decoration: BoxDecoration(
      //       shape: BoxShape.circle
      //   ),
      //   child: FadeInImage.assetNetwork(
      //     placeholder: 'Assets/profile_img.png',
      //     image: image.Image ?? 'http://AID.cognizant.com/assets/img/profile/b30aba26-537e-4092-938d-f09640f4cd34.jpg',
      // ),
    );
  }
  void fetchData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none)  {
      Commonmethod.alertToShow(CONNECTIVITY_ERROR, 'AID', context);
    } else {
        getCalendarMonthEventDetails().then((value) {
          if(value != null){
             milestoneEvents = value ;
            updateMonthEvents();
          }
        });

        getMyMilestonetDetails().then((value) => myMileStone = value);
    }
  }


  Future <MilestoneEvents> getCalendarMonthEventDetails() async {
    setState(() {
      _load = true; //
    });
    try {
      MileStone module = await getCalendarEventDetails(
          KMilestoneCalendarAPI+employeeID, headers: headers);
      if (mounted)
        setState(() {
          if (module.errorObj != null && module.errorObj.ErrorCode == 401) {
            if (!_isAlertShows)
               Commonmethod.alertToShow("Session Expired...Please try to Login Again", 'Warning', context);
          }
          else if (module.errorObj != null) {
            if (!_isAlertShows)
              Commonmethod.alertToShow((module.errorObj.ErrorDesc), 'Error', context);
          }
          _load = false;
        });

      List<Event> BirthdayList = [];
      List<Event> AbbottAnniversaryList = [];
      List<Event> HolidayList = [];
      List<Event> CTSAnniversaryList = [];
      List<Event> TodayBirthdayList = [];
      List<Event> RegionalHolidayList = [];
      List<Event> NationalHolidayList = [];

      module.birthdaysList.forEach((element) {
        BirthdayList.add(Event(employeeID: element['Employeeid'],title: element['title'],Image: element['Image'],DOB: element['DOB'],Differenceyears: element['Differenceyears'],color: element['color'],Email: element['Email'],SecondaryEmail: element['SecondaryLeadEmail'],Type: element['Type'],HolidayType: element['HolidayType']));
      });
      module.abbottAniversaryList.forEach((element) {
        AbbottAnniversaryList.add(Event(employeeID: element['Employeeid'],title: element['title'],Image: element['Image'],DOB: element['DOB'],Differenceyears: element['Differenceyears'],color: element['color'],Email: element['Email'],SecondaryEmail: element['SecondaryLeadEmail'],Type: element['Type'],HolidayType: element['HolidayType']));
      });
      module.holidaysList.forEach((element) {
        HolidayList.add(Event(employeeID: element['Employeeid'],title: element['title'],Image: element['Image'],DOB: element['DOB'],Differenceyears: element['Differenceyears'],color: element['color'],Email: element['Email'],SecondaryEmail: element['SecondaryLeadEmail'],Type: element['Type'],HolidayType: element['HolidayType']));
      });
      module.ctsAniversaryList.forEach((element) {
        CTSAnniversaryList.add(Event(employeeID: element['Employeeid'],title: element['title'],Image: element['Image'],DOB: element['DOB'],Differenceyears: element['Differenceyears'],color: element['color'],Email: element['Email'],SecondaryEmail: element['SecondaryLeadEmail'],Type: element['Type'],HolidayType: element['HolidayType']));
      });
      module.todayBirthdayList.forEach((element) {
        TodayBirthdayList.add(Event(employeeID: element['Employeeid'],title: element['title'],Image: element['Image'],DOB: element['DOB'],Differenceyears: element['Differenceyears'],color: element['color'],Email: element['Email'],SecondaryEmail: element['SecondaryLeadEmail'],Type: element['Type'],HolidayType: element['HolidayType']));
      });
      module.regionalHolidayList.forEach((element) {
        RegionalHolidayList.add(Event(employeeID: element['Employeeid'],title: element['title'],Image: element['Image'],DOB: element['DOB'],Differenceyears: element['Differenceyears'],color: element['color'],Email: element['Email'],SecondaryEmail: element['SecondaryLeadEmail'],Type: element['Type'],HolidayType: element['HolidayType']));
      });
      module.nationalHollidayList.forEach((element) {
        NationalHolidayList.add(Event(employeeID: element['Employeeid'],title: element['title'],Image: element['Image'],DOB: element['DOB'],Differenceyears: element['Differenceyears'],color: element['color'],Email: element['Email'],SecondaryEmail: element['SecondaryLeadEmail'],Type: element['Type'],HolidayType: element['HolidayType']));
      });

      return MilestoneEvents(BirthdayList: BirthdayList,AbbottAnniversaryList: AbbottAnniversaryList, HolidayList: HolidayList, CTSAnniversaryList: CTSAnniversaryList, TodayBirthdayList: TodayBirthdayList, RegionalHolidayList: RegionalHolidayList, NationalHolidayList: NationalHolidayList);

    } on SocketException catch (_) {
      // print('not connected');
      setState(() {
        _load = false;
      });
      if (!_isAlertShows)
      Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);

    }
  }


  updateMonthEvents(){
    DateTime todayDate = DateTime.now();
    if (milestoneEvents != null) {
      milestoneEvents.NationalHolidayList.forEach((element) {
         DateTime eventDate = DateTime.parse(element.DOB);
         // _events[eventDate] = ['${element.title}'];
         if(_events.containsKey(eventDate)) {
           List<dynamic> value = _events[eventDate];
           value.add(element);
           _events.addAll({eventDate: value});
         }else {
           _events.addAll({eventDate: [element]});
         }
      });
       milestoneEvents.RegionalHolidayList.forEach((element) {
         DateTime eventDate = DateTime.parse(element.DOB);
         // _events[eventDate] = ['${element.title}'];
         if(_events.containsKey(eventDate)) {
           List<dynamic> value = _events[eventDate];
           value.add(element);
           _events.addAll({eventDate: value});
         }else {
           _events.addAll({eventDate: [element]});
         }
       });
       milestoneEvents.BirthdayList.forEach((element) {
         if(element.DOB != null) {
           DateTime eventDate = DateTime.parse(element.DOB);
           String convertTothisYearString = '';
           if (eventDate.month.toString().length == 1 && eventDate.day.toString().length == 1) {
             convertTothisYearString = '${todayDate.year}-0${eventDate.month}-0${eventDate.day}T00:00:00';
           } else if (eventDate.month.toString().length == 1) {
             convertTothisYearString = '${todayDate.year}-0${eventDate.month}-${eventDate.day}T00:00:00';
           }else if (eventDate.day.toString().length == 1) {
             convertTothisYearString = '${todayDate.year}-${eventDate.month}-0${eventDate.day}T00:00:00';
           }else {
             convertTothisYearString = '${todayDate.year}-${eventDate.month}-${eventDate.day}';
           }
           DateTime convertToThisYearDate = DateTime.parse(convertTothisYearString);
           // _events[convertToThisYearDate] = ['${element.title}'];
           if(_events.containsKey(convertToThisYearDate)) {
             List<dynamic> value = _events[convertToThisYearDate];
             value.add(element);
             _events.addAll({convertToThisYearDate: value});
           }else {
             _events.addAll({convertToThisYearDate: [element]});
           }
         }else{
           print('Invalid Date :${element.title}');
         }
       });
       milestoneEvents.AbbottAnniversaryList.forEach((element) {
         if(element.DOB != null) {
           DateTime eventDate = DateTime.parse(element.DOB);
           String convertTothisYearString = '';
           if (eventDate.month.toString().length == 1 && eventDate.day.toString().length == 1) {
             convertTothisYearString = '${todayDate.year}-0${eventDate.month}-0${eventDate.day}T00:00:00';
           } else if (eventDate.month.toString().length == 1) {
             convertTothisYearString = '${todayDate.year}-0${eventDate.month}-${eventDate.day}T00:00:00';
           }else if (eventDate.day.toString().length == 1) {
             convertTothisYearString = '${todayDate.year}-${eventDate.month}-0${eventDate.day}T00:00:00';
           }else {
             convertTothisYearString = '${todayDate.year}-${eventDate.month}-${eventDate.day}';
           }
           DateTime convertToThisYearDate = DateTime.parse(convertTothisYearString);
           // _events[convertToThisYearDate] = ['${element.title}'];
           if(_events.containsKey(convertToThisYearDate)) {
             List<dynamic> value = _events[convertToThisYearDate];
             value.add(element);
             _events.addAll({convertToThisYearDate: value});
           }else {
             _events.addAll({convertToThisYearDate: [element]});
           }
         }else{
           print('Invalid Date :${element.title}');
         }
       });
       milestoneEvents.HolidayList.forEach((element) {
         if(element.DOB != null) {
           DateTime eventDate = DateTime.parse(element.DOB);
           // _events[eventDate] = ['${element.title}'];
           if(_events.containsKey(eventDate)) {
             List<dynamic> value = _events[eventDate];
             value.add(element);
             _events.addAll({eventDate: value});
           }else {
             _events.addAll({eventDate: [element]});
           }
         }else{
           print('Invalid Date :${element.title}');
         }
       });
       milestoneEvents.CTSAnniversaryList.forEach((element) {
         if(element.DOB != null) {
           DateTime eventDate = DateTime.parse(element.DOB);
           String convertTothisYearString = '';
           if (eventDate.month.toString().length == 1 && eventDate.day.toString().length == 1) {
             convertTothisYearString = '${todayDate.year}-0${eventDate.month}-0${eventDate.day}T00:00:00';
           } else if (eventDate.month.toString().length == 1) {
             convertTothisYearString = '${todayDate.year}-0${eventDate.month}-${eventDate.day}T00:00:00';
           }else if (eventDate.day.toString().length == 1) {
             convertTothisYearString = '${todayDate.year}-${eventDate.month}-0${eventDate.day}T00:00:00';
           }else {
             convertTothisYearString = '${todayDate.year}-${eventDate.month}-${eventDate.day}';
           }
           DateTime convertToThisYearDate = DateTime.parse(convertTothisYearString);
           // _events[convertToThisYearDate] = ['${element.title}'];
           if(_events.containsKey(convertToThisYearDate)) {
             List<dynamic> value = _events[convertToThisYearDate];
             value.add(element);
             _events.addAll({convertToThisYearDate: value});
           }else {
             _events.addAll({convertToThisYearDate: [element]});
           }
         }else{
           print('Invalid Date :${element.title}');
         }
       });
       // _events.addAll(_NationalHolidayEvents);
       // milestoneEvents.TodayBirthdayList.forEach((element) {
       //   DateTime eventDate = DateTime.parse(element.DOB);
       //   _events[eventDate] = ['${element.title}'];
       // });
       setState(() {
         _load = false; //
         final _selectedDay = DateTime.now().toString().split(" ")[0] + 'T00:00:00';
         _selectedEvents = _events[DateTime.parse(_selectedDay)] ?? List<Event>();
       });
    }
  }
  addingInEvents(List event){
    event.forEach((element) {
      DateTime eventDate = DateTime.parse(element.DOB);
      _events[eventDate] = [element];
      if(_events.containsKey(eventDate)) {
        List<dynamic> value = _events[eventDate];
        value.add(element.title);
        _events.addAll({eventDate: value});
      }
    });
  }

  Future <MyMileStone> getMyMilestonetDetails() async {
    setState(() {
      _load = true; //
    });
    try {
      MyMileStone module = await getMyMilestoneDetails(
          KMyMilestoneDetailsAPI+employeeID, headers: headers);
      if (mounted)
        setState(() {
          if (module.errorObj != null && module.errorObj.ErrorCode == 401) {
            if (!_isAlertShows)
              Commonmethod.alertToShow("Session Expired...Please try to Login Again", 'Warning', context);
          }
          else if (module.errorObj != null) {
            if (!_isAlertShows)
              Commonmethod.alertToShow((module.errorObj.ErrorDesc), 'Error', context);
          }
          _load = false;
        });
      setState(() {
        _load = false; //
      });

      module.myWishes.forEach((element) {
        myWishesForBirthday.add(MyWishes(EmployeeName: element['EmployeeName'], Comments: element['Comments'], Image: element['Image']));
      });

      return module;

    } on SocketException catch (_) {
      // print('not connected');
      setState(() {
        _load = false;
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);

    }
  }

}
