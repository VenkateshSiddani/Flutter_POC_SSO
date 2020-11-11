


import 'dart:io';

import 'package:aid/Survey/SurveyModel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aid/CommonMethods.dart';
import 'package:aid/constants.dart';

import 'SurveyAPI.dart';

class Survey extends StatefulWidget {
  final String accessToken;
  final String employeeID;
  Survey({Key key, this.accessToken, this.employeeID}) : super(key: key);
  @override
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {

  String get accessToken => widget.accessToken;
  String get employeeID => widget.employeeID;
  bool _load = false;
  bool _isAlertShows = false;
  SurveyModel surveyDetails = SurveyModel();
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
      getDetailsSurvey().then((value) => surveyDetails = value);
    }
  }
  Map<String, String> get headers => {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };


  Future <SurveyModel> getDetailsSurvey() async {
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

      return survey;

    } on SocketException catch (_) {
      setState(() {
        _load = false;
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget loadingIndicator = _load ? new Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),
          child: new Center(child: new CircularProgressIndicator())),
    ) : new Container();
    return Scaffold(
        appBar: AppBar(
          title: Text("COVID-19"),
        ),
        body: new Stack(children: <Widget>[new Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            child: associateDetails(),
        ),
          new Align(
            child: loadingIndicator, alignment: FractionalOffset.center,)

        ])
    );
  }

  Widget associateDetails() {

    return new ListView.builder(  itemCount: 2,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text("Name"),
              subtitle: Text(surveyDetails.EmployeeName ?? ''),
            ),
          );

        });
  }

}