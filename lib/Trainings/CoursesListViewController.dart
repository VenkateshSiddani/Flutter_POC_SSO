

import 'package:aid/Trainings/TrainingModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aid/CommonMethods.dart';


import '../constants.dart';
import 'TrainingAPI.dart';

class CoursesListViewController extends StatefulWidget {

  final String accessToken;
  final String employeeID;
  final List<Courses> courses;

  CoursesListViewController({Key key, @required this.accessToken, this.employeeID, this.courses}) : super(key: key);

  @override
  _CoursesListViewControllerState createState() => _CoursesListViewControllerState();
}


class _CoursesListViewControllerState extends State<CoursesListViewController> {


  String get accessTokenValue => widget.accessToken;
  String get employeeID => widget.employeeID;
  List<Courses> get defaulters => widget.courses;

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
                title: Text('Courses'),
              ),
              // body: _buildBody(),
              body: new Stack(
                children: [
                  _TrainingViewTabs(),
                ],
              ),
            ),
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
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
                                            "Course ID", FontWeight.bold, index,
                                            false),
                                        itemName("Course Name", FontWeight.bold,
                                            index, false),
                                        itemName(
                                            "Aging", FontWeight.bold, index,
                                            false),
                                        itemName(
                                            "Due Date", FontWeight.bold, index,
                                            false),
                                      ],
                                    ),
                                  ),
                                );
                              })),
//                      SizedBox(height: 20.0,),

                      new Expanded(child: ListView.separated(
                          itemCount: length,
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(color: Colors.grey[400],
                                height: 1,
                                thickness: 1,
                                indent: 20,
                                endIndent: 0,),
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  print('tapped $index');
                                },
                                child: Container(
                                  // color: (index%2==0)?Colors.grey[350] :Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        HeadeName(defaulters[index].CourseCode
                                            .toString(), FontWeight.normal,
                                            index, false),
                                        itemName(defaulters[index].CourseName
                                            .toString(), FontWeight.normal,
                                            index, false),
                                        itemName(
                                            defaulters[index].Aging.toString(),
                                            FontWeight.normal, index, false),
                                        itemName(Commonmethod
                                            .convertDateToDefaultFomrate(
                                            defaulters[index].DueDate
                                                .toString()), FontWeight.normal,
                                            index, false),

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