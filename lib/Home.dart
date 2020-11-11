import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';



class Allocation {

  final List<dynamic> projectList;
  Map<String, dynamic> data ;
  final List<dynamic> projectSecondaryLeads;



  Allocation({ this.projectList, this.data, this.projectSecondaryLeads});

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
    if (statusCode < 200 || statusCode > 400 || json == null) {
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
  SecondaryProjectLeads(this.userName, this.onsiteCount, this.offshoreCount, this.onsiteAllocationRatio, this.offshoreAllocationRatio, this.totalCount, this.totalAllocationRatio);

}

class DasBoard extends StatefulWidget {


  final String accessToken;
  DasBoard({Key key, @required this.accessToken}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}


class _DashBoardState extends State<DasBoard> {

  static final GETALLOCATION_URL = 'http://10.142.130.86/webapi/api/auth/GetAllocation';

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

  @override
  Widget build(BuildContext context) {
    final title = 'Allocation Report';

    // getAllocation();
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: new Container(
          margin: EdgeInsets.symmetric(vertical: 15.0),
          child: new Stack (
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(top: 10.0),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      new Container(

                        height: 200, child: new ListView(
                        scrollDirection: Axis.horizontal,
                        children: _buildGridTile(projectsList1.length),
                      ),
                      ),
                      SizedBox(height: 20.0,),
                      new Container(
                        child: new Text("$TitleClicked", style:  TextStyle(fontSize: 20.0, fontFamily: "Roboto", fontWeight: FontWeight.bold),),

                      ),
                      SizedBox(height: 20.0,),

                      new Expanded(child:ListView.builder(
                        itemCount: secondaryProjectLeadsArray.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Card(
                              color : Colors.lightBlue[100],
                              child: InkWell(
                                onTap: () {
                                  print('tapped');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      SecondaryName("Secondary Lead"),
                                      columnSendTitle("Offshore count", "Offshore Allocation"),
                                      columnSendTitle("OnSite Count", "Onsite Allocation"),
                                      columnSendTitle("Total count", "Total Allocation"),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          else {

                            return Card(
                              color: (index%2==0)?Colors.grey[350] :Colors.white,
                              child: InkWell(
                                onTap: () {
                                  print('tapped');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      SecondaryName("${secondaryProjectLeadsArray[index - 1].userName.toString()}"),
//                                      SecondaryName("Abbott"),
                                      columnSendTitle("${secondaryProjectLeadsArray[index - 1].offshoreCount.toString()}", "${secondaryProjectLeadsArray[index - 1].offshoreAllocationRatio.toString()}"),
                                      columnSendTitle("${secondaryProjectLeadsArray[index - 1].onsiteCount.toString()}", "${secondaryProjectLeadsArray[index - 1].onsiteAllocationRatio.toString()}"),
                                      columnSendTitle("${secondaryProjectLeadsArray[index - 1].totalCount.toString()}", "${secondaryProjectLeadsArray[index - 1].totalAllocationRatio.toString()}"),

                                    ],
                                  ),
                                ),
                              ),
                            );
                          }


                        },
                      )
                      )

                    ],

                ),
              )
            ],

          )
        ),
      ),
    );
  }

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
    // Allocation newPost = new Allocation();
    Allocation p = await createPost(GETALLOCATION_URL, headers: headers);
    p.projectList.forEach((item) {
      final List<dynamic> projectSecondaryLeads = item['SecondaryLeadlist'];
      final List<SecondaryProjectLeads> secondaryLeads = [];
      projectSecondaryLeads.forEach((eachLeads){
        Map<String, dynamic> SecondaryLead = eachLeads['SecondaryLead'];
        secondaryLeads.add(SecondaryProjectLeads(SecondaryLead['UserName'],eachLeads['OnsiteCount'],eachLeads['OffshoreCount'],eachLeads['OnsiteAllocationRatio'],eachLeads['OffshoreAllocationRatio'],eachLeads['TotalCount'],eachLeads['TotalAllocationRatio'],));
      });
      projectsList.add(AllocationProjects(item['ProjectName'], item['OnsiteCount'], item["OffshoreCount"],item['TotalCount'], item['OnsiteAllocationRatio'], item['OffshoreAllocationRatio'], item['TotalAllocationRatio'], secondaryLeads,));
    });

    return projectsList ;
  }
}

