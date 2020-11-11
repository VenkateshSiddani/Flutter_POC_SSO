import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

import './AllocationDetails.dart';
import './AssociatewithGrades.dart';
import 'constants.dart';

class Error {

  String ErrorDesc;
  int ErrorCode;

  Error(this.ErrorDesc, this.ErrorCode);
}


class Allocation {

  final List<dynamic> projectList;
  Map<String, dynamic> data ;
  final List<dynamic> projectSecondaryLeads;
  final Error errorObj;



  Allocation({ this.projectList, this.data, this.projectSecondaryLeads, this.errorObj});

  factory Allocation.fromJson(Map<String, dynamic> json) {
    return Allocation(
      data : json['data'],
      projectList: json['data']['ProjectList'],
      //projectSecondaryLeads: json['data']['ProjectList']['SecondaryLeadlist'],
    );
  }
}

Future<Allocation> createPost(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;

    print(http.Response);
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return Allocation(errorObj: Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    return Allocation.fromJson(json.decode(response.body));
  });
}


class AllocationProjects {
  final String projectName;
  final int onsiteCount;
  final int offshoreCount;
  final int totalCount;
  final double onsiteAllocationRatio;
  final double offshoreAllocationRatio;
  final double totalAllocationRatio;

  final List<SecondaryProjectLeads> secondaryLeads;



  AllocationProjects(this.projectName, this.onsiteCount, this.offshoreCount,this.totalCount, this.onsiteAllocationRatio, this.offshoreAllocationRatio, this.totalAllocationRatio, this.secondaryLeads);
}

class SecondaryProjectLeads {

  final String userName;
  final int onsiteCount;
  final int offshoreCount;
  final double onsiteAllocationRatio;
  final double offshoreAllocationRatio;
  final int totalCount;
  final double totalAllocationRatio;
  final List <AssociatewithGrades> associatewithGrades;
  SecondaryProjectLeads(this.userName, this.onsiteCount, this.offshoreCount, this.onsiteAllocationRatio, this.offshoreAllocationRatio, this.totalCount, this.totalAllocationRatio, this.associatewithGrades);

}

class AllocationReportView extends StatefulWidget {


  final String accessToken;
  AllocationReportView({Key key, @required this.accessToken}) : super(key: key);

  @override
  _AllocationReportViewState createState() => _AllocationReportViewState();
}


class _AllocationReportViewState extends State<AllocationReportView> {

  static final GETALLOCATION_URL = kGetAllocationURL;

  String get accessTokenValue => widget.accessToken;
  int selectedIndex = 0;
  String TitleClicked= "";

  static List<AllocationProjects> projectsList1 = new List();
  static List<SecondaryProjectLeads> secondaryProjectLeadsArray = new List();



  void fetchData() {
    getAllocation().then((res) {
      setState(() {
        projectsList1 = res;
        secondaryProjectLeadsArray = projectsList1[selectedIndex].secondaryLeads;
        TitleClicked= projectsList1[selectedIndex].projectName.toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  Map<String, String> get headers => {
    'Authorization': 'Bearer $accessTokenValue',
    'Content-Type': 'application/json',
  };


  bool _load = false;


  final iconSection = new Container(
    padding: new EdgeInsets.only(top: 24.0, left: 15.0),

    child: new Column(

      children: <Widget>[
        new Image.asset("Assets/plane 2.png",
          fit: BoxFit.contain,height: 15, width: 15,
        ),
        SizedBox(height: 10),
        new Image.asset("Assets/map 2.png",
          fit: BoxFit.contain,height: 15, width: 15,
        ),
        SizedBox(height: 10),
        new Image.asset("Assets/world 2.png",
          fit: BoxFit.contain, height: 15, width: 15,
        ),
      ],
    ),
  );

  // OnSite Count

  Container byCountValue(int index)
  {
    final byCountSection = new Container(
      padding: new EdgeInsets.only(top: 20.0, left: 15.0),
      child: new Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //new Text (projectsList1[0].projectName.toString()),
          new Text("${projectsList1[index].onsiteCount.toString()}",
            style: new TextStyle(
              fontSize: 15.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            //textAlign:TextAlign.right,
          ),
          SizedBox(height: 10),
          new Text("${projectsList1[index].offshoreCount.toString()}",
            style: new TextStyle(
              fontSize: 15.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white,

            ),
            textAlign:TextAlign.right,
          ),
          SizedBox(height: 10),
          new Text("${projectsList1[index].totalCount.toString()}",
            style: new TextStyle(
              fontSize: 15.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white,

            ),
            //textAlign:TextAlign.right,
          )
        ],
      ),
    );
    return byCountSection;
  }
  Container byPercentageValue (int index)
  {
    final byPercentageSection= new Container(
      padding: new EdgeInsets.only(top: 20.0, left: 15.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text ("Alloc.${projectsList1[index].onsiteAllocationRatio.toStringAsFixed(2)}%",
            style: new TextStyle(
              fontSize: 15.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white,

            ),
            // textAlign:TextAlign.right,
          ),
          SizedBox(height: 10),

          new Text("Alloc.${projectsList1[index].offshoreAllocationRatio.toStringAsFixed(2)}%",
            style: new TextStyle(
              fontSize: 15.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white,

            ),
            //textAlign:TextAlign.right,
          ),
          SizedBox(height: 10),
          new Text("Alloc.${projectsList1[index].totalAllocationRatio.toStringAsFixed(2)}%",
            style: new TextStyle(
              fontSize: 15.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white,

            ),
            //textAlign:TextAlign.right,
          ),
        ],
      ),
    );
    return byPercentageSection;
  }
  Future<bool> _requestPop() {
    // TODO
    return new Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Allocation Report';

    int count;

    double sizeWidth;
    int contentHeight;

    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;

//    double maxWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape)

      if (useMobileLayout) { // Smart Phones
        sizeWidth = 150;
       count = 2;
        contentHeight = 150;
      }
       else { // Tablets
        count = 3;
        sizeWidth = 80;
        contentHeight = 160;
       }

    else
      if (useMobileLayout) {
        sizeWidth = 150;
        count = 1;
        contentHeight = 140;
      }
      else {
        count = 2;
        sizeWidth = 100;
        contentHeight = 160;
      }
    // getAllocation();

    Widget loadingIndicator = _load ? new Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),
          child: new Center(child: new CircularProgressIndicator())),
    ) : new Container();
    return new WillPopScope(
        onWillPop: () async =>  _requestPop(),
//      debugShowCheckedModeBanner: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
            automaticallyImplyLeading: true,
            leading: IconButton(icon:Icon(Icons.arrow_back_ios),

              onPressed:() => Navigator.pop(context, false),
            )
        ),
        body: new Stack(children: <Widget>[new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    child: new GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            mainAxisSpacing: 0,
            crossAxisSpacing: 1,
            childAspectRatio: 300 /
                contentHeight ,
          ),
          itemCount: projectsList1.length,
          itemBuilder: (context, index) {
            return Container(
              child: InkWell(
                onTap: () {
                  print('tapped $index');
                  selectedIndex = index;


                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllocationReportDetails(secondaryProjectLeadsArray: projectsList1[selectedIndex].secondaryLeads, cardTitle: projectsList1[index].projectName.toString(),),
                      ));

//                  setState(() {
//                    secondaryProjectLeadsArray = projectsList1[selectedIndex].secondaryLeads;
//                    TitleClicked= projectsList1[index].projectName.toString();
//                  });

                },
                child: Card(
                  elevation: 5,
                  color: Colors.blue[400],
                  child: Container(
                    padding: new EdgeInsets.only(top: 30.0, left: 15.0 ),
                    width:  300,
                    height: 140,
                    //child: titleSection,
                    child: Column(
                      children: <Widget>[
                        new Text(
                            '${projectsList1[index].projectName.toString()}',
                            style: new TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Roboto',
                              //fontWeight: FontWeight.bold,
                              color: Colors.white,

                            )
                        ),
                        new Container(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Container(
                                //padding: new EdgeInsets.only(top: 16.0, left: 15.0 ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    iconSection,
                                    byCountValue(index),
//                              SizedBox(width: sizeWidth),
//                              iconSection,
//                              byPercentageValue(index),
                                    Padding(
                                      padding: EdgeInsets.only(top: 30.0, ),
                                    ),
                                  ],
                                ),
                              ),

                              new Container(
                                //padding: new EdgeInsets.only(top: 16.0, left: 15.0 ),
                                padding: new EdgeInsets.only(top: 0.0, left: 0.0),

                                child: new Row(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  mainAxisAlignment: MainAxisAlignment.center,
                                  //spacing :5.0,
                                  children: <Widget>[
//                                    iconSection,
//                                    byCountValue(index),
//                                      SizedBox(width: sizeWidth),
                                      iconSection,
                                      byPercentageValue(index),
                                    Padding(
                                      padding: EdgeInsets.only(top: 30.0, ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );;
          },
        )),

          new Align(
            child: loadingIndicator, alignment: FractionalOffset.center,),]),
      ),
    );
  }

  var gridView = new GridView.builder(
      itemCount: 20,
      gridDelegate:
      new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          child: new Card(
            elevation: 5.0,
            child: new Container(
              alignment: Alignment.center,
              child: new Text('Item $index'),
            ),
          ),
          onTap: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              child: new CupertinoAlertDialog(
                title: new Column(
                  children: <Widget>[
                    new Text("GridView"),
                    new Icon(
                      Icons.favorite,
                      color: Colors.green,
                    ),
                  ],
                ),
                content: new Text("Selected Item $index"),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: new Text("OK"))
                ],
              ),
            );
          },
        );
      });


  // Horizontal Cards

  List<Widget> _buildGridTile(numberOfTiles) {

    List<Container>  containers =  new List<Container>.generate(numberOfTiles, (int index) {
      return Container(
        child: InkWell(
          onTap: () {
            print('tapped $index');
            selectedIndex = index;
            setState(() {
              secondaryProjectLeadsArray = projectsList1[selectedIndex].secondaryLeads;
              TitleClicked= projectsList1[index].projectName.toString();
            });

          },
          child: Card(
            elevation: 5,
            color: Colors.blue[400],
            child: Container(
              padding: new EdgeInsets.only(top: 30.0, left: 15.0 ),
              width:  300,
              height: 180,
              //child: titleSection,
              child: Column(
                children: <Widget>[
                  new Text(
                      '${projectsList1[index].projectName.toString()}',
                      style: new TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                        //fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )
                  ),

                  new Container(
                    //padding: new EdgeInsets.only(top: 16.0, left: 15.0 ),
                    child: new Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.Start,
                      //spacing :5.0,
                      children: <Widget>[
                        iconSection,
                        byCountValue(index),
                        SizedBox(width: 25),
                        iconSection,
                        byPercentageValue(index),
                        Padding(
                          padding: EdgeInsets.only(top: 30.0, ),
                        ),
                      ],
                    ),
                  ),

                  //titleSection,

                ],
              ),
            ),
          ),
        ),
      );

    });

    return containers;
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

  Widget columnSendTitle(String title, String subTitle) {

    // the Expanded widget lets the columns share the space
    Widget column = Expanded(
      child: Column(
        // align the text to the left instead of centered
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 16),),
          Text("", style: TextStyle(fontSize: 16),),
          Text(subTitle, style: TextStyle(fontSize: 16),),
        ],
      ),
    );
    return column;
  }

  Widget SecondaryName(String name){

    Widget secondaryLeadName = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(name, style: TextStyle(fontSize: 16),)
        ],
      ),
    );
    return secondaryLeadName;
  }




  Future <List<AllocationProjects>> getAllocation() async {

    List<AllocationProjects> projectsList = [];

    setState(() {
      _load = true; //
    });
    // Allocation newPost = new Allocation();
    Allocation p = await createPost(GETALLOCATION_URL, headers: headers);

    setState(() {

      if (p.errorObj != null && p.errorObj.ErrorCode == 401) {
        _showDialog("Session Expired...Please try to Login Again", "Warning");
      }
      else if (p.errorObj != null) {
        _showDialog(p.errorObj.ErrorDesc, "Error");
      }
      _load = false;
    });



    p.projectList.forEach((item) {
      final List<dynamic> projectSecondaryLeads = item['SecondaryLeadlist'];
      final List<SecondaryProjectLeads> secondaryLeads = [];
      projectSecondaryLeads.forEach((eachLeads){
        Map<String, dynamic> SecondaryLead = eachLeads['SecondaryLead'];
        final List<dynamic> associateWithGrades = eachLeads['AssociatewithGrades'];
        final List<AssociatewithGrades> associateGradeModel = [];
        associateWithGrades.forEach((eachGrade){
          associateGradeModel.add(AssociatewithGrades(eachGrade['Designation'], eachGrade['count']));
        });
        secondaryLeads.add(SecondaryProjectLeads(SecondaryLead['UserName'],eachLeads['OnsiteCount'],eachLeads['OffshoreCount'],eachLeads['OnsiteAllocationRatio'],eachLeads['OffshoreAllocationRatio'],eachLeads['TotalCount'],eachLeads['TotalAllocationRatio'],associateGradeModel,));
      });
      projectsList.add(AllocationProjects(item['ProjectName'], item['OnsiteCount'], item["OffshoreCount"],item['TotalCount'], item['OnsiteAllocationRatio'], item['OffshoreAllocationRatio'], item['TotalAllocationRatio'], secondaryLeads,));
    });



    return projectsList ;
  }
}

