
/// Bar chart with example of a legend with customized position, justification,
/// desired max rows, padding, and entry text styles. These options are shown as
/// an example of how to use the customizations, they do not necessary have to
/// be used together in this way. Choosing [end] as the position does not
/// require the justification to also be [endDrawArea].
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:aid/Menu.dart';
import 'package:aid/SimpleBarChart.dart';

import 'package:intl/intl.dart';
import 'constants.dart';
//import 'package:http';
//


class QueryDebtStatisticRNDData {

  Map<String,dynamic> data ;

  List<dynamic> causeList;
  List<dynamic> appList;
  QueryDebtStatisticRNDData({ this.data, this.causeList, this.appList});

  factory QueryDebtStatisticRNDData.fromJson(Map<String, dynamic> json) {
    return QueryDebtStatisticRNDData(
      data : json,
      causeList: json['data']['causeList'],
      appList: json['appList'],
    );
  }
}


Future<QueryDebtStatisticRNDData> createPost(String url, {Map headers, body}) async {

  return http.post(url, headers: headers, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    print(http.Response);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return QueryDebtStatisticRNDData.fromJson(json.decode(response.body));
  });

}



class DebtStatisticRNDDataReports {

  final String name;
  final int y;
  final String drilldown;
  final List<DebtStatisticRNDDataReports> causeList;

  DebtStatisticRNDDataReports(this.name, this.y, this.drilldown, this.causeList);

}


class DebthAnalysysReport extends StatefulWidget {


  final String accessToken;
  final String empID;
  final List<charts.Series> seriesList;
  final List<DebthAdherenceReports> adherenceReports;
  final List<DebtAnalysyEffortsReports> effortsReport;
  final List<DebtClassificationModel> debtClassReports;
  final List< dynamic> roles;
  final bool isPrimaryLead;




  DebthAnalysysReport({Key key, @required this.accessToken, this.empID, this.seriesList, this.adherenceReports, this.effortsReport, this.debtClassReports, this.roles, this.isPrimaryLead}) : super(key: key);

  @override
  _DebthAnalysysReportState createState() => _DebthAnalysysReportState();
}


class _DebthAnalysysReportState extends State<DebthAnalysysReport> {

//  static List<charts.Series> seriesList;
  final bool animate = false;
  String get employeeID => widget.empID;
  String get accessTokenValue => widget.accessToken;
  List<charts.Series> get seriesList => widget.seriesList;

  List<DebthAdherenceReports> get adherenceReports => widget.adherenceReports;
  List<DebtAnalysyEffortsReports> get debthEffortsReports => widget.effortsReport;
  List<DebtClassificationModel> get debtClassReports => widget.debtClassReports;

  List< dynamic> get roleValue=> widget.roles;
  bool get isPrimaryLead => widget.isPrimaryLead;


  String  DEBTHANALYSY_STATISTICSURL = kDebtStatasticsURL;

  bool _load = false;

  List<charts.Series<Task, String>> _seriesPieData;
  List<charts.Series> seriesList1;

  Color barGrapghColor = Colors.blue;

  List<Activitylist> activityList = [];

  int selectedPieChart = 0;


  final myState = new charts.UserManagedState<dynamic>();
  final myPieChartState = new charts.UserManagedState<dynamic>();


  _generateData() {

    List<Task>  piedata  = [

    ];
    adherenceReports.forEach((reports) {
      var ticketCount = 0;

      if (isPrimaryLead == false) {
          reports.ticketsData.where((x) => x != null).forEach((item) {
            ticketCount = ticketCount + item[1];
          });
      }
      else {
        ticketCount = reports.y.toInt();
      }



      if (reports.name ==  "Not Classified") {
        piedata.add(Task(reports.name, ticketCount, Color(getIntFromColor(135, 181, 231))));
      } else  if (reports.name ==  "Knowledge") {
        piedata.add(Task(reports.name, ticketCount, Color(getIntFromColor(55, 126, 34))));
      } else  if (reports.name ==  "Operational") {
        piedata.add(Task(reports.name, ticketCount, Color(getIntFromColor(237, 50, 35))));
      } else  if (reports.name ==  "Technical") {
        piedata.add(Task(reports.name, ticketCount, Color(getIntFromColor(117, 20, 13))));
      }
      else  if (reports.name ==  "Functional") {
        piedata.add(Task(reports.name, ticketCount, Color(getIntFromColor(0, 3, 235))));
      }

    });

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: '',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );

  }

  int getIntFromColor(int Red, int Green, int Blue){
    Red = (Red << 16) & 0x00FF0000; //Shift red 16-bits and mask out other stuff
    Green = (Green << 8) & 0x0000FF00; //Shift Green 8-bits and mask out other stuff
    Blue = Blue & 0x000000FF; //Mask out anything not blue.

    return 0xFF000000 | Red | Green | Blue; //0xFF000000 for 100% Alpha. Bitwise OR everything together.
  }

  @override
  void initState() {
    super.initState();
    _seriesPieData = List<charts.Series<Task, String>>();

    _generateData();
    seriesList1 = List<charts.Series<Task, String>>();

    _createSampleData();
  }

  Map<String, double> dataMap = new Map();
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  Map<String, String> get headers =>
      {
        'Authorization': 'Bearer $accessTokenValue',
        'Content-Type': 'application/json',
      };

  Widget groupedBarChart(){

   return SizedBox(height: 470, child: Card( elevation: 10, child:Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        SizedBox(height: 44, child: Text('Debt Adherence'),),
        SizedBox(height: 400, child: new charts.BarChart( seriesList,
          animate: animate,
          vertical: true,
          barGroupingType: charts.BarGroupingType.grouped,
          barRendererDecorator: new charts.BarLabelDecorator(
            labelPosition: charts.BarLabelPosition.inside,
            outsideLabelStyleSpec: new charts.TextStyleSpec(
                color: charts.Color(r: 127, g: 63, b: 191),
                fontFamily: 'Georgia',
                fontSize: 11),),
          // Add the legend behavior to the chart to turn on legends.
          // This example shows how to change the position and justification of
          // the legend, in addition to altering the max rows and padding.
          behaviors: [
            new charts.SeriesLegend(
              // Positions for "start" and "end" will be left and right respectively
              // for widgets with a build context that has directionality ltr.
              // For rtl, "start" and "end" will be right and left respectively.
              // Since this example has directionality of ltr, the legend is
              // positioned on the right side of the chart.
              position: charts.BehaviorPosition.bottom,
              // For a legend that is positioned on the left or right of the chart,
              // setting the justification for [endDrawArea] is aligned to the
              // bottom of the chart draw area.
              outsideJustification: charts.OutsideJustification.endDrawArea,
              // By default, if the position of the chart is on the left or right of
              // the chart, [horizontalFirst] is set to false. This means that the
              // legend entries will grow as new rows first instead of a new column.
              horizontalFirst: false,
              // By setting this value to 2, the legend entries will grow up to two
              // rows before adding a new column.
              desiredMaxRows: 2,
              // This defines the padding around each legend entry.
              cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
              // Render the legend entry text with custom styles.
              entryTextStyle: charts.TextStyleSpec(
                  color: charts.Color(r: 127, g: 63, b: 191),
                  fontFamily: 'Georgia',
                  fontSize: 11),
            )
          ],),)

      ],
    ) )
    );
  }

  Widget doNutpieChart() {
    return  SizedBox(height: 454, child:  Card( elevation: 10, child: Column( children: <Widget>[

      SizedBox(height: 44,  child:  Align(
        alignment: Alignment.center,
        child: Text("Debt Distribution"),
      ),),
      SizedBox(height: 400,child:charts.PieChart(
          _seriesPieData,
          animate: true,
          animationDuration: Duration(seconds: 2),
          selectionModels: [
            new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                updatedListener: _infoSelectionModelUpdated)
          ],
         // userManagedState: myState,
          behaviors: [
            new charts.DatumLegend(
              outsideJustification: charts.OutsideJustification.endDrawArea,
              position: charts.BehaviorPosition.bottom,
              horizontalFirst: false,
              desiredMaxRows: 2,
              cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
              entryTextStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.purple.shadeDefault,
                  fontFamily: 'Georgia',
                  fontSize: 11),
            )
          ],
          defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 50,
              arcRendererDecorators: [
                new charts.ArcLabelDecorator(
                    labelPosition: charts.ArcLabelPosition.inside)
              ]))),

    ],), ));
  }



  Widget pieChart()
  {
    return    SizedBox(height: 454, child:  Card( elevation: 10, child: Column( children: <Widget>[

      SizedBox(height: 44,  child:  Align(
        alignment: Alignment.center,
        child: Text("Effort split up in Percentage"),
      ),),
      SizedBox(height: 400, child: charts.PieChart(seriesList1,
          animate: animate,
          animationDuration: Duration(seconds: 2),

          selectionModels: [
            new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                updatedListener: _infoSelectionModelUpdatedForPieChart)
          ],
         // userManagedState: myPieChartState, Venky
          behaviors: [
            new charts.DatumLegend(
              outsideJustification: charts.OutsideJustification.endDrawArea,
              position: charts.BehaviorPosition.bottom,
              horizontalFirst: false,
              desiredMaxRows: 2,
              cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
              entryTextStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.purple.shadeDefault,
                  fontFamily: 'Georgia',
                  fontSize: 11),

            ),

          ],
          defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
            new charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.inside)
          ])),)

    ])));
  }

  Widget debthClassification() {

    return    SizedBox(height: 454, child:  Card( elevation: 10, child: Column( children: <Widget>[

      SizedBox(height: 44,  child:  Align(
        alignment: Alignment.center,
        child: Text("Debt Classification"),
      ),),
      SizedBox(height: 400, child: Center(child: Container(padding: const EdgeInsets.all(0.0),child:ListView.builder(
          itemCount: debtClassReports.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              child: InkWell(
                onTap: () {
                  print('tapped');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        columnSendTitle(debtClassReports[index], index, ),
                    ],
                  ),
                ),
              ),
            );
          }
      ))))

    ])));

  }

  BoxDecoration myBoxDecoration(Color color ) {
    return BoxDecoration(
      border: Border.all(color: Colors.white),
      color: color
    );
  }

  Widget myWidget(String value, Color color, String classification, int index) {
    return new GestureDetector(
        onTap: (){
          print(classification);
          if (classification == 'Residual') {
            moveToDebthCalssification(index, "No", "Yes","Unavoidable Non Residual");

          }else if (classification == 'N.Residual') {
            moveToDebthCalssification(index, "No", "No", "Unavoidable Residual");

          }
        },
      child: Container(
//      color: Colors.green,
        width: 56.0,
        height: 22.0,
        margin: const EdgeInsets.all(0.0),
        padding: const EdgeInsets.all(0.0),
        decoration: myBoxDecoration(color), //             <--- BoxDecoration here
        child: Align(
          alignment: Alignment.center,
          child: Text(
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 10) ),
        ),
    )
    );

  }

  Widget classificatinWidget(String value, double height,Color color, String classification, int index) {

    return new GestureDetector(
      onTap: (){
        print(classification);

        if (classification == 'Classification') {
          moveToDebthCalssification(index, null, null, "");
        }else if (classification == 'Avoidable') {
          moveToDebthCalssification(index, "Yes", null, "Avoidable");
        }else if (classification == 'UnAvoidable') {
          moveToDebthCalssification(index, "No", null, "Unavoidable");
        }
      },
      child: new Container(
        color: color,
        width: 100.0,
        height: height,
        margin: const EdgeInsets.all(0.0),
        padding: const EdgeInsets.all(0.0), //             <--- BoxDecoration here
        child: Align(
          alignment: Alignment.center,
          child: Text(
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 15) ),
        ),
      )
    );
  }
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  moveToDebthCalssification(int index, String avoidability, String residuality , String subTitle)
  {
    getDebtStatisticsData(debtClassReports[index], avoidability, residuality).then((statistics){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SimpleBarChartReport(seriesList: _debthClassificationDetails(statistics), titleOfGraph: 'Debt Detailed Classification', subTitleOfGraph: debtClassReports[index].classification + " " + "$subTitle", activityList: statistics, isDebtClass: true,),
          ));

    });
  }

  Widget columnSendTitle(DebtClassificationModel reports, int index) {

    String classification = reports.classification;
    String color = reports.color;
    double classificationPerc = (reports.Ticketcount/ reports.totalCount ) *100;
    double avoidablePercentage = (reports.AvoidableCount/ reports.Ticketcount ) *100;
    double unAvoidablePercentage = (reports.UnAvoidableCount/ reports.Ticketcount ) *100;

    double residualNoPerc = (reports.ResidualNoCount/ reports.UnAvoidableCount) * 100;
    double residualYesPerc = (reports.ResidualYesCount/ reports.UnAvoidableCount) * 100;


    Color classificationTileColor;
    if (color == 'red')
    {
      classificationTileColor = Colors.red;
    }
    else if (color == 'green') {
        classificationTileColor = Colors.green;
    }
    else if (color == 'blue') {
      classificationTileColor = Colors.blue;
    }else {
      classificationTileColor = hexToColor(color);
    }

//    print(reports.classification);
    // the Expanded widget lets the columns share the space
    Widget column = Expanded(
      child:  SizedBox(child: Center(child: Container(
        padding: const EdgeInsets.all(0.0), child:Row(
        children: <Widget>[
          SizedBox( child: Column(
            // align the text to the left instead of centered
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              SizedBox(height: 44, child: Row(
                children: <Widget>[
                  classificatinWidget(classification,44.0, classificationTileColor, "Classification",index ),
                  SizedBox(width: 100, child: Column(

                    children: <Widget>[
                      classificatinWidget('${avoidablePercentage.roundToDouble()} %',22.0, Colors.green, "Avoidable", index),
                      classificatinWidget('Avoidable %', 22.0,Colors.green, "Avoidable", index),
                    ],

                  ),)
                ],

              ),
              ),

              SizedBox(height: 44, child: Row(
                children: <Widget>[

                  classificatinWidget('${classificationPerc.roundToDouble()} %', 44.0,classificationTileColor, "Classification", index),
                  SizedBox(width: 100, child: Column(

                    children: <Widget>[
                      classificatinWidget('${unAvoidablePercentage.truncateToDouble()} %', 22.0,Color(getIntFromColor(200, 147, 23)),"UnAvoidable", index),
                      classificatinWidget('UnAvoidable %', 22.0,Color(getIntFromColor(200, 147, 23)), "UnAvoidable", index),
                    ],

                  ))
                ],


              ),)
            ],
          ),
          ),
      SizedBox(width: 7,),
          SizedBox(child: Column(

          children: <Widget>[
            SizedBox(height:44),
            SizedBox( child: Card(
              elevation: 5,
              child: Column(
                // align the text to the left instead of centered
                //crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(height: 23, child: Row(
                    children: <Widget>[

                      myWidget('N.Residual', Colors.green, "N.Residual", index),
                      myWidget('${residualNoPerc.floorToDouble()} %', Colors.green, "N.Residual", index),
                    ],

                  ),
                  ),

                  SizedBox(height: 23, child: Row(
                    children: <Widget>[

                      myWidget('Residual', Colors.red, "Residual", index),
                      myWidget('${residualYesPerc.floorToDouble()} %', Colors.red, "Residual", index),
                    ],


                  ),)
                ],
              ),
            )
            ),
          ],
          )),




        ],
      ),),),),

    );
    return column;
  }

  @override
  Widget build(BuildContext context) {
    final title = "Debt Analysis Report";

    Widget loadingIndicator = _load ? new Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),
          child: new Center(child: new CircularProgressIndicator())),
    ) : new Container();


    final clearSelection = new MaterialButton(
        onPressed: _handleClearSelection, child: new Text('Clear Selection'));

    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
              title: Text(title),
              automaticallyImplyLeading: true,
              leading: IconButton(icon: Icon(Icons.arrow_back_ios),

                onPressed: () => Navigator.pop(context, false),
              )
          ),
          body:new Stack(children: <Widget>[ new Container(
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


                    new Expanded(child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Container(
                            child: InkWell(
                              onTap: () {
                                print('tapped');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    groupedBarChart(),
                                    doNutpieChart(),
                                    pieChart(),
                                    debthClassification(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    )
                    )

                  ]

                     )

                    )
                    ]
                   )
          ),
             new  Align(
               child: loadingIndicator, alignment: FractionalOffset.center,),
        ]

      )

      ),
    );
  }

  void _infoSelectionModelUpdated(charts.SelectionModel<dynamic> model) {
    // If you want to allow the chart to continue to respond to select events
    // that update the selection, add an updatedListener that saves off the
    // selection model each time the selection model is updated, regardless of
    // if there are changes.
    //
    // This also allows you to listen to the selection model update events and
    // alter the selection.
    myState.selectionModels[charts.SelectionModelType.info] =
    new charts.UserManagedSelectionModel(model: model);

    selectedPieChart = 1;
//

    if (model.selectedDatum.length > 0) {

      print(model.selectedDatum[0].index);


      Timer(Duration(seconds: 3), () {

        int slectedIndex = model.selectedDatum[0].index;

        switch (slectedIndex){
          case 0:
            barGrapghColor = Color(getIntFromColor(135, 181, 231));
            break;
          case 1:
            barGrapghColor = Color(getIntFromColor(55, 126, 34));
            break;
          case 2:
            barGrapghColor = Color(getIntFromColor(237, 50, 35));
            break;
          case 3:
            barGrapghColor = Color(getIntFromColor(117, 20, 13));
            break;
          default: {
            //statements;
          }
          break;

        }


        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SimpleBarChartReport(seriesList: _ordinaryGraph(slectedIndex), titleOfGraph: 'Debt Distribution', subTitleOfGraph: adherenceReports[slectedIndex].name, activityList: [],),
            ));

      });
    }

  }


  void _infoSelectionModelUpdatedForPieChart(charts.SelectionModel<dynamic> model) {
    // If you want to allow the chart to continue to respond to select events
    // that update the selection, add an updatedListener that saves off the
    // selection model each time the selection model is updated, regardless of
    // if there are changes.
    //
    // This also allows you to listen to the selection model update events and
    // alter the selection.
    myPieChartState.selectionModels[charts.SelectionModelType.info] =
    new charts.UserManagedSelectionModel(model: model);
//
    selectedPieChart = 2;

    if (model.selectedDatum.length > 0) {

      print(model.selectedDatum[0].index);

      Timer(Duration(seconds: 3), () {
//      print("Yeah, this line is printed after 3 seconds");
          int selectedIndex = model.selectedDatum[0].index;

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SimpleBarChartReport(seriesList: _ordinaryGraph(selectedIndex), titleOfGraph: 'Effor split up in Percentage', subTitleOfGraph: debthEffortsReports[selectedIndex].name, activityList: activityList,),
            ));

      });
    }

  }

  void _handleClearSelection() {
    // Call set state to request a rebuild, to pass in the modified selection.
    // In this case, passing in an empty [UserManagedSelectionModel] creates a
    // no selection model to clear all selection when rebuilt.

    setState(() {
      myState.selectionModels[charts.SelectionModelType.info] =
      new charts.UserManagedSelectionModel();
    });
  }


  /// Create one series with sample hard coded data.
    _createSampleData() {

    final List <LinearSales> data  = [];
    debthEffortsReports.asMap().forEach((index, reports) {
      var ticketCount = 0;
      data.add(LinearSales(index, reports.y, reports.name));

    });
    seriesList1 =  [
      new charts.Series<LinearSales, dynamic>(
        id: 'Tickets',
        domainFn: (LinearSales sales, _) => sales.name,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.sales}%',
      )
    ];
  }


  // user defined function
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

  List<charts.Series<OrdinaryGrapgh, String>> _ordinaryGraph(int selectedIndex) {

    activityList = [];
    final List<OrdinaryGrapgh> data = [];

    if (selectedPieChart == 2) {  // Effort split up in percentage

      debthEffortsReports.asMap().forEach((index, reports) {

        if (index == selectedIndex) {

          reports.Activitylist.forEach((dict) {
            List<DebtMonthList> monthList = [];
            List<dynamic> debList = dict['DebtMonthList'];
            debList.forEach((eachValue) {
              monthList.add(DebtMonthList(eachValue['name'], eachValue['y']));
            });
            Activitylist a = new Activitylist(dict['name'], dict['y'], monthList);
            activityList.add(a);

          });
        }

      });


      activityList.forEach((value) {
        data.add(OrdinaryGrapgh(value.name, value.y));
      });

      return [
        new charts.Series<OrdinaryGrapgh, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrdinaryGrapgh sales, _) => sales.year,
          measureFn: (OrdinaryGrapgh sales, _) => sales.sales,
          data: data,
        )
      ];
    } else if (selectedPieChart == 1) { // Debt Distribution

      adherenceReports[selectedIndex].ticketsData.where((x) => x != null).forEach((item) {
//        ticketCount = ticketCount + item[1];
        data.add(OrdinaryGrapgh(item[0].toString(), item[1].toDouble()));
      });
    }

    return [
      new charts.Series<OrdinaryGrapgh, String>(
        id: '',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(barGrapghColor),
        domainFn: (OrdinaryGrapgh sales, _) => sales.year,
        measureFn: (OrdinaryGrapgh sales, _) => sales.sales,
        data: data,
      )
    ];


  }


  List<charts.Series<OrdinaryGrapgh, String>> _debthClassificationDetails(List<DebtStatisticRNDDataReports> classificationData) {

    //activityList = [];
    final List<OrdinaryGrapgh> data = [];

    classificationData.forEach((classification) {

      data.add(OrdinaryGrapgh(classification.name, classification.y.toDouble()));
    });

    return [
      new charts.Series<OrdinaryGrapgh, String>(
        id: '',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(barGrapghColor),
        domainFn: (OrdinaryGrapgh sales, _) => sales.year,
        measureFn: (OrdinaryGrapgh sales, _) => sales.sales,
        data: data,
      )
    ];


  }


  Map toMap(String classification, String employeeID,List<dynamic> roleValue, dynamic avoidability, dynamic residuality ) {
  
  if (roleValue.length > 0) {
    Map<String, dynamic> body = {
      'Employeeid': int.parse('${employeeID}'),
      'classification': '${classification}',
      'avoidability':avoidability,
      'residuality':residuality,
      'Role':roleValue,
    };
    return body;
  }else 
    {
      Map<String, dynamic> body = {
        'Employeeid': int.parse('${employeeID}'),
        'classification': '${classification}',
        'avoidability':null,
        'residuality':null,
        'Role': [],
      };
      
      return body;
    }
  }
  Future <List<DebtStatisticRNDDataReports>> getDebtStatisticsData(DebtClassificationModel reports, String avoidability, String residuality ) async {

    List<DebtStatisticRNDDataReports> eachReport = [];
    setState(() {
      _load = true; // Enable Loader
    });
    var body = json.encode(toMap(reports.classification, employeeID, roleValue, avoidability, residuality));
    QueryDebtStatisticRNDData p = await createPost(DEBTHANALYSY_STATISTICSURL, headers: headers, body: body);
    setState(() {
      _load = false; // Enable Loader False
    });
    p.causeList.forEach((item) {
      List<DebtStatisticRNDDataReports> eachAppListReport = [];
      List <dynamic> causeList =  item['causeList'];
      causeList.forEach((report) {
//        List <dynamic> subCauseList =  report['causeList'];
        eachAppListReport.add(DebtStatisticRNDDataReports(report['name'], report['y'], report['drilldown'], []));
      });
      eachReport.add(DebtStatisticRNDDataReports(item['name'], item['y'], item['drilldown'], eachAppListReport));
    });

    return eachReport;
  }

}



class Task {
  String task;
  int taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}


/// Sample linear data type.
class LinearSales {
  final int year;
  final double sales;
  final String name;

  LinearSales(this.year, this.sales, this.name);
}

class OrdinaryGrapgh {
  final String year;
  final double sales;

  OrdinaryGrapgh(this.year, this.sales);
}


class Activitylist {

  final String name;
  final double y;
  final List<DebtMonthList> debtMonthList;

  Activitylist(this.name, this.y, this.debtMonthList);
}

class DebtMonthList {

  final String name;
  final double y;

  DebtMonthList(this.name, this.y);
}

