import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_text_patterns.dart';
import 'package:aid/constants.dart';
//import 'package:date_format/date_format.dart';

//void main() => runApp(WorldClock());
String timeMachineText = '';

class WorldClock extends StatefulWidget {
  WorldClock({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _WorlClockState createState() => _WorlClockState();
}

class _WorlClockState extends State<WorldClock> {
  String _timeString;
  List<Map<String, dynamic>> times=[];
  var regions = [INDIA_TIMEZONE, SINGAPORE_TIMEZONE, GERMANY_TIMEZONE, CHINA_TIMEZONE, JAPAN_TIMEZONE, NETHARLAND_TIMEZONE, UK_TIMEZONE, ARGENTINA_TIMEZONE, BRAZIL_TIMEZONE, MEXICO_TIMEZONE, US_TIMEZONE, CANADA_TIMEZONE];
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  bool _load = false;

  @override
  void initState()  {
    _load = true;
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }
  String durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  Future<Map<String, dynamic>> getAllTimesFromDifferenRegions(String TimeZone) async {
    var sb = new StringBuffer();
    await TimeMachine.initialize({
      'rootBundle': rootBundle,
    });
    var tzdb = await DateTimeZoneProviders.tzdb;
    var regionTimeZone = await tzdb[TimeZone];
    var now = SystemClock.instance.getCurrentInstant();
    var timeInString = '${now.inZone(regionTimeZone)}';
    var getOnllyTime = timeInString.split(" ")[0]; // First object
    DateTime zoneDateTime = DateTime.parse(getOnllyTime);
    var convertDate = DateFormat.jms().format(zoneDateTime);
    var currentTime = DateTime.now();
    final differenceInMinutes = zoneDateTime.difference(currentTime).inMinutes;

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateTime formatted = DateTime.parse(formatter.format(currentTime));
    final DateTime formatted1 = DateTime.parse(formatter.format(zoneDateTime));
    var differenceInDays = 0;

    if (formatted.isBefore(formatted1)) {
      differenceInDays = -1;
    } else if (formatted.isAfter(formatted1)){
      differenceInDays = 1;
    }

    String country;
    String  flagName;
   
    switch(TimeZone) {
      case INDIA_TIMEZONE: {  country = "India"; flagName = "Assets/Flags/India.png"; }
      break;
      case SINGAPORE_TIMEZONE: { country = "Singapore" ; flagName = "Assets/Flags/Singapore.png"; }
      break;
      case CHINA_TIMEZONE: {  country = "China"; flagName = "Assets/Flags/China.png"; }
      break;
      case JAPAN_TIMEZONE: { country = "Japan"; flagName = "Assets/Flags/Japan.png"; }
      break;
      case GERMANY_TIMEZONE: {  country = "Germany"; flagName = "Assets/Flags/Germany.png"; }
      break;
      case NETHARLAND_TIMEZONE: { country = "Netherland" ;  flagName = "Assets/Flags/Netherland.png";}
      break;
      case UK_TIMEZONE: {  country = "UK"; flagName = "Assets/Flags/UK.png"; }
      break;
      case ARGENTINA_TIMEZONE: { country = "Argentina"; flagName = "Assets/Flags/Argentina.png"; }
      break;
      case BRAZIL_TIMEZONE: {  country = "Brazil"; flagName = "Assets/Flags/Brazil.png"; }
      break;
      case MEXICO_TIMEZONE: { country = "Mexico" ; flagName = "Assets/Flags/Mexico.png";}
      break;
      case US_TIMEZONE: {  country = "USA"; flagName = "Assets/Flags/USA.png";}
      break;
      case CANADA_TIMEZONE: { country = "Canada"; flagName = "Assets/Flags/Canada.png";}
      break;
      default: { country = "" ; flagName = "";}
      break;
    }
    var timeObject = {'TimeZone': TimeZone, 'ConvertedTime': convertDate, 'Country': country, 'Duration': differenceInMinutes, 'Days': differenceInDays, 'Flag': flagName};
    return timeObject;
  }

  void assesndingOrder(){
    times.sort((b, a) => a['Duration'].compareTo(b['Duration']));
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
        title: Text("World Clock"),
      ),
        body: new Stack(children: <Widget>[new Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            child: new ListView.builder(
                itemCount: times.length,
                itemBuilder: (BuildContext context, int index) =>
                    worldClockWidgets(context, index))
        ),
          new Align(
            child: loadingIndicator, alignment: FractionalOffset.center,)

          ])
    );
  }
 Container _DisplayFalg(String  flagValue) {
    return  new Container(
      child: new CircleAvatar(
        backgroundImage: ExactAssetImage(
            flagValue),
        backgroundColor: Colors.white,
        radius: 25.0,
      ),
    );
  }
 

  Widget worldClockWidgets(BuildContext context, int index) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    return new Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
               _DisplayFalg('${times[index]['Flag']}'),
                SizedBox(width: 10,),
                Container(
                  width: screenWidth/2 - 60 ,
                  child: new Column(
                    children: <Widget>[
                      SizedBox(height: 7,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText('${times[index]["Country"]}', maxLines: 1, maxFontSize: 21.0,style: new TextStyle(fontSize: 21.0,fontWeight: FontWeight.w400, color: Colors.black),) ,
                      ),
                      SizedBox(height : 3),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText('${findAday(times[index]['Days'])}, ${_convertToHrs(times[index]['Duration'])}', maxFontSize: 13.0, maxLines: 1, style: new TextStyle(fontSize: 13.0,fontWeight: FontWeight.normal, color: Colors.grey[500]),),
                      ),
                      SizedBox(height : 5),
                    ],
                  ),
                ),
                Container(
                  width: screenWidth/2 - 60,
                    child: new Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: AutoSizeText('${times[index]["ConvertedTime"]}',maxLines: 1, maxFontSize: 25.0, style: new TextStyle(fontSize: 25.0,fontWeight: FontWeight.w400, color: Colors.black),),
                        )
                      ],
                    ),
                ),
              ],
            ),
        ),
      ),
    );
  }

  void _getTime() async {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    times.clear();
    for (int i = 0; i < regions.length; i++) {
      final timeObject = await getAllTimesFromDifferenRegions(regions[i]);
      times.add(timeObject);
    }
    assesndingOrder();

    if(mounted) {
      setState(()  {
        _timeString  = _formatDateTime(DateTime.now());
        _load = false;
      });
    }
  }
  
  String _convertToHrs(int duration){
    var finalOffSet = durationToString(duration);
    if (!finalOffSet.contains('-')) {
      finalOffSet = '+${finalOffSet}';
    }
    return finalOffSet;
  }

  String findAday(int day){
    if (day == 0){
      return 'Today';
    }else if (day == 1){
      return 'Yesterday';
    } else if (day == -1){
      return 'Tomorrow';
    }
    return '';
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat.jms().format(dateTime);
  }
}