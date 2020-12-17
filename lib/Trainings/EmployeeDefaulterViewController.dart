

import 'dart:io';

import 'package:aid/CommonMethods.dart';
import 'package:aid/Trainings/CoursesListViewController.dart';
import 'package:aid/Trainings/TrainingModel.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../constants.dart';
import 'TrainingAPI.dart';

class EmployeeDefaulterViewController extends StatefulWidget {

  final String accessToken;
  final String employeeID;
  final List<DefalterEmployee> defaulters;

  EmployeeDefaulterViewController({Key key, @required this.accessToken, this.employeeID, this.defaulters}) : super(key: key);

  @override
  _EmployeeDefaulterViewControllerState createState() => _EmployeeDefaulterViewControllerState();
}


class _EmployeeDefaulterViewControllerState extends State<EmployeeDefaulterViewController> {


  String get accessTokenValue => widget.accessToken;
  String get employeeID => widget.employeeID;
  List<DefalterEmployee> get defaulters => widget.defaulters;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Employee Defaulters'),
              ),
              // body: _buildBody(),
              body: new Stack(
                children: [
                  _TrainingViewTabs(),
                ],
              ),
            ),
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
          );
        }
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }


  Container _TrainingViewTabs()  {
    String title = '';
    String headerTitle = '';
    int length = defaulters.length ?? 0;
    if (length == 0){
      return Commonmethod.noRecordsFoundContainer('No Records Found');
    } else {
      return new Container(
          child: new Stack (
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(top: 5.0),
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
                      SizedBox(height: 55.0,
                          child: new ListView.builder(itemCount: 1,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  color: Colors.lightBlue[100],
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: <Widget>[
                                        HeadeName(
                                            "Employee ID", FontWeight.bold,
                                            index, false),
                                        itemName(
                                            "Employee Name", FontWeight.bold,
                                            index, false),
                                        itemName(
                                            "Grade", FontWeight.bold, index,
                                            false),
                                        itemName(
                                            "Pending Courses", FontWeight.bold,
                                            index, false),
                                      ],
                                    ),
                                  ),
                                );
                              })),
//                      SizedBox(height: 20.0,),

                      new Expanded(child: ListView.builder(
                          itemCount: length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  print('tapped $index');
                                  int coursesList = defaulters[index]
                                      .courseslist.length  ?? 0;
                                  if (coursesList > 0) {

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CoursesListViewController(
                                                accessToken: accessTokenValue,
                                                employeeID: employeeID,
                                                courses: defaulters[index]
                                                    .courseslist,),
//                        builder: (context) => Menu(),
                                        ));
                                  }

                                },
                                child: Container(
                                  color: (index % 2 == 0)
                                      ? Colors.grey[350]
                                      : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        HeadeName(defaulters[index].Employeeid
                                            .toString(), FontWeight.normal,
                                            index, false),
                                        itemName(defaulters[index].EmployeeName
                                            .toString(), FontWeight.normal,
                                            index, false),
                                        itemName(
                                            defaulters[index].Grade.toString(),
                                            FontWeight.normal, index, false),
                                        itemName(defaulters[index].TotalCourses
                                            .toString(), FontWeight.normal,
                                            index, false),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                ));
                          }
                      )
                      )
                    ],

                  ),
                ),
              )
            ],

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
    // the Expanded widget lets the columns share the space
    Widget column = Expanded(
      child: Column(
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 14, fontWeight: textWeight), textAlign: TextAlign.center,),
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
          Text(name, style: TextStyle(fontSize: 14, fontWeight: textWeight), textAlign: TextAlign.center,)
        ],
      ),
    );
    return secondaryLeadName;
  }
}