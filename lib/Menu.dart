import 'package:aid/FeedBack/FeedBackViewController.dart';
import 'package:aid/PinLocations.dart';
import 'package:aid/Trainings/TrainingViewControllerLead.dart';
import 'package:aid/VoiceOfAnAbbottian/VoiceofanAbbottianViewController.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' show IOClient;
import 'dart:async';
import 'dart:convert';
import './AllocationReports.dart';
import './DebthAnalysys.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import './SpotLight/SpotLight.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './SpotLight/SpotlightMenu.dart';
import './flutter_alert.dart';
import 'dart:io';
import 'Survey/SurveyListViewController.dart';
import 'constants.dart';
import 'package:tuple/tuple.dart';
import 'AppCertification.dart';
import 'package:aid/WorldClock.dart';
import 'package:aid/Diversity/DiversityDashBoard.dart';
import 'package:aid/SpotLight/SpotLightModule.dart';
import 'package:aid/Milestone/Milestone.dart';
import 'package:aid/Trainings/TrainingViewController.dart';
//import 'package:aid/flutter_alert.dart:f'
import 'package:aid/main.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:aid/Trainings/TrainingViewControllerSecondLead.dart';
import 'package:aid/Survey/SurveyViewController.dart';
import 'package:aid/Survey/SurveyModel.dart';

class Error {

  String ErrorDesc;
  int ErrorCode;

  Error(this.ErrorDesc, this.ErrorCode);
}


class Reports {

  Map<String, dynamic> data ;
  final List<dynamic> itsmResolvedTickets;
  final List<dynamic> applensResolvedTicket;
  final List<dynamic> debtClassificationUpdated;
  final Error errorObj;

  Reports({ this.data, this.itsmResolvedTickets, this.applensResolvedTicket, this.debtClassificationUpdated, this.errorObj});

  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
      data : json['data'],
      itsmResolvedTickets: json['data']['ITSMResolvedTicket'],
      applensResolvedTicket:  json['data']['ApplensResolvedTicket'],
      debtClassificationUpdated: json['data']['DebtClassificationUpdated'],

    );
  }
}



Future<Reports> createPost(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;

    print(http.Response);
    if (statusCode < 200 || statusCode >= 400  || json == null) {
      return Reports(errorObj: Error(response.reasonPhrase, statusCode));
       // throw new Exception("Error while fetching data");
    }
    return Reports.fromJson(json.decode(response.body));
  });

}

class DebthAdherence {

  List <dynamic> data ;
  final Error errorObj;

  DebthAdherence({ this.data, this.errorObj});

  factory DebthAdherence.fromJson(Map<String, dynamic> json) {
    return DebthAdherence(
        data : json['data'],

    );
  }
}

Future<DebthAdherence> debthAdherenceData(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;

    print(http.Response);
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return DebthAdherence(errorObj: Error(response.reasonPhrase, statusCode));
    }
    return DebthAdherence.fromJson(json.decode(response.body));
  });

}


class DebtAnalysisEfforts {

  List <dynamic> data ;
  final Error errorObj;

  DebtAnalysisEfforts({ this.data, this.errorObj});

  factory DebtAnalysisEfforts.fromJson(Map<String, dynamic> json) {
    return DebtAnalysisEfforts(
      data : json['data']['OverallyearTicketcountEffort'],

    );
  }
}

Future<DebtAnalysisEfforts> debtAnalysisEffortsData(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;

    print(http.Response);
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return DebtAnalysisEfforts(errorObj: Error(response.reasonPhrase, statusCode));

//      throw new Exception("Error while fetching data");
    }
    return DebtAnalysisEfforts.fromJson(json.decode(response.body));
  });

}


Future <Tuple2 <Spotlight, Error>> getSpotLightCountValueFromServer(String url, {Map headers}) async {
  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
//      throw new Exception("Error while fetching data");
      return Tuple2(Spotlight(spotLightCount: 0), Error(response.reasonPhrase,statusCode));

    }
    return Tuple2(Spotlight.fromJson(json.decode(response.body)), Error("",0));
  });
}

class DebtClassfication {

  List <dynamic> data ;

  final Error errorObj;


  DebtClassfication({ this.data, this.errorObj});

  factory DebtClassfication.fromJson(Map<String, dynamic> json) {
    return DebtClassfication(
      data : json['data']['DebtList'],

    );
  }
}

Future<DebtClassfication> debtClassificationValuesFromServer(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;

    print(http.Response);
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return DebtClassfication(errorObj: Error(response.reasonPhrase, statusCode));

     // throw new Exception("Error while fetching data");
    }
    return DebtClassfication.fromJson(json.decode(response.body));
  });

}


class DebthAnalysysReports {

  final List<dynamic> ITSMResolvedTicket;
  final List<dynamic> ApplensResolvedTicket;
  final List<dynamic> DebtClassificationUpdated;

  DebthAnalysysReports(this.ITSMResolvedTicket, this.ApplensResolvedTicket, this.DebtClassificationUpdated);

}

class DebthAdherenceReports {

  final String name;
  final String id;
  final int y;
  final String color;
  final String type;
  final List<dynamic> ticketsData;

  DebthAdherenceReports(this.name, this.id, this.type, this.ticketsData, this.y, this.color);

}

class DebtAnalysyEffortsReports {

  final String name;
  final double y;
  final String drilldown;
  final List<dynamic> Activitylist;

  DebtAnalysyEffortsReports(this.name, this.y, this.drilldown, this.Activitylist);

}



class DebtClassificationModel {

  final int totalCount;
  final String classification;
  final String color;
  final int Ticketcount;
  final int AvoidableCount;
  final double AvoidablePercentage;
  final int UnAvoidableCount;
  final int ResidualNoCount;
  final int ResidualYesCount;
  final List<dynamic> DebtList;

  DebtClassificationModel(this.totalCount, this.classification, this.color, this.Ticketcount, this.AvoidableCount, this.AvoidablePercentage, this.UnAvoidableCount, this.ResidualNoCount, this.ResidualYesCount, this.DebtList);

}


class Menu extends StatefulWidget {


  final String accessToken;
  //final int roleId;
  final List< dynamic> roles;
  final bool isAdmin = false;
  final String employeeID;
  final String profileName;
  final Map<String, dynamic> userDetails;
  final List< MenuIcons> menuIcons;
  final String ProfileImage;

  Menu({Key key, @required this.accessToken, @required this.roles, this.employeeID, this.profileName, this.userDetails, this.menuIcons, this.ProfileImage}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}


class _MenuState extends State<Menu> {

  String get accessTokenValue => widget.accessToken;
 List< dynamic> get roleValue=> widget.roles;
  String get employyeID => widget.employeeID;
  String get ProfileImage => widget.ProfileImage;
  List<dynamic> menuTitleforadmin= [];
  Map<String, dynamic> get userDetails => widget.userDetails;
  List<String> projectSectionForAdmin= ["Active Run Projects", "Debt Management", "App Certification"];
  List<MenuIcons> get menuTitles => widget.menuIcons;
  List<String> projectSectionForUser= ["Debt Management"];

  List<String> spotLightSection = [  "Customer Appreciation", "KY CTS Team","KY CTS Leader", "Automation"];
  List<Icon> titlesIcon= [Icon(Icons.panorama_fish_eye),Icon(Icons.attach_money), Icon(Icons.local_parking),Icon(Icons.assistant_photo), Icon(Icons.wifi)];

  String get profileName => widget.profileName;

  List<String> menuIconsforadmin= ["Assets/265733.png","Assets/265733.png", "Assets/265733.png","Assets/265733.png", "Assets/265733.png", "Assets/265733.png","Assets/943781.png","Assets/265733.png", "Assets/265733.png","Assets/265733.png", "Assets/265733.png", "Assets/265733.png" ];
  List<String> sectionTitles= ["Projects", "SpotLight", "Location"];

  List<String> sectionTitlesForOthers= ["Debt Analysys Report","Services", "Training","SpotLight", "World Clock"];
  List<Icon> titlesIconForOthers= [Icon(Icons.insert_chart),Icon(Icons.account_circle), Icon(Icons.view_comfy), Icon(Icons.wifi), Icon(Icons.access_time)];

  List<String> clockSections = ["World Clock"];
  List<Icon> clockIcions = [Icon(Icons.access_time)];

  // List<Map<String, dynamic>> menuTitles = [{'Title':'Survey','Icon':'Assets/MenuIcons/Survey.png'},
  //   {'Title':'World Time','Icon':'Assets/MenuIcons/World_Clock.png'},
  //   {'Title':'Spot Light','Icon':'Assets/MenuIcons/Spotlight.png'},
  //   {'Title':'Diversity Module','Icon':'Assets/MenuIcons/Diversity.png'},
  //   {'Title':'Milestone','Icon':'Assets/MenuIcons/Calendar.png'},
  //   {'Title':'Training','Icon':'Assets/MenuIcons/Training.png'}];

  bool _load = false;
  bool _isPrimaryLead = false;
  bool _isSecondaryLead = false;

//  static String empID = employyeID;

  String get DEBTHREPORTS_URL => kDebtAnalysisReportsURL + employyeID;
  String get SPOTLIGHT_URL => kSpotLightURL;
  String get DEBTHADHERENCE_URL =>  kDebtAdherenceURL + employyeID;
  String get DEBTHANALYSY_EFFORTS_URL =>  kDebtEffortsURL + employyeID;
  String get DEBTHANALYSY_Classification_URL => kDebtClassificationURL + employyeID;




  static DebthAnalysysReports debthAnalysysReports;
//  static Debt debthAnalysysReports;


  Map<String, String> get headers => {
    'Authorization': 'Bearer $accessTokenValue',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static int getIntFromColor(int Red, int Green, int Blue){
    Red = (Red << 16) & 0x00FF0000; //Shift red 16-bits and mask out other stuff
    Green = (Green << 8) & 0x0000FF00; //Shift Green 8-bits and mask out other stuff
    Blue = Blue & 0x000000FF; //Mask out anything not blue.

    return 0xFF000000 | Red | Green | Blue; //0xFF000000 for 100% Alpha. Bitwise OR everything together.
  }


 Widget gridViewBasedOnSection(int section) {

   getImage(accessTokenValue,);
   int count;
   var shortestSide = MediaQuery.of(context).size.shortestSide;
   var useMobileLayout = shortestSide < 600;

   roleValue.forEach((role) {
     if (role['Name'] == 'PrimaryLead') {
       _isPrimaryLead = true;
     } else if (role['Name'] == 'SecondaryLead') {
       _isSecondaryLead = true;
     }
   });
//    double maxWidth = MediaQuery.of(context).size.width;
   if (MediaQuery.of(context).orientation == Orientation.landscape)
     if (useMobileLayout) { // Smart Phones
       count = 5;
     }
     else { // Tablets
       count = 8;
     }
   else
   if (useMobileLayout) {
     count = 3;
   }
   else {
     count = 5;
   }

   int numberOFIcons = menuTitles.length ?? 0;
   var size = MediaQuery.of(context).size;
   final double itemWidth = size.width / count;

   var aspectRatio = 0.00;
   if (MediaQuery.of(context).orientation == Orientation.landscape){
     final double itemHeight = (size.height - kToolbarHeight - 24) / 3 + 130;
     aspectRatio = itemHeight / itemWidth;
   }else {
     final double itemHeight = (size.height - kToolbarHeight - 24) / 3 - 15;
     aspectRatio = itemWidth / itemHeight;
   }
//   childAspectRatio: (itemWidth / itemHeight),
   var gridView = new GridView.builder(
     itemCount: numberOFIcons,
     gridDelegate:
     new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: count, childAspectRatio: 1),
     itemBuilder: (BuildContext context, int index) => new GestureDetector(
       onTap: () {

         if(menuTitles[index].menuTitle == 'World Clock') {
           Navigator.push(context, MaterialPageRoute(
               builder: (context)  => WorldClock()
           ));
         } else if(menuTitles[index].menuTitle == 'Survey') {
           Navigator.push(context, MaterialPageRoute(
               builder: (context)  => SurveyModule(accessToken: accessTokenValue, employeeID: employyeID, roles: roleValue,)
           ));
         }
         else if(menuTitles[index].menuTitle == 'Voice of an Abbottian') {
           Navigator.push(context, MaterialPageRoute(
               builder: (context)  => VoiceOfAnAbbottianViewController(accessToken: accessTokenValue, employeeID: employyeID,roles: roleValue, userDetails: userDetails,)
           ));
         }
         else if(menuTitles[index].menuTitle == 'Feedback') {
           Navigator.push(context, MaterialPageRoute(
             builder: (context) => FeedBackViewController(accessToken: accessTokenValue, employeeID: employyeID, roles: roleValue, userDetails: userDetails,)
           ));
         }
         else if( menuTitles[index].menuTitle == 'Diversity Dashboard') {
           Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (context) => DiversityModule(accessToken: accessTokenValue),
//                        builder: (context) => Menu(),
               ));
         }else if( menuTitles[index].menuTitle == 'Milestones') {
           Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (context) => MilestonePage(accessToken: accessTokenValue, title: 'Milestones',employeeID: employyeID,),
//                        builder: (context) => Menu(),
               ));
         }else if(menuTitles[index].menuTitle == 'Training') {
           if (_isPrimaryLead) {
             Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) => TrainingViewControllerLead(accessToken: accessTokenValue, employeeID: employyeID, isSecondaryLead: false,),
//                        builder: (context) => Menu(),
                 ));
           } else if (_isSecondaryLead) {
             Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) => TrainingViewControllerSecondLead(accessToken: accessTokenValue, employeeID: employyeID, isSecondaryLead: _isSecondaryLead,),
//                        builder: (context) => Menu(),
                 ));
           }
           else {
             Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) =>
                       TrainingViewController(
                         accessToken: accessTokenValue,
                         employeeID: employyeID,),
                 ));
           }
         } else {
           _showDialog("Coming Soon", "AID");
         }
       },
       child: new Container(
         padding: const EdgeInsets.all(0.0),
         // color: Colors.red,
         alignment: Alignment.center,
         child: new Column(
           children: <Widget>[
             new Image.asset('${menuTitles[index].assetPath}', alignment: Alignment.center,),
             SizedBox(height: 5),
             SizedBox(child: new Text("${menuTitles[index].menuTitle}", textAlign: TextAlign.center, style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.w600, color: Colors.black, ),)),
           ],
         ),
       ),
     ),

   );

   return gridView;

 }

  final leftSection = new Container(
    decoration: new BoxDecoration(
      image: new DecorationImage(image:  AssetImage('Assets/Survey.png'), fit: BoxFit.fill)
    ),

  );

//  final leftSection = new Container(
//    child:   Container(
//        decoration: new BoxDecoration(
//            image: new DecorationImage(
//                image: AssetImage('Assets/Survey.png'),
//                fit: BoxFit.cover)))
//  );

 moveToSpotLight(String urlFolder, String folderName, String titleOfScreen)
 {

   getSpotLightCount(urlFolder).then((value) {

     setState(() {
       if (value.item2.ErrorCode > 0) {
        _showDialog(value.item2.ErrorDesc, "Error");
       } else {
         Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => SpotLightState( results: value.item1, folderName: folderName, titleOfScreen: titleOfScreen, accessToken: accessTokenValue,
               ),
             ));
       }
     });
   });
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

      return new WillPopScope(
        onWillPop: () async => _requestPop(),
        //length: 2,
        child: new Scaffold(
          appBar: new AppBar(
              title: new Text("AID"),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                // action button
                IconButton(
                  icon: Icon(Icons.person), onPressed: () => _onAlertButtonsPressed(context),
                ),
              ]

          ),
          body: new Stack(children: <Widget>[new Padding(
//              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              padding: const EdgeInsets.all(8.0),
              child: gridViewBasedOnSection(0)
          ),

            new Align(
              child: loadingIndicator, alignment: FractionalOffset.center,),]),

        ),
      );
  }

//  @override
//  Widget build(BuildContext context) {
//
//
//    if(roleValue.length==0) {
//
//      Widget loadingIndicator = _load ? new Container(
//        color: Colors.grey[300],
//        width: 70.0,
//        height: 70.0,
//        child: new Padding(padding: const EdgeInsets.all(5.0),
//            child: new Center(child: new CircularProgressIndicator())),
//      ) : new Container();
//
//
//      return new WillPopScope(
//        onWillPop: () async => _requestPop(),
//        //length: 2,
//        child: new Scaffold(
//          appBar: new AppBar(
//            title: new Text("AID"),
//            automaticallyImplyLeading: false,
//              actions: <Widget>[
//                // action button
//                IconButton(
//                  icon: Icon(Icons.person), onPressed: () => _onAlertButtonsPressed(context),
//                ),
//              ]
//          ),
//          body: new Stack(children: <Widget>[new Padding(
//              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
//
////
//              child: new ListView.builder(
//                scrollDirection: Axis.vertical,
//                shrinkWrap: true,
//
//                itemBuilder: (context, i) => ExpansionTile(
//                  title: new Text("${sectionTitlesForOthers[i].toString()}"),
//                  leading: titlesIconForOthers[i],
//                  children: <Widget>[
//                    SizedBox(
//                      height: 200,
//                        child: gridViewBasedOnSection(i),
//                    ),
//                  ]
//                  ,
//                ),
//                itemCount: sectionTitlesForOthers.length,
//              )
//          ),
//
//            new Align(
//              child: loadingIndicator, alignment: FractionalOffset.center,),]),
//
//        ),
//      );
//    }
//    else  {
//
//      Widget loadingIndicator = _load ? new Container(
//        color: Colors.grey[300],
//        width: 70.0,
//        height: 70.0,
//        child: new Padding(padding: const EdgeInsets.all(5.0),
//            child: new Center(child: new CircularProgressIndicator())),
//      ) : new Container();
//
//      return new WillPopScope(
//        onWillPop: () async => _requestPop(),
//        //length: 2,
//        child: new Scaffold(
//          appBar: new AppBar(
//            title: new Text("Abbott Operation"),
//              automaticallyImplyLeading: false,
//              actions: <Widget>[
//          // action button
//                IconButton(
//                icon: Icon(Icons.person), onPressed: () => _onAlertButtonsPressed(context),
//              ),
//              ]
//
//      ),
//          body: new Stack(children: <Widget>[new Padding(
//              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
//              child: new ListView.builder(
//            scrollDirection: Axis.vertical,
//            shrinkWrap: true,
//            itemBuilder: (context, i) => ExpansionTile(
//              title: new Text("${sectionTitles[i].toString()}"),
//              leading: titlesIcon[i],
//              children: <Widget>[
//                SizedBox(height: 400.0, child: gridViewBasedOnSection(i))
//              ]
//              ,
//            ),
//            itemCount: sectionTitles.length,
//            )
//          ),
//
//              new Align(
//              child: loadingIndicator, alignment: FractionalOffset.center,),]),
//
//        ),
//      );
//    };
//  }


//         if(roleValue.length > 0) {
//
//           if (index == 1 && section == 0) { // For Debt Management
//
//             getReports().then((res) {
//               setState(() {
//                 debthAnalysysReports = res;
//
//                 getDebtAdherenceReports().then((onValue){
//
//                   getDebtAnalysisEffortsData().then((effortsData) {
//
//                     getDebtClassReports().then((classificationReports) {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => DebthAnalysysReport(
//                               accessToken: accessTokenValue,
//                               empID: employyeID,
//                               seriesList: _createSampleData(), adherenceReports: onValue, effortsReport: effortsData, debtClassReports: classificationReports, roles: roleValue, isPrimaryLead: _isPrimaryLead,),
//                           ));
//                     });
//
//
//                   });
//                 });
//               });
////                _createSampleData();
//
//             });
//           } else if (index == 0 && section == 0) { // For allocation report
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AllocationReportView(accessToken: accessTokenValue),
// //                        builder: (context) => Menu(),
//                 ));
//           }
//           else if (index == 2 && section == 0) { // For App Certification
//
//             Navigator.push(context, MaterialPageRoute(builder: (context) => AppCertificationDetails(employeeID: employyeID, accessToken: accessTokenValue,)));
//           }
//
//           else if (index == 1 && section == 1) { // Know your team mate
//
//             moveToSpotLight('kyctsteam', 'Kyctsteam', 'Know Your CTS TeamMate');
//
//           }
//           else if (index == 2 && section == 1) { // Know your CTS LEader
//
//             moveToSpotLight('kyctsleader', 'Kyctsleader', 'Know Your CTS Leader');
//           }
//           else if (index == 0 && section == 1) { // Customer Appreciations
//             moveToSpotLight('CustomerAppreciation', 'CustomerAppreciation', 'Customer Appreciation');
//
//           }
//           else if (index == 3 && section == 1) { // Automation
//
//             moveToSpotLight('Automation', 'Automation', 'Automation');
//
//           }
//           else if (index == 0 && section == 4) { // Locations
//
////             Navigator.push(
////                 context,
////                 MaterialPageRoute(
////                   builder: (context) => PinLocations(userDetails: userDetails, )
////                 ));
//
//            Navigator.push(context, MaterialPageRoute(
//              builder: (context)  => WorldClock()
//            ));
//           }
//           else {
//
//             _showDialog("Coming Soon", "AID");
//           }
//         }
//         else {
//
//           if (index == 1 && section == 3) { // Know your team mate
//
//             moveToSpotLight('kyctsteam', 'Kyctsteam', 'Know Your CTS TeamMate');
//           }
//           else if (index == 2 && section == 3) { // Know your CTS LEader
//
//             moveToSpotLight('kyctsleader', 'Kyctsleader', 'Know Your CTS Leader');
//           }
//           else if (index == 0 && section == 3) { // Customer Appreciations
//
//             moveToSpotLight('CustomerAppreciation', 'CustomerAppreciation', 'Customer Appreciation');
//           }
//           else if (index == 3 && section == 3) { // Automation
//
//             moveToSpotLight('Automation', 'Automation', 'Automation');
//           }
//           else if (index == 0 && section == 0) { // For debt management
//
//             getReports().then((res) {
//               setState(() {
//                 debthAnalysysReports = res;
//
//                 getDebtAdherenceReports().then((onValue){
//
//                   getDebtAnalysisEffortsData().then((effortsData) {
//
//                     getDebtClassReports().then((classificationReports) {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => DebthAnalysysReport(
//                               accessToken: accessTokenValue,
//                               empID: employyeID,
//                               seriesList: _createSampleData(), adherenceReports: onValue, effortsReport: effortsData, debtClassReports: classificationReports,roles: roleValue, isPrimaryLead: _isPrimaryLead,),
//                           ));
//                     });
//
//
//                   });
//                 });
//               });
////                _createSampleData();
//
//             });
//           }
//           else if (index == 0 && section == 4) { // Locations
//
////             Navigator.push(
////                 context,
////                 MaterialPageRoute(
////                     builder: (context) => PinLocations(userDetails: userDetails, )
////                 ));
//
//             Navigator.push(context, MaterialPageRoute(
//                 builder: (context)  => WorldClock()
//             ));
//           }
//           else {
//             _showDialog("Coming Soon", "AID");
//
//           }
//
//
//
//         }
  Future<bool> _requestPop() {
    // TODO
    return new Future.value(true);
  }

  static List<TicektsResolved> getChartDataModel(List<dynamic> _tickets)  {

    final  List<TicektsResolved> resolvedTickets = [];

    int initalIndex = 0;
//    var grade = initalIndex;

    _tickets.forEach((item) {

      switch(initalIndex.toString()) {
        case "0": {  resolvedTickets.add(new TicektsResolved('Jan', item)); }
        break;
        case "1": {  resolvedTickets.add(new TicektsResolved('Feb', item)); }
        break;
        case "2": {  resolvedTickets.add(new TicektsResolved('Mar', item)); }
        break;
        case "3": {  resolvedTickets.add(new TicektsResolved('Apr', item)); }
        break;
        case "4": {  resolvedTickets.add(new TicektsResolved('May', item)); }
        break;
        case "5": {  resolvedTickets.add(new TicektsResolved('Jun', item)); }
        break;
        case "6": {  resolvedTickets.add(new TicektsResolved('Jul', item)); }
        break;
        case "7": {  resolvedTickets.add(new TicektsResolved('Aug', item)); }
        break;
        case "8": {  resolvedTickets.add(new TicektsResolved('Sep', item)); }
        break;
        case "9": {  resolvedTickets.add(new TicektsResolved('Oct', item)); }
        break;
        case "10": {  resolvedTickets.add(new TicektsResolved('Nov', item)); }
        break;
        case "11": {  resolvedTickets.add(new TicektsResolved('Dec', item)); }
        break;
        default: { print("Invalid choice"); }
        break;
      }

      initalIndex ++;
    });

    return resolvedTickets;

  }



  /// Create series list with multiple series
  static List<charts.Series<TicektsResolved, String>> _createSampleData() {

    print(new DateFormat("dd/MM/yyyy", "en_US").parse("2012/01/01")); // => 2012-01-01 00:00:00.000

    int initalIndex = 0;

    List<TicektsResolved> itsmResolvedTickets = getChartDataModel(debthAnalysysReports.ITSMResolvedTicket);
    List<TicektsResolved> applensResolvedTickets = getChartDataModel(debthAnalysysReports.ApplensResolvedTicket);
    List<TicektsResolved> debthClarifictationUpdated = getChartDataModel(debthAnalysysReports.DebtClassificationUpdated);

    Color itsmColor =  Color(getIntFromColor(133,177,220));
    Color applensColor =  Color(getIntFromColor(69,66,75));
    Color debthColor =  Color(getIntFromColor(170,229,136));


//    const Color(0xFF101926);


    return [
      new charts.Series<TicektsResolved, String>(
        id: 'ITSM Resolved Tickets',
        domainFn: (TicektsResolved sales, _) => sales.months,
        measureFn: (TicektsResolved sales, _) => sales.ticekts,
          labelAccessorFn: (TicektsResolved sales, _) =>
          '${sales.ticekts.toString()}',
        colorFn: (_, __)  => charts.Color(r: itsmColor.red,
            g: itsmColor.green,
            b: itsmColor.blue,
            a: itsmColor.alpha),
        outsideLabelStyleAccessorFn: (TicektsResolved sales, _) {
          return new charts.TextStyleSpec(color: charts.MaterialPalette.red.shadeDefault);
        },
        data: itsmResolvedTickets,

      ),
      new charts.Series<TicektsResolved, String>(
        id: 'Applens Resolved Tickets',
        domainFn: (TicektsResolved sales, _) => sales.months,
        measureFn: (TicektsResolved sales, _) => sales.ticekts,
          labelAccessorFn: (TicektsResolved sales, _) =>
          '${sales.ticekts.toString()}',
        colorFn: (_, __) => charts.Color(r: applensColor.red,
            g: applensColor.green,
            b: applensColor.blue,
            a: applensColor.alpha),
        outsideLabelStyleAccessorFn: (TicektsResolved sales, _) {
          return new charts.TextStyleSpec(color: charts.MaterialPalette.red.shadeDefault);
        },
        data: applensResolvedTickets,

      ),
      new charts.Series<TicektsResolved, String>(
        id: 'Debth Classification Update',
        domainFn: (TicektsResolved sales, _) => sales.months,
        measureFn: (TicektsResolved sales, _) => sales.ticekts,
        labelAccessorFn: (TicektsResolved sales, _) =>
        '${sales.ticekts.toString()}',
        colorFn: (_, __) => charts.Color(r: debthColor.red,
            g: debthColor.green,
            b: debthColor.blue,
            a: debthColor.alpha),
        outsideLabelStyleAccessorFn: (TicektsResolved sales, _) {
          return new charts.TextStyleSpec(color: charts.MaterialPalette.red.shadeDefault); },
        data: debthClarifictationUpdated,

      ),

    ];
  }





  Future <DebthAnalysysReports> getReports() async {

    setState(() {
      _load = true; // Enable Loader
    });
    Reports p = await createPost(DEBTHREPORTS_URL, headers: headers);
    setState(() {
      if (p.errorObj != null && p.errorObj.ErrorCode == 401) {
        _showDialog("Session Expired...Please try to Login Again", "Warning");
      }
      else if (p.errorObj != null) {
        _showDialog(p.errorObj.ErrorDesc, "Error");
      }
      _load = false; // Enable Loader False
    });

    return DebthAnalysysReports(p.itsmResolvedTickets, p.applensResolvedTicket, p.debtClassificationUpdated);
  }


  Future<Tuple2<List<SpotLightImage>, Error>> getSpotLightCount(String folderName) async {

    setState(() {
      _load = true;
    });

  final result = await getSpotLightCountValueFromServer('${SPOTLIGHT_URL}${folderName}', headers: headers);
    Spotlight s = result.item1;
    Error e = result.item2;
    setState(() {
      _load = false;

      if (e.ErrorCode == 401) {
        _showDialog("Session Expired...Please try to Login Again", "Warning");
      }

    });

    List<SpotLightImage> images = new List();
    s.data.forEach((element) {
      images.add(SpotLightImage(originalPath: element['OriginalPath'], FullPath: element['FullPath']));
    });


  return  Tuple2(images, e);


  }

  Future <List<DebthAdherenceReports>> getDebtAdherenceReports() async {

   List<DebthAdherenceReports> eachReport = [];
    setState(() {
      _load = true; // Enable Loader
    });

   var debthURL = DEBTHADHERENCE_URL;
   roleValue.forEach((role) {
     if (role['Name'] == 'SecondaryLead' || role['Name'] == 'PrimaryLead')
     {
       _isPrimaryLead = true;
       debthURL = kOverAllDebtAdherenceURL + employyeID;
     }
   });


   DebthAdherence p = await debthAdherenceData(debthURL, headers: headers);

   setState(() {
     if (p.errorObj != null && p.errorObj.ErrorCode == 401) {
       _showDialog("Session Expired...Please try to Login Again", "Warning");
     }
     else if (p.errorObj != null) {
       _showDialog(p.errorObj.ErrorDesc, "Error");
     }
     _load = false; // Enable Loader False
   });
    p.data.forEach((item) {
      eachReport.add(DebthAdherenceReports(item['name'], item['id'], item['type'], item['data'], item['y'], item['color']));
    });

    return eachReport;
  }

  Future <List<DebtAnalysyEffortsReports>> getDebtAnalysisEffortsData() async {

    List<DebtAnalysyEffortsReports> eachReport = [];
    setState(() {
      _load = true; // Enable Loader
    });
    DebtAnalysisEfforts p = await debtAnalysisEffortsData(DEBTHANALYSY_EFFORTS_URL, headers: headers);

    setState(() {
      if (p.errorObj != null && p.errorObj.ErrorCode == 401) {
        _showDialog("Session Expired...Please try to Login Again", "Warning");
      }
      else if (p.errorObj != null) {
        _showDialog(p.errorObj.ErrorDesc, "Error");
      }
      _load = false; // Enable Loader False
    });
    p.data.forEach((item) {
      eachReport.add(DebtAnalysyEffortsReports(item['name'], item['y'], item['drilldown'], item['Activitylist']));
    });

    return eachReport;
  }

  Future <List<DebtClassificationModel>> getDebtClassReports() async {

    List<DebtClassificationModel> eachReport = [];
    setState(() {
      _load = true; // Enable Loader
    });


    DebtClassfication p = await debtClassificationValuesFromServer(DEBTHANALYSY_Classification_URL, headers: headers);

    setState(() {
      if (p.errorObj != null && p.errorObj.ErrorCode == 401) {
        _showDialog("Session Expired...Please try to Login Again", "Warning");
      }
      else if (p.errorObj != null) {
        _showDialog(p.errorObj.ErrorDesc, "Error");
      }
      _load = false; // Enable Loader False
    });
    p.data.forEach((item) {
      eachReport.add(DebtClassificationModel(item['TotalCount'], item['Classification'], item['color'], item['Ticketcount'],item['AvoidableCount'], item['AvoidablePercentage'], item['UnAvoidableCount'], item['ResidualNoCount'],item['ResidualYesCount'], item['DebtList']));

    });

    return eachReport;
  }

// The easiest way for creating RFlutter Alert
  _onBasicAlertPressed(context) {
    Alert(
        context: context,
        title: "RFLUTTER ALERT",
        desc: "Flutter is more awesome with RFlutter Alert.")
        .show();
  }

  // Alert with multiple and custom buttons
  _onAlertButtonsPressed(context) {
    Alert(
      context: context,
      type: AlertType.profile,
      title: profileName,
      acessToken: accessTokenValue,
      imageURL: ProfileImage,
      desc: "",
      buttons: [
        DialogButton(
          child: Text(
            "Profile",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            _showDialog("AID", "Coming Soon");
          },
          color: Colors.black12,
        ),
        DialogButton(
          child: Text(
            "Logout",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: ()  {
            Navigator.pop(context);
            exit(0);
          },
          color: Colors.black12,
        )
      ],
    ).show();
  }

  // user defined function
  void _showDialog(String message, String msgtitle) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(msgtitle),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }

  // Alert with multiple and custom buttons
  _onAlertSpotLisghtButtonsPressed(context) {
    Alert(
      context: context,
      type: AlertType.profile,
      title: profileName,
      desc: "",
      buttons: [
        DialogButton(
          child: Text(
            "Profile",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            _showDialog("AID", "Coming Soon");
          },
          color: Colors.black12,
        ),
        DialogButton(
          child: Text(
            "Logout",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: ()  {
            Navigator.pop(context);
            exit(0);
          },
          color: Colors.black12,
        )
      ],
    ).show();
  }
  getImage(String accessToken) async{
    // var client1 = new http.Client();
    // try {
    // print(await client.get('https://aid.cognizant.com/assets/img/profile/fbd976b9-f3f6-416d-88d6-60b05caa6d31.jpg', headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken", HttpHeaders.contentTypeHeader: "image/jpeg"}));
    // client.he
    // final response = await client.get('https://aid.cognizant.com/assets/img/profile/fbd976b9-f3f6-416d-88d6-60b05caa6d31.jpg',headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken", HttpHeaders.contentTypeHeader: "image/jpeg"});
    //
    // if (response.statusCode == 200) {
    //   // return parseProducts(response.body);
    // }
    //
    // HttpClient inner = new HttpClient();
    // inner.authenticate = (uri, scheme, realm) {
    //   inner.addCredentials(
    //       uri, realm, new HttpClientBasicCredentials('773777', 'Siddani@30'));
    // };
    // http.Client client = new http.Cl;
//     http.IOC
//
//
// // and use it like this
//   final request = await client.postUrl(Uri.parse(url));
//   request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
//   request.write(json.encode(body));


    // final request = await inner.getUrl(Uri.parse('https://aid.cognizant.com/assets/img/profile/fbd976b9-f3f6-416d-88d6-60b05caa6d31.jpg'));
    // HttpClientResponse response = await request.close();
    // if (response.statusCode == 200)
    //   print(response);

    // }
    // finally {
    //   client.close();
    // }

    // create an IOClient with authentication
    // HttpClient inner = new HttpClient();
    // // ignore: missing_return
    // inner.authenticate = (uri, scheme, realm) async {
    //   String password;
    //   inner.addCredentials(
    //       uri, realm, new HttpClientBasicCredentials('773777', 'Siddani@30'));
    // };
    // // http.c client = new http.IOClient(inner);
    // inner.addCredentials(
    //     u new HttpClientBasicCredentials('773777', 'Siddani@30'));

    // IOClient ioClient = new IOClient(inner);
// // and use it like this
//     http.Response response = await ioClient.get('https://aid.cognizant.com/assets/img/profile/fbd976b9-f3f6-416d-88d6-60b05caa6d31.jpg');
//     if (response.statusCode == 200)
//     HttpClient client1 = await MyHttpOverrides.getHttpClient('773777', 'Siddani@30');
//     IOClient ioClient = new IOClient(client);
//     http.Response response = await ioClient.get('https://aid.cognizant.com/assets/img/profile/fbd976b9-f3f6-416d-88d6-60b05caa6d31.jpg');
//     if (response.statusCode == 200)
//       print(response);

    // var client = http_auth.DigestAuthClient('773777', 'Siddani@30',);
    // http_auth.DigestAuthClient()
    // var response = client.get('https://aid.cognizant.com/assets/img/profile/fbd976b9-f3f6-416d-88d6-60b05caa6d31.jpg', headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken", HttpHeaders.contentTypeHeader: "image/jpeg"});
    // print(response);

   // response final url = 'https://aid.cognizant.com/assets/img/profile/fbd976b9-f3f6-416d-88d6-60b05caa6d31.jpg';

    // client.get(url).then((r) => print(r.body));

//       print(response);
  }


}



class UserAgentClient extends http.BaseClient {
  final String userAgent;
  final http.Client _inner;

  UserAgentClient(this.userAgent, this._inner);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['user-agent'] = userAgent;
    return _inner.send(request);
  }
}

/// Sample ordinal data type.
class TicektsResolved {
  final String months;
  final int ticekts;

  TicektsResolved(this.months, this.ticekts);
}




