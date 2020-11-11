
import 'dart:io';

import 'package:aid/Survey/CovidSurveyDashboard.dart';
import 'package:aid/Survey/SurveyModel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aid/constants.dart';
import 'package:aid/CommonMethods.dart';
import 'package:aid/Survey/CabDashBoardViewController.dart';
import 'package:aid/Survey/WorkLocationDashboardViewController.dart';
import 'package:aid/Survey/CabDashBoardViewController.dart';
import 'SurveyAPI.dart';


class SurveyModule extends StatefulWidget {
  SurveyModule({Key key, this.accessToken, this.employeeID}) : super(key: key);

  final String accessToken;
  final String employeeID;

  @override
  _SurveModuleState createState() => new _SurveModuleState();
}

class _SurveModuleState extends State<SurveyModule> {
  String get accessToken => widget.accessToken;
  String get employeeID => widget.employeeID;
  bool _load = false;
  bool _isAlertShows = false;

  List<SurveyList> surveyList = List();

  @override
  Widget build(BuildContext context) {

    Widget loadingIndicator = _load ? new Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),
          child: new Center(child: new CircularProgressIndicator())),
    ) : new Container();
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          title: Text(SURVEY_MODULE),
          bottom: new TabBar(
            tabs: [
              new Tab(text: "My Survey",),
              new Tab(text: "Survey Dashboard",),
            ],
          ),
        ),
        body: new TabBarView(children: [
          surveyDetailsUI(),
          surveyDetailsUI(),
        ]),

      ),
    );
  }

  // new Align(
  // child: loadingIndicator, alignment: Alignment.center,
  // )
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void fetchData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none)  {
      Commonmethod.alertToShow(CONNECTIVITY_ERROR, 'AID', context);
    } else {
      surveyList.clear();
      getDetailsSurvey();
      getCovid19DetailsSurvey();
    }
  }
  Map<String, String> get headers => {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };


  getDetailsSurvey() {
    setState(() {
      _load = true; //
    });
    try {
      getSurveyListDetails(SURVEY_LISTAPI+employeeID, headers: headers).then((value) {
        if (mounted) {
          if(value.item2 != null &&  value.item2.ErrorCode == 401) {
            if (!_isAlertShows)
              Commonmethod.alertToShow("Session Expired...Please try to Login Again", 'Warning', context);
          }
          else if (value.item2 != null) {
            if (!_isAlertShows)
              Commonmethod.alertToShow((value.item2.ErrorDesc), 'Error', context);
          }
          _load = false;
        }
        setState(() {
          // surveyList = value.item1;
          surveyList.addAll(value.item1);
        });
      });

    } on SocketException catch (_) {
      setState(() {
        _load = false;
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);
    }
  }

  getCovid19DetailsSurvey() async {
    setState(() {
      _load = true; //
    });
    try {
      SurveyModel survey = await getSurveyDetails(
          SURVEY_DETAILSAPI+employeeID, headers: headers);
      if (mounted)
        setState(() {
          if (survey.errorObj != null && survey.errorObj.ErrorCode == 401) {
            if (!_isAlertShows)
              Commonmethod.alertToShow("Session Expired...Please try to Login Again", 'Warning', context);
          }
          else if (survey.errorObj != null) {
            if (!_isAlertShows)
              Commonmethod.alertToShow((survey.errorObj.ErrorDesc), 'Error', context);
          }
          _load = false;
        });
      surveyList.add(SurveyList(surveyID: 0 , surveyName:"COVID-19" , surveyStatusName:"#Stay Home !Be Safe" , CompletedOn: survey.certifiedDate, imageName: 'Assets/Survey/COVID19.png'));

    } on SocketException catch (_) {
      setState(() {
        _load = false;
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);
    }
  }

  Widget surveyDetailsUI() {

    return new ListView.builder(itemCount: surveyList.length ?? 0,
        itemBuilder: (context, index) {
        return  InkWell(
          onTap: () {
            print('tapped $index');
            if(surveyList[index].surveyName == 'Cab Survey'){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)  => CabDashboardViewController(accessToken: accessToken, employeeID: employeeID,)));
            } else  if(surveyList[index].surveyName == 'Work Location'){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)  => WorkLocationDashboardViewController(accessToken: accessToken, employeeID: employeeID,)));
            }
            else  if(surveyList[index].surveyName == 'COVID-19'){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)  => CovidDashboard(title: "Covid 19",)));
            }

          },
          child: Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        _ThumbnailImage(surveyList[index].imageName ?? "Assets/AID_Logo.png"),
                        SizedBox(width: 20,),
                        _rightSideWidget(surveyList[index].surveyName ?? "", surveyList[index].surveyStatusName ?? "",surveyList[index].CompletedOn ?? "")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // add this
                      children: <Widget>[
                        Text('To view your submission, Click'),
                        // Spacer(),
                        _viewButtonUI(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
     });
  }

  _ThumbnailImage(String path){

    return  Container(
      child: Container(
        height: 100,
        width: 75,
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(10.0),
              topRight: const Radius.circular(10.0),
              bottomLeft: const Radius.circular(10.0),
              bottomRight: const Radius.circular(10.0),
            ),
        image: DecorationImage(
                image: AssetImage(path), fit: BoxFit.fill),
        ),
      ),

    );
  }

  // color: (index%2==0)?Colors.grey[350] :Colors.white,
  Widget _rightSideWidget(String _surveyName, String status, String Date) {
    Color color;
    if(status == '#Stay Home !Be Safe') {
      color = Colors.blue;
    }else if(status == 'Started') {
      color = Colors.yellow[600];
    }else if(status == 'Completed') {
      color = Colors.green;
    }
    Widget column = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_surveyName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.right,),
          SizedBox(height: 5,),
         Container(
           // color: Colors.red,
           width: 180,
           height: 20,
           child:  Container(
             decoration: new BoxDecoration(
                 color: color,
                 borderRadius: new BorderRadius.only(
                   topLeft: const Radius.circular(7.0),
                   topRight: const Radius.circular(7.0),
                   bottomLeft: const Radius.circular(7.0),
                   bottomRight: const Radius.circular(7.0),
                 )
             ),
             child: Align(
               alignment: Alignment.center,
               child: Text(status, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
             )
           ),
         ),
          SizedBox(height: 5,),
          Text("Completed on ${Commonmethod.convertDateToDefaultFomrate(Date)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal), textAlign: TextAlign.left,)

        ],
      ),
    );
    return column;
  }

  ToSubmitOrReviewView(){
    return MergeSemantics(
      child: ListTile(
        title: Text('To view your submission, Click'),
        trailing: _viewButtonUI(),
      ),
    );
  }

  _viewButtonUI(){
    return FlatButton(
      color: Colors.blue,
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      // padding: EdgeInsets.all(0),
      splashColor: Colors.blueAccent,
      onPressed: () {
        /*...*/
      },
      child: Text(
        "View",
        style: TextStyle(fontSize: 12.0),
      ),
    );

  }
  Widget HeadeName(String name, bool makeBold){
    FontWeight textWeight;
    if(makeBold){
      textWeight = FontWeight.bold;
    }else{
      textWeight = FontWeight.normal;
    }
    Widget secondaryLeadName = Expanded(
      child:  Text(name, style: TextStyle(fontSize: 16, fontWeight: textWeight, color: Colors.white), textAlign: TextAlign.center,),
    );
    return secondaryLeadName;
  }

}
//
// class OnePage extends StatefulWidget {
//   final Color color;
//
//   const OnePage({Key key, this.color}) : super(key: key);
//
//   @override
//   _OnePageState createState() => new _OnePageState();
// }
//
// class _OnePageState extends State<OnePage> with AutomaticKeepAliveClientMixin<OnePage> {
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return new SizedBox.expand(
//       child: new ListView.builder(
//         itemCount: 100,
//         itemBuilder: (context, index) {
//           return new Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: new Text(
//               '$index',
//               style: new TextStyle(color: widget.color),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }