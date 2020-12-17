// //
// //

import 'dart:io';

import 'package:aid/CommonMethods.dart';
import 'package:aid/Trainings/EmployeeDefaulterViewController.dart';
import 'package:aid/Trainings/TrainingModel.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tuple/tuple.dart';
import 'dart:convert';
import '../constants.dart';
import 'TrainingAPI.dart';

class TrainingViewControllerLead extends StatefulWidget {

  final String accessToken;
  final String employeeID;
  final bool isPrimaryLead;
  final bool isSecondaryLead;
  TrainingViewControllerLead({Key key, @required this.accessToken, this.employeeID, this.isPrimaryLead, this.isSecondaryLead}) : super(key: key);

  @override
  _TrainingViewControllerLeadState createState() => _TrainingViewControllerLeadState();
}


class _TrainingViewControllerLeadState extends State<TrainingViewControllerLead> {

  RefreshController _refreshController =  RefreshController(initialRefresh: false);
  static MediaQueryData _mediaQueryData;
  static double screenHeight;
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _pageControllerForThirdTab= PageController();
  final _currentPageNotifierForThirdTab = ValueNotifier<int>(0);
  bool get isPrimaryLead => widget.isPrimaryLead;
  bool get isSecondaryLead => widget.isSecondaryLead;
  bool _load = false;
  int _cIndex = 0;
  int _bIndex = 0; // Bottom Navigation bar items
  String get accessTokenValue => widget.accessToken;
  String get employeeID => widget.employeeID;
  bool _isAlertShows = false;
  List<LeadDefaulters> CTSleadDefaulters = List<LeadDefaulters>();
  List<LeadDefaulters> ClientleadDefaulters = List<LeadDefaulters>();
  List<LeadDefaulters> leadDefaulters = List<LeadDefaulters>();

  List<CoursesList> isoTrainingList = List<CoursesList>();
  List<CoursesList> itilCourseslList = List<CoursesList>();
  List<CoursesList> admCoursesList = List<CoursesList>();
  List<CoursesList> accountCoursesList = List<CoursesList>();

  ClientTrainingDashboard Dashboard = ClientTrainingDashboard();
  ClientTrainingDashboard DashboardValues1Tab = ClientTrainingDashboard();
  ClientTrainingDashboard DashboardValues2Tab = ClientTrainingDashboard();
  ClientTrainingDashboard ClientDashboard = ClientTrainingDashboard();
  ClientTrainingDashboard CTSDashboard = ClientTrainingDashboard();

  List<String> clientTrainingTab = ['Total Associates','Total Defaulters','0-7 Days','8-15 Days','>15 Days','Total Escalations',];
  List<String> cognizantTrainingTab = ['Total Associates','Total Defaulters','Reminder 1','Reminder 2&3','Total Escalations',];
  List<String> myTrainingTab = ['Client Training Courses','Cognizant Training Courses',];
  List<String> AnalyticsTab = ['Total Defaulters',];

  int MyTotalISOTraining = 0;
  int cogpendingcounttype3 = 0;

  bool isAPILoads = false;

  void fetchData(String changingDashboardAPI, bool isFiltered, bool isSecondaryLead) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none)  {
      Commonmethod.alertToShow(CONNECTIVITY_ERROR, 'AID', context);
    } else {
      getTrainingDashboardDetails(changingDashboardAPI, isFiltered, isSecondaryLead).then((value){
        if(value != null) {
          setState(() {
            // if(_currentPageNotifier.value == 0) {
            //   ClientDashboard = value.item1;
            //   ClientleadDefaulters = value.item2;
            // }else if (_currentPageNotifier.value == 1){
            //   CTSDashboard = value.item1;
            //   CTSleadDefaulters = value.item2;
            // }
            // changingTheDashboard();
            if (_currentPageNotifier.value == 0){
              // fetchData(KGETCLIENTDASHBOARD_URL + employeeID);
              switch (_bIndex) {
                case 0:   DashboardValues1Tab = value.item1 ; break;
                default: break;
              }
            }else if (_currentPageNotifier.value == 1) {
              switch (_bIndex) {
                case 0: DashboardValues2Tab = value.item1; break;
                default: break;
              }
            }else if (_currentPageNotifier.value == 2) {
              // fetchData(KMYTRAINING_STATUS_URL + employeeIDConverstion());
            }else if (_currentPageNotifier.value == 3) {
            }
            leadDefaulters = value.item2;
            Dashboard = value.item1;

          });
        }
      });
    }
  }

  void myTrainings(String changingDashboardAPI) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none)  {
      Commonmethod.alertToShow(CONNECTIVITY_ERROR, 'AID', context);
    } else {
      getMyTrainingDashboardDetails(changingDashboardAPI).then((value){
        if(value != null) {
          setState(() {
            isoTrainingList = value;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    changingTheDashboard();
  }

  Map<String, String> get headers => {
    'Authorization': 'Bearer $accessTokenValue',
    'Content-Type': 'application/json',
  };

  @override
  Widget build(BuildContext context) {


    if (_currentPageNotifier.value == 3){
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
                title: Text(TRAININGS),
              ),
              // body: _buildBody(),
              body: SmartRefresher (
                controller: _refreshController,
                enablePullUp: true,
                onRefresh: () async {
                  changingTheDashboard();
                },
                child: new Stack(
                  children: [
                    _changeTheView(_cIndex),
                    new Align(
                      child: loadingIndicator, alignment: Alignment.center,
                    )
                  ],
                ),
              ),
            ),
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
      );
    }

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
              title: Text(TRAININGS),
            ),
            // body: _buildBody(),
            body: SmartRefresher (
              controller: _refreshController,
              enablePullUp: true,
              onRefresh: () async {
                changingTheDashboard();
              },
              child: new Stack(
                children: [
                  _changeTheView(_cIndex),
                  new Align(
                    child: loadingIndicator, alignment: Alignment.center,
                  )
                ],
              ),
            ),
            bottomNavigationBar:BottomNavigationBar(
              currentIndex: _bIndex,
              type: BottomNavigationBarType.fixed ,
              items: changeTheBottomUI(),
              // items: [
              //   bottomCustomNavigationBar('Total Associates', Dashboard.TotalAssociatesCount ?? 0,Icon(Icons.home,color: Color.fromARGB(255, 0, 0, 0)) ),
              //   bottomCustomNavigationBar('Total Defaulters', 20,Icon(Icons.speaker,color: Color.fromARGB(255, 0, 0, 0)) ),
              //   //   bottomCustomNavigationBar('0-7 Days', Dashboard.GreenCountDisplay ?? 0,Icon(Icons.speaker,color: Color.fromARGB(255, 0, 0, 0)) ),
              //   // bottomCustomNavigationBar('8-15 Days', Dashboard.AmberCountDisplay ?? 0,Icon(Icons.speaker,color: Color.fromARGB(255, 0, 0, 0)) ),
              //   // bottomCustomNavigationBar('>15 Days', Dashboard.RedCountDisplay ?? 0,Icon(Icons.speaker,color: Color.fromARGB(255, 0, 0, 0)) ),
              //   // bottomCustomNavigationBar('Total Escalations', Dashboard.TotalEscalationcount ?? 0,Icon(Icons.speaker,color: Color.fromARGB(255, 0, 0, 0)) ),
              // //  ( clientDashboard.GreenCount ?? 0 + clientDashboard.AmberCount ?? 0 + clientDashboard.RedCount ?? 0)
              // ],
              onTap: (index){
                _bottomSegmentTabAction(index);
              },
            ),
          ),
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
    );
  }

  List<BottomNavigationBarItem> changeTheBottomUI(){
    List<BottomNavigationBarItem> items = List();
    if (_currentPageNotifier.value == 0){
      clientTrainingTab.asMap().forEach((i,element) {
        int count = 0;
        switch (i) {
          case 0: count = DashboardValues1Tab.TotalCount ?? 0; break;
          case 1: count = DashboardValues1Tab.TotalDefaulterCount ?? 0; break;
          case 2: count = DashboardValues1Tab.GreenCountDisplay ?? 0; break;
          case 3: count = DashboardValues1Tab.AmberCountDisplay ?? 0; break;
          case 4: count = DashboardValues1Tab.RedCountDisplay ?? 0; break;
          case 5: count = DashboardValues1Tab.TotalEscalationcount ?? 0; break;
          default: break;
        }
        items.add(bottomCustomNavigationBar(element, count,Icon(Icons.indeterminate_check_box,color: Color.fromARGB(255, 0, 0, 0))));
      });
    }else if (_currentPageNotifier.value == 1) {
      cognizantTrainingTab.asMap().forEach((i,element) {
        int count = 0;
        switch (i) {
          case 0: count = DashboardValues2Tab.TotalCount ?? 0; break;
          case 1: count = DashboardValues2Tab.TotalDefaulterCount ?? 0; break;
          case 2: count = DashboardValues2Tab.GreenCountDisplay ?? 0; break;
          case 3: count = DashboardValues2Tab.AmberCountDisplay ?? 0; break;
          case 4: count = DashboardValues2Tab.RedCountDisplay ?? 0; break;
          default: break;
        }
        items.add(bottomCustomNavigationBar(element, count,Icon(Icons.indeterminate_check_box,color: Color.fromARGB(255, 0, 0, 0))));
      });
    }else if (_currentPageNotifier.value == 2) {
      myTrainingTab.asMap().forEach((i,element) {
        int count = 0;
        switch (i) {
          case 0: count = MyTotalISOTraining ?? 0; break;
          case 1: count = cogpendingcounttype3 ?? 0; break;
          default: break;
        }
        items.add(bottomCustomNavigationBar(
            element, count,
            Icon(Icons.indeterminate_check_box, color: Color.fromARGB(255, 0, 0, 0))));
      });
      // }
    }else if (_currentPageNotifier.value == 3) {
      // myTrainingTab.forEach((element) {
      //   items.add(bottomCustomNavigationBar(element, Dashboard.TotalAssociatesCount ?? 0,Icon(Icons.home,color: Color.fromARGB(255, 0, 0, 0))));
      // });
      // items.add(value)
    }
    return items;
  }

  bottomCustomNavigationBar(String title, int count, Icon icon){
    return BottomNavigationBarItem(
      icon: new Stack(
        children: <Widget>[
          icon,
          new Positioned(
            right: 0,
            child: new Container(
              padding: EdgeInsets.all(1),
              decoration: new BoxDecoration(
                color: Colors.red[500],
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: new Text(
                '$count',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
      title: AutoSizeText(title, maxLines: 2, textAlign: TextAlign.center,),
    );
  }

  _buildtrainingsView() {
    if (isAPILoads = false) {
      setState(() {
        _load = false;
      });
    }
    if (_currentPageNotifier.value == 2 && _bIndex == 1){
      return Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              _buildPageView(),
              _buildCircleIndicatorForCircle(),
              // new Align(
              //   child: loadingIndicator, alignment: Alignment.centerRight,)
            ],
          ),
        ],
      );
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

  _buildDashBoardSpeak() {

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("Assets/DiversityBG.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              _buildCircleIndicatorForCircle(),
              // new Align(
              //   child: loadingIndicator, alignment: Alignment.centerRight,)
            ],
          ),
        ],
      ),
    );
  }

  _buildPageView() {
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData.size.height;
    double height = 0.0;
    if (MediaQuery.of(context).orientation == Orientation.landscape){
      height = screenHeight - 127.0;
    }else {
      height  = screenHeight - kBottomNavigationBarHeight - kToolbarHeight - 72;
    }
    int pages = 4;
    if (_currentPageNotifier.value == 2 && _bIndex == 1){
      pages = 3;
    }
    int submodule = null;
    if(pages == 3){
      submodule = 0;
    }
    if (_currentPageNotifier.value == 2 && _bIndex == 1){
      return Container(
        height: height,
        child: PageView.builder(
            itemCount: 3,
            controller: _pageControllerForThirdTab,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: _TrainingViewTabs(_currentPageNotifier.value, _currentPageNotifierForThirdTab.value),
              );
            },
            onPageChanged: (int index1) {
              setState(() {
                _currentPageNotifierForThirdTab.value = index1;
              });
            }),
      );
    } else {
      return Container(
        height: height,
        child: PageView.builder(
            itemCount: 4,
            controller: _pageController,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: _TrainingViewTabs(_currentPageNotifier.value, null),
              );
            },
            onPageChanged: (int index) {
              setState(() {
                _currentPageNotifier.value = index;
                _bIndex = 0;
                // if(_currentPageNotifier.value == 2 ) {
                //   if(_bIndex > 1) {
                //     _bIndex = 0;
                //   }
                // }
                changingTheDashboard();
              });
            }),
      );
    }
  }
  _buildCircleIndicator() {
    if (_currentPageNotifier.value == 2 && _bIndex == 1){
      print('Object');
      return Positioned(
        left: 0.0,
        right: 0.0,
        bottom: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CirclePageIndicator(
            itemCount: 3,
            // dotColor: Colors.red,
            // selectedDotColor: Colors.green,
            currentPageNotifier: _currentPageNotifierForThirdTab,
          ),
        ),
      );
    }
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: 4,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }

  _buildCircleIndicatorForCircle() {
    // if (_currentPageNotifier.value == 2 && _bIndex == 1){
    //   // fetchData(KGETCLIENTDASHBOARD_URL + employeeID);
    //   print('Object');
    //   pages = pageInbdicatorForThirdTab;
    // }
    if (_currentPageNotifier.value == 2 && _bIndex == 1){
      return Positioned(
        left: 0.0,
        right: 0.0,
        bottom: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CirclePageIndicator(
            itemCount: 3,
            currentPageNotifier: _currentPageNotifierForThirdTab,
          ),
        ),
      );
    }
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: 4,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }

  _buildCircleIndicatorForCircle1() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: 3,
          currentPageNotifier: _currentPageNotifierForThirdTab,
        ),
      ),
    );
  }
  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
      _changeTheView(_cIndex);
    });
  }

  void _bottomSegmentTabAction(index) {
    setState(() {
      _bIndex = index;
      if (_currentPageNotifier.value == 2 && _bIndex == 1){
        print('Object');
      }
      changingTheDashboard();
    });
  }
  _changeTheView(int index) {

    if(index == 0)
      return _buildtrainingsView();
  }

  Container _TrainingViewTabs(int value, int subModule)  {

    if (value == 2){ // My Trainings UI
      List<CoursesList> data = List<CoursesList>();
      String title = 'Client Training Courses';
      String headerTitle = '';
      switch (subModule) {
        case 0: { title = 'Account Courses'; headerTitle = ''; break;}
        case 1: { title = 'ADM Courses'; headerTitle = ''; break;}
        case 2: {  title = 'ITIL Courses'; headerTitle = ''; break;}
        default:
          break;
      }
      if(subModule == null) {
        data = isoTrainingList;
      }else if (subModule == 2) {
        data = itilCourseslList;
      }
      else if (subModule == 1) {
        data = admCoursesList;
      }
      else if (subModule == 0) {
        data = accountCoursesList;
      }
      int length = data.length ?? 0;
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
                      SizedBox(height: 45.0, child: new ListView.builder(  itemCount: 1, physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              color : Colors.lightBlue[100],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: <Widget>[
                                    HeadeName(title, FontWeight.w900,index,false),
                                  ],
                                ),
                              ),
                            );

                          })),
                      SizedBox(height: 55.0, child: new ListView.builder( itemCount: 1, physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              color : Colors.lightBlue[100],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: <Widget>[
                                    // HeadeName("Course ID", FontWeight.bold, index, false),
                                    // itemName("Course Name", FontWeight.bold, index, false),
                                    // itemName("Aging", FontWeight.bold, index, false),
                                    // itemName("Status", FontWeight.bold, index, false),
                                    itemName("Course ID -- Course Name -- Aging", FontWeight.bold, index, false)
                                  ],
                                ),
                              ),
                            );
                          })),
                      coursesTable(data),
//                      SizedBox(height: 20.0,),
                    ],

                  ),
                ),
              )
            ],

          )
      );
    }
    else{
      String title = '';
      String headerTitle = '';
      switch (value) {
        case 0: { title = 'Client Training'; headerTitle = 'Lead'; break;}
        case 1: { title = 'Cognizant Training'; headerTitle = 'Cognizant Training'; break;}
        case 2: {  title = 'My Training'; headerTitle = 'My Training'; break;}
        case 3: { title = 'Analytics'; headerTitle = 'Analytics'; break;}
        default:
          break;
      }
      int length = leadDefaulters.length ?? 0;
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
                      SizedBox(height: 45.0, child: new ListView.builder(  itemCount: 1, physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              color : Colors.lightBlue[100],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: <Widget>[
                                    HeadeName(title, FontWeight.w900,index,false),
                                  ],
                                ),
                              ),
                            );

                          })),
                      SizedBox(height: 70.0, child: new ListView.builder( itemCount: 1, physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              color : Colors.lightBlue[100],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: <Widget>[
                                    HeadeName(headerTitle, FontWeight.bold, index, false),
                                    itemName("# Associates", FontWeight.bold, index, false),
                                    itemName("# Defaulters", FontWeight.bold, index, false),
                                    itemName("# Pending Trainings", FontWeight.bold, index, false),
                                  ],
                                ),
                              ),
                            );
                          })),
                      TrainingDataTable(length),
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

  coursesTable(List<CoursesList> data){
    if(data.length == 0) {
      return Commonmethod.noRecordsFoundContainer("No Records Found");
    }
    return new Expanded(child:ListView.builder(
        itemCount: data.length ?? 0,
        itemBuilder: (context, index) {
          final details = '${data[index].CourseCode.toString()} -- ${data[index].CourseName.toString()} -- ${data[index].Aging.toString()}';
          return InkWell(
              onTap: () {
                print('tapped $index');
              },
              child: Container(
                color: (index%2==0)?Colors.grey[350] :Colors.white,
                child:  Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // HeadeName(data[index].CourseCode.toString(), FontWeight.normal, index,false),
                      itemName(details,FontWeight.normal, index, false),
                      _circleContaierForIndication(data[index].Status.toString()),
                      // itemName(data[index].Aging.toString(), FontWeight.normal, index, false),
                      // itemName(data[index].Status.toString(), FontWeight.normal, index, false),

                    ],
                  ),
                ),
              ));
        }
    )
    );
  }

  _circleContaierForIndication(String type){
    Color changeTheColor = Colors.yellow[600]; // By default
    if(type == "Completed") {
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
  TrainingDataTable(int length){
    if (length == 0){
      return Commonmethod.noRecordsFoundContainer('No Records Found');
    } else {
      return new Expanded(child:ListView.builder(
          itemCount: length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  print('tapped $index');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeDefaulterViewController(accessToken: accessTokenValue,employeeID: employeeID, defaulters: leadDefaulters[index].EmployeeList,),
//                        builder: (context) => Menu(),
                      ));
                },
                child: Container(
                  color: (index%2==0)?Colors.grey[350] :Colors.white,
                  child:  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        HeadeName(leadDefaulters[index].LeadName, FontWeight.normal, index,false),
                        itemName(leadDefaulters[index].TotalAssociatesCount.toString(),FontWeight.normal, index, false),
                        itemName(leadDefaulters[index].DefaulterCount.toString(), FontWeight.normal, index, false),
                        itemName(leadDefaulters[index].TrainingCount.toString(), FontWeight.normal, index, false),
                        Divider(),
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

  Future <Tuple2<ClientTrainingDashboard, List<LeadDefaulters>>> getTrainingDashboardDetails(String selectingDashboardAPI, bool isFiltered, bool isSecondaryLead) async {

    setState(() {
      _load = true; //
    });
    try {
      ClientTrainingDashboard module = await getClientTrainingDashboardDetailsAPI(isFiltered,
        selectingDashboardAPI, headers: headers,);
      if (mounted)
        setState(() {
          if (module.errorObj != null && module.errorObj.ErrorCode == 401) {
            if (!_isAlertShows)
              Commonmethod.alertToShow("Session Expired...Please try to Login Again", "Warning",context);
          }
          else if (module.errorObj != null) {
            if (!_isAlertShows)
              Commonmethod.alertToShow(module.errorObj.ErrorDesc, "Error",context);
          }
          _load = false;
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        });

      isAPILoads = true;
      leadDefaulters.clear();
      if(isFiltered) {
        module.filterData.forEach((element) {
          List<dynamic> defaulters = element['EmployeeList']  ?? List();;
          List<DefalterEmployee>  defalterEmployee = List<DefalterEmployee>();
          defaulters.forEach((element1) {
            List<dynamic> courselist = element1['courselist'] ?? List();
            List<Courses>  coursesList1 = List<Courses>();

            courselist.forEach((element2) {
              coursesList1.add(Courses(CourseCode: element2['CourseCode'],CourseName:element2['CourseName'] ,Aging:element2['Aging'] , DueDate:element2['DueDate'] ));
            });
            defalterEmployee.add(DefalterEmployee(Employeeid: element1['Employeeid'], EmployeeName: element1['EmployeeName'],Grade:element1['Grade'],Department:element1['Department'] ,Country:element1['Country'] ,TotalCourses: element1['TotalCourses'], courseslist: coursesList1));
          });
          leadDefaulters.add(LeadDefaulters(LeadName: element['LeadName'],TotalAssociatesCount: element['TotalAssociatesCount'],DefaulterCount: element['DefaulterCount'], TrainingCount:element['TrainingCount'], EmployeeList:defalterEmployee, RedCountDisplay: element['RedCountDisplay'], AmberCountDisplay: element['AmberCountDisplay'], GreenCountDisplay: element['GreenCountDisplay'], TotalEscalationcount: element['TotalEscalationcount'] ));
        });
        return Tuple2(module,leadDefaulters);
      }
      // else if(isSecondaryLead) {
        // List<dynamic> defaulters1 = module.data['EmployeeList']  ?? List();;
        // defaulters1.forEach((element) {
        //   // List<dynamic> defaulters = element['EmployeeList']  ?? List();;
        //   // List<DefalterEmployee>  defalterEmployee = List<DefalterEmployee>();
        //   defaulters1.forEach((element1) {
        //     List<dynamic> courselist = element1['courselist'] ?? List();
        //     List<Courses>  coursesList1 = List<Courses>();
        //
        //     courselist.forEach((element2) {
        //       coursesList1.add(Courses(CourseCode: element2['CourseCode'],CourseName:element2['CourseName'] ,Aging:element2['Aging'] , DueDate:element2['DueDate'] ));
        //     });
        //     defalterEmployee.add(DefalterEmployee(Employeeid: element1['Employeeid'], EmployeeName: element1['EmployeeName'],Grade:element1['Grade'],Department:element1['Department'] ,Country:element1['Country'] ,TotalCourses: element1['TotalCourses'], courseslist: coursesList1));
        //   });
        //   leadDefaulters.add(LeadDefaulters(LeadName: element['LeadName'],TotalAssociatesCount: element['TotalAssociatesCount'],DefaulterCount: element['DefaulterCount'], TrainingCount:element['TrainingCount'], EmployeeList:defalterEmployee, RedCountDisplay: element['RedCountDisplay'], AmberCountDisplay: element['AmberCountDisplay'], GreenCountDisplay: element['GreenCountDisplay'], TotalEscalationcount: element['TotalEscalationcount'] ));
        // });
        // return Tuple2(module,leadDefaulters);
      // }
        else {
        module.Leadlist.forEach((element) {
          List<dynamic> defaulters = element['EmployeeList']  ?? List();;
          List<DefalterEmployee>  defalterEmployee = List<DefalterEmployee>();
          defaulters.forEach((element1) {
            List<dynamic> courselist = element1['courselist'] ?? List();
            List<Courses>  coursesList1 = List<Courses>();

            courselist.forEach((element2) {
              coursesList1.add(Courses(CourseCode: element2['CourseCode'],CourseName:element2['CourseName'] ,Aging:element2['Aging'] , DueDate:element2['DueDate'] ));
            });
            defalterEmployee.add(DefalterEmployee(Employeeid: element1['Employeeid'], EmployeeName: element1['EmployeeName'],Grade:element1['Grade'],Department:element1['Department'] ,Country:element1['Country'] ,TotalCourses: element1['TotalCourses'], courseslist: coursesList1));
          });
          leadDefaulters.add(LeadDefaulters(LeadName: element['LeadName'],TotalAssociatesCount: element['TotalAssociatesCount'],DefaulterCount: element['DefaulterCount'], TrainingCount:element['TrainingCount'], EmployeeList:defalterEmployee, RedCountDisplay: element['RedCountDisplay'], AmberCountDisplay: element['AmberCountDisplay'], GreenCountDisplay: element['GreenCountDisplay'], TotalEscalationcount: element['TotalEscalationcount'] ));
        });
        return Tuple2(module,leadDefaulters);
      }
    } on SocketException catch (_) {
      // print('not connected');
      setState(() {
        _load = false;
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, "AID",context);
    }
  }

  Future <List<CoursesList>> getMyTrainingDashboardDetails(String selectingDashboardAPI) async {

    setState(() {
      _load = true; //
    });
    try {
      MyTrainingDashboard module = await getMyTrainingDashboardDetailsAPI(
          selectingDashboardAPI, headers: headers);
      if (mounted)
        setState(() {
          if (module.errorObj != null && module.errorObj.ErrorCode == 401) {
            if (!_isAlertShows)
              Commonmethod.alertToShow("Session Expired...Please try to Login Again", "Warning",context);
          }
          else if (module.errorObj != null) {
            if (!_isAlertShows)
              Commonmethod.alertToShow(module.errorObj.ErrorDesc, "Error",context);
          }
          _load = false;
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        });

      isAPILoads = true;
      // isoTrainingList.clear();
      List<dynamic> list = module.data['ISOReport'] ?? List();
      List<CoursesList> isoList = List();
      List<dynamic> itilObject = module.data['Typelist'][0]['CognizantTrainingList'] ?? List();;
      List<dynamic> accountCoursesObject = module.data['Typelist'][1]['CognizantTrainingList'] ?? List();;
      List<dynamic> admCoursesObject = module.data['Typelist'][2]['CognizantTrainingList'] ?? List();;

      MyTotalISOTraining = module.data['MyTotalISOTraining'] as int ?? 0;
      cogpendingcounttype3 = module.data['cogpendingcounttype3'] as int ?? 0;

      isoTrainingList = List<CoursesList>();
      itilCourseslList = List<CoursesList>();
      admCoursesList = List<CoursesList>();
      accountCoursesList = List<CoursesList>();

      list.forEach((element) {
        isoList.add(CoursesList(CourseName: element['CourseName'],CourseCode:element['CourseCode'] ,Status:element['Status'] ,CompletedDate:element['CompletedDate'] ,DueDate: element['DueDate'],Aging: element['Aging'] ));
      });

      itilObject.forEach((element) {
        itilCourseslList.add(CoursesList(CourseName: element['CourseName'],CourseCode:element['CourseCode'] ,Status:element['Status'] ,CompletedDate:element['CompletedDate'] ,DueDate: element['DueDate'],Aging: element['Aging'] ));
      });
      accountCoursesObject.forEach((element) {
        admCoursesList.add(CoursesList(CourseName: element['CourseName'],CourseCode:element['CourseCode'] ,Status:element['Status'] ,CompletedDate:element['CompletedDate'] ,DueDate: element['DueDate'],Aging: element['Aging'] ));
      });
      admCoursesObject.forEach((element) {
        accountCoursesList.add(CoursesList(CourseName: element['CourseName'],CourseCode:element['CourseCode'] ,Status:element['Status'] ,CompletedDate:element['CompletedDate'] ,DueDate: element['DueDate'],Aging: element['Aging'] ));
      });

      return isoList;
    } on SocketException catch (_) {
      // print('not connected');
      setState(() {
        _load = false;
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, "AID",context);
    }
  }
  void changingTheDashboard(){
    Dashboard = ClientTrainingDashboard();
    leadDefaulters = List<LeadDefaulters>();

    // if (_currentPageNotifier.value == 0 && ClientDashboard.Employeeid != null){
    //   Dashboard = ClientDashboard;
    //   leadDefaulters = ClientleadDefaulters;
    // }else if (_currentPageNotifier.value == 1 && CTSDashboard.Employeeid != null) {
    //   Dashboard = CTSDashboard;
    //   leadDefaulters = CTSleadDefaulters;
    // }
    //
    // if (_currentPageNotifier.value == 0 && ClientDashboard.Employeeid == null){
    //   fetchData(KGETCLIENTDASHBOARD_URL);
    // }else if (_currentPageNotifier.value == 1 && CTSDashboard.Employeeid == null) {
    //   fetchData(KCOGNIZANTDASHBOARD_URL);
    // }
    if (_currentPageNotifier.value == 0){
      // fetchData(KGETCLIENTDASHBOARD_URL + employeeID);
      switch (_bIndex) {
        case 0: fetchData(KGETCLIENTDASHBOARD_URL + employeeID + '&role=PrimaryLead', false, isSecondaryLead); break;
        case 1: fetchData(KDEFAULTER_DISPLAYCLIENT + employeeID + '&role=PrimaryLead', true, isSecondaryLead); break;
        case 2: fetchData(KFILTER_ASSOCIATES + employeeID + '&min=0&max=8&role=PrimaryLead', true, isSecondaryLead); break;
        case 3: fetchData(KFILTER_ASSOCIATES + employeeID + '&min=7&max=16&role=PrimaryLead', true, isSecondaryLead);break;
        case 4: fetchData(KFILTER_ASSOCIATES + employeeID + '&min=15&max=100&role=PrimaryLead', true, isSecondaryLead); break;
        case 5: fetchData(KFILTER_ASSOCIATES + employeeID + '&min=15&max=100&role=PrimaryLead', true, isSecondaryLead); break;
        default: break;
      }
    }else if (_currentPageNotifier.value == 1) {
      switch (_bIndex) {
        case 0: fetchData(KCOGNIZANTDASHBOARD_URL + employeeID + '&role=PrimaryLead', false, isSecondaryLead); break;
        case 1: fetchData(KDEFAULTER_DISPLAY + employeeID + '&role=PrimaryLead', true, isSecondaryLead); break;
        case 2: fetchData(KREMIDER_1 + employeeID + '&Remaindertype1=R1&Remaindertype2=R1&role=PrimaryLead', true, isSecondaryLead); break;
        case 3: fetchData(KREMIDER_1 + employeeID + '&Remaindertype1=R2&Remaindertype2=R3&role=PrimaryLead', true, isSecondaryLead); break;
        case 4: fetchData(KREMIDER_1 + employeeID + '&Remaindertype1=E&Remaindertype2=E&role=PrimaryLead', true, isSecondaryLead); break;
        default: break;
      }

    }else if (_currentPageNotifier.value == 2) {
      // fetchData(KMYTRAINING_STATUS_URL + employeeIDConverstion());
      myTrainings(KMYTRAINING_STATUS_URL + employeeIDConverstion());
    }else if (_currentPageNotifier.value == 3) {
      fetchData(KANALYTICS_STATUS_URL, false, isSecondaryLead);
    }
    setState(() {

    });
  }

  String employeeIDConverstion(){
    String credentials = employeeID;
    // var encoded = utf8.encode(credentials);

    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String encoded = stringToBase64Url.encode(credentials);      // dXNlcm5hbWU6cGFzc3dvcmQ=
    String decoded = stringToBase64Url.decode(encoded);      // dXNlcm5hbWU6cGFzc3dvcmQ=
    // return encoded;
    return "PBqPO%2Fjl99Ga9Ba%2BkkfPEg%3D%3D";
  }
}

// import 'package:flutter/material.dart';
//
// void main() => runApp(new MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter Demo',
//       theme: new ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: new MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: new Scaffold(
//         appBar: new AppBar(
//           bottom: new TabBar(
//             tabs: [
//               new Tab(icon: new Icon(Icons.directions_car)),
//               new Tab(icon: new Icon(Icons.directions_transit)),
//               new Tab(icon: new Icon(Icons.directions_bike)),
//               new Tab(
//                 icon: new Icon(Icons.airplanemode_active),
//               )
//             ],
//           ),
//         ),
//         body: new TabBarView(children: [
//           new OnePage(color: Colors.black,),
//           new OnePage(color: Colors.green,),
//           new OnePage(color: Colors.red,),
//           new OnePage(color: Colors.blue,),
//         ]),
//       ),
//     );
//   }
// }
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