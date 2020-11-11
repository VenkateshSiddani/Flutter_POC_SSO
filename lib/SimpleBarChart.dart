
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:aid/DebthAnalysys.dart';
import 'dart:async';

class SimpleBarChartReport extends StatefulWidget {


  final String titleOfGraph;
  final String subTitleOfGraph;

  final List<charts.Series> seriesList;
  final List<dynamic> activityList;

  final bool isDebtClass;

  SimpleBarChartReport({Key key, @required this.titleOfGraph, this.seriesList, this.subTitleOfGraph, this.activityList, this.isDebtClass}) : super(key: key);

  @override
  SimpleBarChart createState() => SimpleBarChart();
}

class SimpleBarChart extends State<SimpleBarChartReport> {

  List<charts.Series> get seriesList => widget.seriesList;
  String get titleOFTheScreen => widget.titleOfGraph;
  String get subtitle => widget.subTitleOfGraph;
  final bool animate = true;

  bool get isDebtClass => widget.isDebtClass ?? false;

  List<dynamic> get activityList => widget.activityList;

  final _myState = new charts.UserManagedState<String>();


  @override
  Widget build(BuildContext context) {
    final title = titleOFTheScreen;

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
                                              simpleBarChart(),
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
          )


      ),
    );
  }



  Widget simpleBarChart() {
    return  SizedBox(height: 454, child:  Card( elevation: 10, child: Column( children: <Widget>[

      SizedBox(height: 44,  child:  Align(
        alignment: Alignment.center,
        child: Text(subtitle),
      ),),
      SizedBox(height: 400,child:new charts.BarChart(
        seriesList,
        animate: animate,
        selectionModels: [
          new charts.SelectionModelConfig(
              type: charts.SelectionModelType.info,
              updatedListener: _infoSelectionModelUpdated)
        ],
        // Pass in the state you manage to the chart. This will be used to
        // override the internal chart state.
        userManagedState: _myState,
        // The initial selection can still be optionally added by adding the
        // initial selection behavior.
        behaviors: [
          new charts.InitialSelection(selectedDataConfig: [
            new charts.SeriesDatumConfig<String>('Sales', '2016')
          ])
        ],
      )),

    ],), ));
  }

  void _infoSelectionModelUpdated(charts.SelectionModel<String> model) {
    // If you want to allow the chart to continue to respond to select events
    // that update the selection, add an updatedListener that saves off the
    // selection model each time the selection model is updated, regardless of
    // if there are changes.
    //
    // This also allows you to listen to the selection model update events and
    // alter the selection.
    _myState.selectionModels[charts.SelectionModelType.info] =
    new charts.UserManagedSelectionModel(model: model);

    if (model.selectedDatum.length > 0) {

      Timer(Duration(seconds: 3), () {
        int selectedIndex = model.selectedDatum[0].index;

        if (activityList[selectedIndex] != null)
          {


             List<charts.Series> getGraphData;
             if (isDebtClass == false)
               {
                 getGraphData = _createSampleData(selectedIndex);
               }
             else {
               getGraphData = _debtDetailClassification(selectedIndex);
             }

             if (getGraphData.length > 0)
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SimpleBarChartReport(seriesList: getGraphData, titleOfGraph: subtitle, subTitleOfGraph: activityList[selectedIndex].name, activityList: [], isDebtClass: isDebtClass,),
                  ));
            }

          }



      });
    }

  }
  /// Create one series with sample hard coded data.
   List<charts.Series<OrdinalSales, String>> _createSampleData(int selectedIndex) {

    List<DebtMonthList> debthMonthList = [];
    
    if (activityList.length > 0) {

      debthMonthList = activityList[selectedIndex].debtMonthList;
    }


    List<OrdinalSales> data = [];
    debthMonthList.forEach((value) {
      
      data.add(OrdinalSales(value.name, value.y));
      
    });

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
  /// Create one series with sample hard coded data.
  List<charts.Series<OrdinalSales, String>> _debtDetailClassification(int selectedIndex) {

    List<DebtStatisticRNDDataReports> classificationData = [];

    if (activityList.length > 0) {

      classificationData = (activityList[selectedIndex] as DebtStatisticRNDDataReports).causeList;

    }


    List<OrdinalSales> data = [];
    classificationData.forEach((value) {

      data.add(OrdinalSales(value.name, value.y.toDouble()));

    });

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final double sales;

  OrdinalSales(this.year, this.sales);
}