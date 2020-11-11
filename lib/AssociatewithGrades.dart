import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';



class AssociatewithGrades {

  final String Destination;
  final double count;

  AssociatewithGrades( this.Destination, this.count);

}

class AssociateWithGradesDetails extends StatefulWidget {


  final List<AssociatewithGrades> AssociatewithGradesArray;
  final String cardTitle;
  AssociateWithGradesDetails({Key key, @required this.AssociatewithGradesArray, this.cardTitle}) : super(key: key);

  @override
  _AssociateWithGradesDetailsState createState() => _AssociateWithGradesDetailsState();
}


class _AssociateWithGradesDetailsState extends State<AssociateWithGradesDetails> {


  int selectedIndex = 0;

//  String TitleClicked= "";

  String get TitleClicked => widget.cardTitle;

  List<AssociatewithGrades> get AssociatewithGradesArray =>
      widget.AssociatewithGradesArray;


  void fetchData() {

  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    final title = "Associate with Grades ${TitleClicked}";

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

                      SizedBox(height: 44.0,
                          child: new ListView.builder(itemCount: 1,
                              itemBuilder: (context, index) {
                                return Card(
                                  color: Colors.lightBlue[100],
                                  child: InkWell(
                                    onTap: () {
                                      print('tapped');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
//                                      SecondaryName("Secondary Lead", FontWeight.bold),
                                          columnSendTitle(
                                              "Grades", FontWeight.bold),
                                          columnSendTitle(
                                              "Count", FontWeight.bold),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })),
//                      SizedBox(height: 20.0,),

                      new Expanded(child: ListView.builder(
                          itemCount: AssociatewithGradesArray.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: (index % 2 == 0)
                                  ? Colors.grey[350]
                                  : Colors.white,
                              child: InkWell(
                                onTap: () {
                                  print('tapped');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
//                                      SecondaryName("erytew", FontWeight.normal),
                                      columnSendTitle(
                                          "${AssociatewithGradesArray[index]
                                              .Destination.toString()}",
                                          FontWeight.normal),
                                      columnSendTitle(
                                          "${AssociatewithGradesArray[index]
                                              .count.toString()}",
                                          FontWeight.normal)

//                                      SecondaryName("Abbott"),
//                                      columnSendTitle("${AssociatewithGradesArray[index].destination}",FontWeight.normal),
//                                      columnSendTitle("${AssociatewithGradesArray[index].onsiteCount.toStringAsFixed(2)}",FontWeight.normal),
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
}

