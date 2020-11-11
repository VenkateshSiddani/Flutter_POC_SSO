


import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SpotLightMenu extends StatefulWidget {

  final String accessToken;

  SpotLightMenu({Key key, @required this.accessToken, }) : super(key: key);

  _SpotLightMenuState createState() => new _SpotLightMenuState();
}

class _SpotLightMenuState extends State<SpotLightMenu> {

  String get acessToken => widget.accessToken;

  List<Map<String, dynamic>> menuTitles = [{'Title':'Customer Appreciations','Icon':'Assets/MenuIcons/Survey.png'}, {'Title':'KY CTS Team','Icon':'Assets/MenuIcons/World_Clock.png'},{'Title':'KY CTS Leader','Icon':'Assets/MenuIcons/Spotlight.png'}, {'Title':'Automation','Icon':'Assets/MenuIcons/Diversity.png'}];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Spot Light"),
        ),
        body: new Stack(children: <Widget>[new Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            child:  new Stack(children: <Widget>[new Padding(
//              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                padding: const EdgeInsets.all(8.0),
                child: gridViewBasedOnSection(0)
            ),
            ])
        ),
        ])
    );

  }
  Widget gridViewBasedOnSection(int section) {

    int count;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;

    if (MediaQuery.of(context).orientation == Orientation.landscape)

      if (useMobileLayout) { // Smart Phones
        count = 5;
      }
      else { // Tablets
        count = 8;

      }
    else
    if (useMobileLayout) {
      count = 3;
    }
    else {
      count = 5;
    }
    int numberOFIcons = menuTitles.length;
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / count;

    var aspectRatio = 0.00;
    if (MediaQuery.of(context).orientation == Orientation.landscape){
      final double itemHeight = (size.height - kToolbarHeight - 24) / 3 + 130;
      aspectRatio = itemHeight / itemWidth;
    }else {
      final double itemHeight = (size.height - kToolbarHeight - 24) / 3 - 130;
      aspectRatio = itemWidth / itemHeight;
    }
//   childAspectRatio: (itemWidth / itemHeight),
    var gridView = new GridView.builder(
      itemCount: numberOFIcons,
      gridDelegate:
      new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: count, childAspectRatio: aspectRatio),
      itemBuilder: (BuildContext context, int index) => new GestureDetector(
        onTap: () {
          if (index == 0 || index == 2) {

          } else if (index == 3){

          } else if (index == 1) {

          }
        },
        child: new Container(
          padding: const EdgeInsets.all(10.0),
          // color: Colors.red,
          alignment: Alignment.center,
          child: new Column(
            children: <Widget>[
              new Image.asset('${menuTitles[index]['Icon']}', alignment: Alignment.center,),
              SizedBox(height: 5),
              SizedBox(child: new Text("${menuTitles[index]['Title']}", textAlign: TextAlign.center, style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.w600, color: Colors.black, ),)),
            ],
          ),
        ),
      ),

    );

    return gridView;

  }
}