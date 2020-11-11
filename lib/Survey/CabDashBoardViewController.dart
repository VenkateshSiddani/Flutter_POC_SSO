import 'dart:io';

import 'package:aid/CommonMethods.dart';
import 'package:aid/Survey/SurveyModel.dart';
import 'package:aid/Trainings/TrainingModel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tuple/tuple.dart';
import 'dart:convert';
import '../constants.dart';
import 'SurveyAPI.dart';

class CabDashboardViewController extends StatefulWidget {

  final String accessToken;
  final String employeeID;
  final bool isPrimaryLead;
  CabDashboardViewController({Key key, @required this.accessToken, this.employeeID, this.isPrimaryLead}) : super(key: key);

  @override
  _CabDashboardViewControllerState createState() => _CabDashboardViewControllerState();
}


class _CabDashboardViewControllerState extends State<CabDashboardViewController> {

  RefreshController _refreshController =  RefreshController(initialRefresh: false);
  static MediaQueryData _mediaQueryData;
  static double screenHeight;
  final _pageControllerForThirdTab= PageController();
  final _currentPageNotifierForThirdTab = ValueNotifier<int>(0);
  bool get isPrimaryLead => widget.isPrimaryLead;
  bool _load = false;
  String get accessTokenValue => widget.accessToken;
  String get employeeID => widget.employeeID;
  bool _isAlertShows = false;
  bool isAPILoads = false;
  List<LocationData> locationData = List();
  List<SurveyCabDashboard> cabSurveyDashboard = List();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Map<String, String> get headers => {
    'Authorization': 'Bearer $accessTokenValue',
    'Content-Type': 'application/json',
  };
  void fetchData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none)  {
      Commonmethod.alertToShow(CONNECTIVITY_ERROR, 'AID', context);
    } else {
      getCabDetailsDashboard();
    }
  }
  getCabDetailsDashboard() {
    setState(() {
      _load = true; //
    });
    try {
      getCabSurveyDashboardDetails(CAB_DASHBOARD_SURVEY, headers: headers).then((value) {
        if (mounted) {
          if(value.item3 != null &&  value.item3.ErrorCode == 401) {
            if (!_isAlertShows)
              Commonmethod.alertToShow("Session Expired...Please try to Login Again", 'Warning', context);
          }
          else if (value.item3 != null) {
            if (!_isAlertShows)
              Commonmethod.alertToShow((value.item3.ErrorDesc), 'Error', context);
          }
          _load = false;
        }
        setState(() {
          locationData = value.item2;
          cabSurveyDashboard = value.item1;
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        });
      });

    } on SocketException catch (_) {
      setState(() {
        _load = false;
        _refreshController.loadComplete();
        _refreshController.refreshCompleted();
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);
    }
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            child: Scaffold(
              appBar: AppBar(
                title: Text(CAB_DASHBOARD),
              ),
              // body: _buildBody(),
              body: SmartRefresher (
                controller: _refreshController,
                enablePullUp: true,
                onRefresh: () async {
                  fetchData();
                },
                child: new Stack(
                  children: [
                    _buildCabDashboardView(),
                    new Align(
                      child: loadingIndicator, alignment: Alignment.center,
                    )
                  ],
                ),
              ),
            ),
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        }
    );
  }

  _buildCabDashboardView() {
    if (isAPILoads = false) {
      setState(() {
        _load = false;
      });
    }
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            _buildPageView(),
            _buildCircleIndicator(),
            // new Align(
            //   child: loadingIndicator, alignment: Alignment.centerRight,)
          ],
        ),
      ],
    );
  }


  _buildPageView() {
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData.size.height;
    double height = 0.0;
    if (MediaQuery.of(context).orientation == Orientation.landscape){
      height = screenHeight - 127.0;
    }else {
      height = screenHeight - kBottomNavigationBarHeight  - kToolbarHeight; //- 200.0;
    }
    return Container(
      height: height,
      child: PageView.builder(
          itemCount: 2,
          controller: _pageControllerForThirdTab,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: _CabSurveyDashboard(_currentPageNotifierForThirdTab.value),
            );
          },
          onPageChanged: (int index1) {
            setState(() {
              _currentPageNotifierForThirdTab.value = index1;
            });
          }),
    );
  }
  _buildCircleIndicator() {
    print('Object');
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: 2,
          currentPageNotifier: _currentPageNotifierForThirdTab,
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }



  Container _CabSurveyDashboard(int value)  {
   if(value == 0){
     return  new Container(
         child: new Stack (
           children: <Widget>[
             new Padding(
               padding: new EdgeInsets.only(top: 0),
               child: Card(
                 // decoration: myBoxDecoration(),
                 elevation: 10.0,
                 semanticContainer: false,
                 borderOnForeground: false,
                 // shadowColor: Colors.grey
                 child: new Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisSize: MainAxisSize.max,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[

                     SizedBox(height: 55.0, child: new ListView.builder( itemCount: 1, physics: const NeverScrollableScrollPhysics(),
                         itemBuilder: (context, index) {
                           return Container(
                             color : Colors.lightBlue[100],
                             child: Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: Row(
                                 children: <Widget>[
                                   HeadeName("Lead Name", FontWeight.bold, index, false),
                                   itemName("Total", FontWeight.bold, index, false),
                                   itemName("Not Completed", FontWeight.bold, index, false),
                                   itemName("Completed", FontWeight.bold, index, false),
                                 ],
                               ),
                             ),
                           );
                         })),
                     cabDashboardList(value),
//                      SizedBox(height: 20.0,),
                   ],

                 ),
               ),
             )
           ],

         )
     );
    }else if(value == 1) {
     return  new Container(
         child: new Stack (
           children: <Widget>[
             new Padding(
               padding: new EdgeInsets.only(top: 0),
               child: Card(
                 // decoration: myBoxDecoration(),
                 elevation: 10.0,
                 semanticContainer: false,
                 borderOnForeground: false,
                 // shadowColor: Colors.grey
                 child: new Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisSize: MainAxisSize.max,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[

                     SizedBox(height: 75.0, child: new ListView.builder( itemCount: 1, physics: const NeverScrollableScrollPhysics(),
                         itemBuilder: (context, index) {
                           return Container(
                             color : Colors.lightBlue[100],
                             child: Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: Row(
                                 children: <Widget>[
                                   HeadeName("Location", FontWeight.bold, index, false),
                                   itemName("Total", FontWeight.bold, index, false),
                                   itemName("Non-Transport User", FontWeight.bold, index, false),
                                   itemName("Concern Raised", FontWeight.bold, index, false),
                                   itemName("Concern not Raised", FontWeight.bold, index, false),
                                 ],
                               ),
                             ),
                           );
                         })),
                     cabDashboardList(value),
//                      SizedBox(height: 20.0,),
                   ],

                 ),
               ),
             )
           ],

         )
     );
    }
  }

  cabDashboardList(int index){

    if (index  == 0){
      if(cabSurveyDashboard.length == 0) {
        return Commonmethod.noRecordsFoundContainer("No Records Found");
      }
      return new Expanded(child:ListView.builder(
          itemCount: cabSurveyDashboard.length ?? 0,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  print('tapped $index');
                },
                child: Container(
                  color: (index%2==0)?Colors.grey[350] :Colors.white,
                  // color: Colors.green[300],
                  child:  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        itemName(cabSurveyDashboard[index].Leadname ?? "",FontWeight.normal, index, false),
                        itemName(cabSurveyDashboard[index].Totalresource.toString() ?? "",FontWeight.normal, index, false),
                        itemName(cabSurveyDashboard[index].CompletedCount.toString(),FontWeight.normal, index, false),
                        itemName(cabSurveyDashboard[index].NotCompletedCount.toString(),FontWeight.normal, index, false),

                      ],
                    ),
                  ),
                ));
          }
      )
      );
    } else if (index == 1){
      if(locationData.length == 0) {
        return Commonmethod.noRecordsFoundContainer("No Records Found");
      }
      return new Expanded(child:ListView.builder(
          itemCount: locationData.length ?? 0,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  print('tapped $index');
                },
                child: Container(
                  color: (index%2==0)?Colors.grey[350] :Colors.white,
                  // color: Colors.green[300],
                  child:  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        itemName(locationData[index].location ?? "",FontWeight.normal, index, false),
                        itemName(locationData[index].TotalResources.toString() ?? "",FontWeight.normal, index, false),
                        itemName(locationData[index].NonCabusers.toString(),FontWeight.normal, index, false),
                        itemName(locationData[index].ConcernsRaised.toString(),FontWeight.normal, index, false),
                        itemName(locationData[index].Cabusersnotraisedconcerns.toString(),FontWeight.normal, index, false),
                      ],
                    ),
                  ),
                ));
          }
      )
      );
    }
  }
  // color: (index%2==0)?Colors.grey[350] :Colors.white,
  Widget itemName(String title, FontWeight fontWeight, int index, bool makeBold) {
    FontWeight textWeight;
    if(index == 0 && makeBold){
      textWeight = FontWeight.bold;
    }else{
      textWeight = fontWeight;
    }


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
    if(index == 0 && makeBold){
      textWeight = FontWeight.bold;
    }else{
      textWeight = fontWeight;
    }
    Widget secondaryLeadName = Expanded(
      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(name, style: TextStyle(fontSize: 16, fontWeight: textWeight), textAlign: TextAlign.center,)
        ],
      ),
    );
    return secondaryLeadName;
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}


