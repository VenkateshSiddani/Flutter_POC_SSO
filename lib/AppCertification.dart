import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'constants.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Error {

  String ErrorDesc;
  int ErrorCode;

  Error(this.ErrorDesc, this.ErrorCode);
}


class AppCerification {

  Map<String, dynamic> data ;
  final List<dynamic> applicationList;

  final List<dynamic> domainCountList;

  final Error errorObj;


  AppCerification({ this.data, this.applicationList, this.domainCountList, this.errorObj});

  factory AppCerification.fromJson(Map<String, dynamic> json) {
    return AppCerification(
      data : json['data'],
      applicationList: json['data']['ApplicationList'],
      domainCountList: json['data']['DomainCountList'],
    );
  }
}

Future<AppCerification> getAppCertificationCount(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;

    print(http.Response);
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return AppCerification(errorObj: Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    return AppCerification.fromJson(json.decode(response.body));
  });
}



class AppCertificationMdel {

  final String RNDName;
  final int totalApplicationCount;
  final int certApplicationCount;


  AppCertificationMdel( this.RNDName, this.totalApplicationCount, this.certApplicationCount);

}

class AppCertificationDetails extends StatefulWidget {


  final String employeeID;
  final String accessToken;
  AppCertificationDetails({Key key, @required this.employeeID, this.accessToken}) : super(key: key);

  @override
  _AppCertificationDetailsState createState() => _AppCertificationDetailsState();
}


class _AppCertificationDetailsState extends State<AppCertificationDetails> {


  int selectedIndex = 0;

//  String TitleClicked= "";

  String get accessToken => widget.accessToken;
  String get employeeID => widget.employeeID;

  static List<AppCertificationMdel> applicationCountList = new List();
  final RefreshController _refreshController = RefreshController();

  List<AppCertificationMdel> domainCountList = [];

  int _currentSelection = 0;


  Map<String, String> get headers => {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };


  Map<int, Widget> _children() => {
    0: Text('Application List'),
    1: Text('Domain List'),
  };


  bool _load = false;

  void fetchData() {

    getAppCertification().then((res) {
      setState(() {
        applicationCountList = res;
      });
    });

  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    final title = "App Certification";

    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;
    double rowHeight;

    if (useMobileLayout) { // Smart Phones
      rowHeight = 88;
    }
    else { // Tablets
      rowHeight = 66;
    }

    Widget loadingIndicator = _load ? new Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),
          child: new Center(child: new CircularProgressIndicator())),
    ) : new Container();

    // getAllocation();
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: Text(title),
            automaticallyImplyLeading: true,
            leading: IconButton(icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            )
        ),

        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: () async {
            fetchData();
            await Future.delayed(Duration(seconds: 2));
            _refreshController.refreshCompleted();
          },
          child: new Stack(children: <Widget>[ new Container(
              margin: EdgeInsets.symmetric(vertical: 0.0),
              child: new Stack (
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(top: 0.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 55.0, width: 300, child: MaterialSegmentedControl(
                          children: _children(),
                          selectionIndex: _currentSelection,
                          borderColor: Colors.black,
                          selectedColor: Colors.lightBlueAccent,
                          unselectedColor: Colors.white,
                          borderRadius: 0.0,
                          onSegmentChosen: (index) {
                            setState(() {
                              _currentSelection = index;
                            });
                          },
                        )),

                        SizedBox(height: rowHeight,
                            child: new ListView.builder(itemCount: 1, physics:  const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: Colors.lightBlue[100],
                                    child: InkWell(
                                      onTap: () {
                                        print('tapped');
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Row(
                                          children: <Widget>[
//                                      SecondaryName("Secondary Lead", FontWeight.bold),
                                            columnSendTitle(
                                                "${(_currentSelection == 0) ? "RND" : "Domain"}", FontWeight.bold),
                                            columnSendTitle(
                                                "Total Application Count", FontWeight.bold),
                                            columnSendTitle(
                                                "Certified Application Count", FontWeight.bold),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })),
//                      SizedBox(height: 20.0,),

                        new Expanded(  child: ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.black,
                            ),
                            itemCount: (_currentSelection == 0) ? applicationCountList.length : domainCountList.length,
                            itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
//                                      SecondaryName("erytew", FontWeight.normal),
                                      columnSendTitle(
                                          "${(_currentSelection == 0) ? applicationCountList[index].RNDName : domainCountList[index].RNDName}",
                                          FontWeight.normal),
                                      columnSendTitle(
                                          "${(_currentSelection == 0) ? applicationCountList[index].totalApplicationCount : domainCountList[index].totalApplicationCount}",
                                          FontWeight.normal),
                                      columnSendTitle(
                                          "${ (_currentSelection == 0) ? applicationCountList[index].certApplicationCount : domainCountList[index].certApplicationCount}",
                                          FontWeight.normal)

//                                      SecondaryName("Abbott"),
//                                      columnSendTitle("${AssociatewithGradesArray[index].destination}",FontWeight.normal),
//                                      columnSendTitle("${AssociatewithGradesArray[index].onsiteCount.toStringAsFixed(2)}",FontWeight.normal),
                                    ],
                                  ),
                                )
                            )


                        )
                        )

                      ],

                    ),
                  )
                ],

              )
          ) , new Align(
            child: loadingIndicator, alignment: FractionalOffset.center,) ]),
        ),
      ),
    );
  }


  Widget columnSendTitle(String title, FontWeight fontWeight) {
    // the Expanded widget lets the columns share the space
    Widget column = Expanded(
      child: Column(
        // align the text to the left instead of centered
        //crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 16, fontWeight: fontWeight),
            textAlign: TextAlign.center,),
        ],
      ),
    );
    return column;
  }

  Widget SecondaryName(String name, FontWeight fontWeight) {
    Widget secondaryLeadName = Expanded(
      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(name, style: TextStyle(fontSize: 16, fontWeight: fontWeight),
            textAlign: TextAlign.center,)
        ],
      ),
    );
    return secondaryLeadName;
  }
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

  Future <List<AppCertificationMdel>> getAppCertification() async {

    List<AppCertificationMdel> applicationList = [];
    domainCountList = [];

    setState(() {
      _load = true; //
    });
    // Allocation newPost = new Allocation();
    AppCerification p = await getAppCertificationCount(kAppCertificationURL + employeeID, headers: headers);
    p.applicationList.forEach((item) {
      
      applicationList.add(AppCertificationMdel(item['RNDName'], item['totalCount'], item['certifiedCount']));

    });

    int totalAppCount = 0;
    int totalCerCount = 0;

    applicationList.forEach((model) {

      totalCerCount = totalCerCount + model.certApplicationCount;
      totalAppCount = totalAppCount + model.totalApplicationCount;

    });

    applicationList.add(AppCertificationMdel("Total", totalAppCount, totalCerCount));


    p.domainCountList.forEach((item) {

      domainCountList.add(AppCertificationMdel(item['domainName'], item['totalCount'], item['certifiedCount']));

    });


    totalCerCount = 0;
    totalAppCount = 0;

    domainCountList.forEach((model) {

      totalCerCount = totalCerCount + model.certApplicationCount;
      totalAppCount = totalAppCount + model.totalApplicationCount;

    });

    domainCountList.add(AppCertificationMdel("Total", totalAppCount, totalCerCount));


    setState(() {
      if (p.errorObj != null && p.errorObj.ErrorCode == 401) {
        _showDialog("Session Expired...Please try to Login Again", "Warning");
      }
      else if (p.errorObj != null) {
        _showDialog(p.errorObj.ErrorDesc, "Error");
      }
      _load = false; // Enable Loader False
    });

    return applicationList ;
  }
}

