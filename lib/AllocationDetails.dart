import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'AllocationReports.dart';
import './AssociatewithGrades.dart';




class AllocationReportDetails extends StatefulWidget {


  final List<SecondaryProjectLeads> secondaryProjectLeadsArray;
  final String cardTitle;
  AllocationReportDetails({Key key, @required this.secondaryProjectLeadsArray, this.cardTitle}) : super(key: key);

  @override
  _AllocationReportDetailsState createState() => _AllocationReportDetailsState();
}


class _AllocationReportDetailsState extends State<AllocationReportDetails> {


  int selectedIndex = 0;
//  String TitleClicked= "";

  String get TitleClicked => widget.cardTitle;

   List<SecondaryProjectLeads> get secondaryProjectLeadsArray => widget.secondaryProjectLeadsArray;



  void fetchData() {

  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }




  @override
  Widget build(BuildContext context) {
    final title = TitleClicked;

    // getAllocation();
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
            automaticallyImplyLeading: true,
            leading: IconButton(icon:Icon(Icons.arrow_back_ios),

              onPressed:() => Navigator.pop(context, false),
            )
        ),
        body: new Container(
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

                      SizedBox(height: 120.0, child: new ListView.builder(  itemCount: 1,
                      itemBuilder: (context, index) {

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
                                  SecondaryName("Secondary Lead", FontWeight.bold),
                                  columnSendTitle("Offshore count", "Offshore Allocation", FontWeight.bold),
                                  columnSendTitle("OnSite Count", "Onsite Allocation",FontWeight.bold),
                                  columnSendTitle("Total count", "Total Allocation",FontWeight.bold),
                                ],
                              ),
                            ),
                          ),
                        );

                      })),
//                      SizedBox(height: 20.0,),

                      new Expanded(child:ListView.builder(
                        itemCount: secondaryProjectLeadsArray.length,
                        itemBuilder: (context, index) {
                            return Card(
                              color: (index%2==0)?Colors.grey[350] :Colors.white,
                              child: InkWell(
                                onTap: () {
                                  print('tapped');
                                  print('tapped ${secondaryProjectLeadsArray[index]}');

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AssociateWithGradesDetails(AssociatewithGradesArray: secondaryProjectLeadsArray[index].associatewithGrades, cardTitle:"${secondaryProjectLeadsArray[index].userName.toString()}" ,),
                                      ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SecondaryName("${secondaryProjectLeadsArray[index].userName.toString()}", FontWeight.normal),
//                                      SecondaryName("Abbott"),
                                      columnSendTitle("${secondaryProjectLeadsArray[index].offshoreCount.toStringAsFixed(2)}", "${secondaryProjectLeadsArray[index].offshoreAllocationRatio.toStringAsFixed(2)}",FontWeight.normal),
                                      columnSendTitle("${secondaryProjectLeadsArray[index].onsiteCount.toStringAsFixed(2)}", "${secondaryProjectLeadsArray[index].onsiteAllocationRatio.toStringAsFixed(2)}",FontWeight.normal),
                                      columnSendTitle("${secondaryProjectLeadsArray[index].totalCount.toStringAsFixed(2)}", "${secondaryProjectLeadsArray[index].totalAllocationRatio.toStringAsFixed(2)}", FontWeight.normal),

                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
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



  Widget columnSendTitle(String title, String subTitle, FontWeight fontWeight) {

    // the Expanded widget lets the columns share the space
    Widget column = Expanded(
      child: Column(
        // align the text to the left instead of centered
        //crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 16, fontWeight: fontWeight), textAlign: TextAlign.center,),
          Text("", style: TextStyle(fontSize: 16),),
          Text(subTitle, style: TextStyle(fontSize: 16, fontWeight: fontWeight),),
        ],
      ),
    );
    return column;
  }

  Widget SecondaryName(String name, FontWeight fontWeight){

    Widget secondaryLeadName = Expanded(
      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(name, style: TextStyle(fontSize: 16, fontWeight: fontWeight), textAlign: TextAlign.center,)
        ],
      ),
    );
    return secondaryLeadName;
  }

}

