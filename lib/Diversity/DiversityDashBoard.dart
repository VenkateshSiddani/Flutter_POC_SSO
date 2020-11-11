import 'dart:io';

import 'package:aid/Diversity/DiversityDashboardModule.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:aid/constants.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:aid/Bubble/bubble.dart';
import 'package:aid/Bubble/pathTest.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:auto_size_text/auto_size_text.dart';


class DiversityModule extends StatefulWidget {

  final String accessToken;
  DiversityModule({Key key, @required this.accessToken}) : super(key: key);

  @override
  _DiversityModuleState createState() => _DiversityModuleState();
}


class _DiversityModuleState extends State<DiversityModule> {
  RefreshController _refreshController =  RefreshController(initialRefresh: false);
  static MediaQueryData _mediaQueryData;
  static double screenHeight;
  int _currentSelection = 0;
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _pageControllerForSpeak = PageController();
  final _currentPageNotifierForSpeak = ValueNotifier<int>(0);
  bool _load = false;
  int _cIndex = 0;
  String get accessTokenValue => widget.accessToken;
  DashBoard module = DashBoard();
  bool _isAlertShows = false;
  static List<DiversitySubModuleData> finalData  = new List();
  static List<DiversityImageModuleData> imageList  = new List();
  bool isAPILoads = false;
  List<Map<String, dynamic>> speachList = [{'ResourceID':597129,'Name':'Rathna Subashini Chinnappa','Message':'I am glad that, in Abbott, Women leaders play 1/3rd of the population. As an empowered part of the engagement, we feel an equal part in managing and delivering value to the customer as much as our male counterparts do. This has been only possible with self-motivated bunch of us who have been able to balance all the odd ships, work and life. Also for us to reach this heights, we have been fortunate to be working with people who collaborate, encourage and most importantly respect our contributions.'},
    {'ResourceID':260211,'Name':'Sivasankari KA','Message':'I feel empowered when my leaders trust me, provide me key opportunities and make me accountable for deliveries which are critical and highly visible. Complete freedom is provided to women in Abbott account to drive and deliver results while adhering to the mandated compliance. Freedom to express our suggestions, complaints, career growth discussions at any time with leaders empowers us to stay focused, do our work better as well maintain good relationship with leadership.'},
    {'ResourceID':249366,'Name':'Muthuvasanthkumar','Message':'It is great to have equal diversity as women thinking is always different in nature. They have proven that Men are part of Wo”Men”. We should give equal rights to everyone and there is no such any activity/task/work that can be handled by specific gender.\n\nOlder years, if there was a girl child born, society won’t accept her in anyway. Time changes and it corrected everyone and understood how they are important too. Nowadays if there is a daughter born, they are very pet to Dad’s compared to sons, which proves this fact.\nAgain older years, women was the one who took the responsibility of entire family well. Years passed by, they started taking responsibilities outside home as well.\nAs Women is being Empowered, it is time for Men to be competent with them.'},
    {'ResourceID':438315,'Name':'Vinni Vincent','Message':'To me Diversity means bringing in a fresh array of perspective to the table. All should be provided space to grow, Feel accepted and at the same time be challenged. Diversity should not be just gender diversity, Its just inclusion of people from different background, thinking, culture etc. Abbott have a good diversity within itself already.'},
    {'ResourceID':235555,'Name':'Sujeetha Babu', 'Message':' When it comes to jobs that doesn’t demand too much physical labor there is no need for a discrimination based on gender, all that matters is how well you manage your role. We have a history where it has always been the primary responsibility of the women to take care of the household. Now that the modern woman has proved themselves equally competent and smart in handling high positions in the society, the families and society have started to make way for women to succeed in their career paths. Women are blessed with supreme multitasking skills. All we need to ensure is to provide Equal opportunities for our women employees, provide them some space to design their schedules to seamlessly bring in work-life balance. I strongly believe that the only way to excel in your work is to give your 100% to it. It is equally important that you thoroughly enjoy every part of what you are doing, however big or small it is. Success will naturally follow.'},
    {'ResourceID':64046,'Name':'Melvin George Thankachan', 'Message':'I’m not sure what is expected but what I say about Diversity is ‘Diversity isn’t something we have to look for explicitly. We evaluate and take the resources based on their capability rather than his/her gender, religion, race, age, ethnicity, sexual orientation etc. And diversity will be seen automatically’.'},
    {'ResourceID':595164,'Name':'Anusha Vinothkumar','Message':' I would like to start with a quote on Women empowerment - \nA woman is the full circle.. within her is the power to create, nurture and transform" \nBoth, Cognizant and Abbott have been keen in giving opportunities to voice over our opinion and has given space to take up new roles, equal to the men leads on the ground. This is really a healthy transformation that we are into.. I was part of Donna’s visit in 2016, I presented how BVM can help Abbott to achieve Business Outcomes, after which I am an Abbottian.. that was the best chance in my life to showcase my talent, and today I take care of BVM track of transformation for Abbott.. Thanks to Donna and Cognizant leadership for making me a small drop in this Ocean… Here we are given freedom to aspire on what we want to be.. I have been trained to understand how life Science industry currently works and with that knowledge I am able to deep dive on BVM use cases for Abbott, suggest the team few Business Cases. Last but not least, a real time statistics is the count of Abbott – Cognizant Women leaders. We were very few in number in 2016, now we have grown to a larger extent, to showcase our capabilities and work for the benefit of Abbott and Cognizant'},
    {'ResourceID':553138,'Name':'Naveen Rex Xavier','Message':'I always believe that Diversity creates a positive working environment and they bring high value to the organization. In Abbott, we strongly believe and respect diversity at work which benefit the workplace more by creating a competitive edge and increasing work productivity. It is good to see that the management is taking diversity at work seriously across geographic locations by employing more women workforce thus creating increased employment opportunities and also bringing in outside-in perspective leading to innovations and adapting to fluctuating markets, customer demands and organizational growth.'},
    {'ResourceID':395830,'Name':'Radhika Saravanan', 'Message': ' Women empowerment is all about creating an environment for women where they are bound to take their own decisions. Being independent of their own for themselves in all aspects. Women must possess self-worth, confidence and freedom to choose what they may with regard to their private and professional choices alike and should stimulate the confidence within themselves in order to seek equality in society\nMy thoughts on the above context: \nWomen shouldn’t underestimate their capabilities. We will have to accept the fact that women are just as competent as their male counterparts. First of all we should establish your credibility early on in your career by performing our duties and responsibilities to be a positive player. I personally believe that one should always aim high, work hard, and care deeply about what we believe in and support one another in all instances'},
    {'ResourceID':263812,'Name':'Karthika Sivakumar','Message':'A workspace can be energetic and enthusiastic only when you have right people to recognize the talent and skills and not being biased. Abbott is one vast account which can make you feel more comfortable and confident to try and check things that run in your mind without any hesitation. It is always a great feeling when we are respected and valued for our contribution by the people around us. I am glad that we have such practical and generously thinking individuals in Abbott motivating each and everybody to reach new goals every day.'}];

  void fetchData() async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none)  {
        _showDialog(CONNECTIVITY_ERROR, "AID");
      } else {
        getDetails().then((value) => module = value);
        getImagesForDiversity().then((value) => imageList = value);
      }
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

  Future<DiversityDashboardModule> getDiversityDashBoardDetails(String url, {Map headers}) async {

    return http.get(url, headers: headers).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 400 || json == null) {
        return DiversityDashboardModule(errorObj: Error(response.reasonPhrase, response.statusCode));
        throw new Exception("Error while fetching data");
      }
      return DiversityDashboardModule.fromJson(json.decode(response.body));
    });

  }

  Future<DiversityImageModule> getDiversityImage(String url, {Map headers}) async {

    return http.get(url, headers: headers).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 400 || json == null) {
        return DiversityImageModule(errorObj: Error(response.reasonPhrase, response.statusCode));
        throw new Exception("Error while fetching data");
      }
      return DiversityImageModule.fromJson(json.decode(response.body));
    });

  }

  Future <List<DiversityImageModuleData>> getImagesForDiversity() async {
    
    var imageListData = List<DiversityImageModuleData>();
    
    try {
      DiversityImageModule module = await getDiversityImage(
          kDiversityImagedURL, headers: headers);
      if (mounted)
        setState(() {
          if (module.errorObj != null && module.errorObj.ErrorCode == 401) {
            if (!_isAlertShows)
              _showDialog("Session Expired...Please try to Login Again", "Warning");
          }
          else if (module.errorObj != null) {
            if (!_isAlertShows)
              _showDialog(module.errorObj.ErrorDesc, "Error");
          }
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        });
      module.data.forEach((element) {
        print(element['Diversityimage']['Image']);
        imageListData.add(DiversityImageModuleData(resourceid: element['Diversityimage']['resourceid'],resourcename:element['Diversityimage']['resourcename'] , Image: element['Diversityimage']['Image']));
      });
      return imageListData;
    }on SocketException catch (_) {
      // print('not connected');
      if (!_isAlertShows)
        _showDialog(SOCKET_EXCEPTION_ERROR, "AID");

    }
  }

   Future <DashBoard> getDetails() async {

    setState(() {
      _load = true; //
    });
     try {
    DiversityDashboardModule module = await getDiversityDashBoardDetails(
        kDiversityDashBoardURL, headers: headers);
    if (mounted)
      setState(() {
        if (module.errorObj != null && module.errorObj.ErrorCode == 401) {
          if (!_isAlertShows)
             _showDialog("Session Expired...Please try to Login Again", "Warning");
        }
        else if (module.errorObj != null) {
          if (!_isAlertShows)
            _showDialog(module.errorObj.ErrorDesc, "Error");
        }
        _load = false;
        _refreshController.loadComplete();
        _refreshController.refreshCompleted();
      });
    List<DiversitySubModuleData> leadWiseList = [];
    final List<DiversitySubModuleData> countryWiseList = [];
    final List<DiversitySubModuleData> gradeWiseList = [];
    final List<DiversitySubModuleData> deptWiseList = [];

    double grandTotal = 0.00;
    double totalNumber = 0;
    module.leadWiseList.forEach((element) {
      var model = DiversitySubModuleData(name: element['Secondaryleadname'],
          diversityPercentage: element['Diversity']);
      if(element['Diversity'] == 0.00){ // Removing zero values
        totalNumber = totalNumber + 1;
      }
      grandTotal = grandTotal + element['Diversity'];
      leadWiseList.add(model);
    });
    var denominator = (leadWiseList.length - totalNumber) * 100;
    double perc = grandTotal / denominator * 100;
    List<DiversitySubModuleData> leadWiseList1 = leadWiseList; // Replacing Grand total is the top of the value
    leadWiseList.clear();
    leadWiseList.add(DiversitySubModuleData(name: 'GRAND TOTAL',
        diversityPercentage: double.parse((perc).toStringAsFixed(2))));
    module.leadWiseList.forEach((element) {
      var model = DiversitySubModuleData(name: element['Secondaryleadname'],
          diversityPercentage: element['Diversity']);
      leadWiseList.add(model);
    });
    grandTotal = 0.00;
    totalNumber = 0;
    module.countryWiseList.forEach((element) {
      var model = DiversitySubModuleData(name: element['CountryName'],
          diversityPercentage: element['Diversity']);
      countryWiseList.add(model);
      grandTotal = grandTotal + element['Diversity'];
      if(element['Diversity'] == 0.00){ // Removing zero values
        totalNumber = totalNumber + 1;
      }
    });

    var denominator1 = (countryWiseList.length - totalNumber) * 100;
    double perc1 = grandTotal / denominator1 * 100;
    final List<DiversitySubModuleData> countryWiseList1 = countryWiseList;
    countryWiseList.clear();
    countryWiseList.add(DiversitySubModuleData(name: 'GRAND TOTAL',
        diversityPercentage: double.parse((perc1).toStringAsFixed(2))));
    module.countryWiseList.forEach((element) {
      var model = DiversitySubModuleData(name: element['CountryName'],
          diversityPercentage: element['Diversity']);
      countryWiseList.add(model);
    });
    grandTotal = 0.00;
    totalNumber = 0;
    module.gradeWiseList.forEach((element) {
      var model = DiversitySubModuleData(
          name: element['Grade'], diversityPercentage: element['Diversity']);
      grandTotal = grandTotal + element['Diversity'];
      gradeWiseList.add(model);
      if(element['Diversity'] == 0.00){ // Removing zero values
        totalNumber = totalNumber + 1;
      }
    });

    var denominator2 = (gradeWiseList.length - totalNumber) * 100;
    double perc2 = grandTotal / denominator2 * 100;
    final List<DiversitySubModuleData> gradeWiseList1 = gradeWiseList;
    gradeWiseList.clear();
    gradeWiseList.add(DiversitySubModuleData(name: 'GRAND TOTAL',
        diversityPercentage: double.parse((perc2).toStringAsFixed(2))));
    module.gradeWiseList.forEach((element) {
      var model = DiversitySubModuleData(
          name: element['Grade'], diversityPercentage: element['Diversity']);
      grandTotal = grandTotal + element['Diversity'];
      gradeWiseList.add(model);
    });
    grandTotal = 0.00;
    totalNumber = 0;
    module.deptWiseList.forEach((element) {
      var model = DiversitySubModuleData(name: element['DepartmentName'],
          diversityPercentage: element['Diversity']);
      grandTotal = grandTotal + element['Diversity'];
      deptWiseList.add(model);
      if(element['Diversity'] == 0.00){ // Removing zero values
        totalNumber = totalNumber + 1;
      }
    });
    var denominator3 = (deptWiseList.length - totalNumber) * 100;
    double perc3 = grandTotal / denominator3 * 100;
    final List<DiversitySubModuleData> deptWiseList1 = deptWiseList;
    deptWiseList.clear();
    deptWiseList.add(DiversitySubModuleData(name: 'GRAND TOTAL',
        diversityPercentage: double.parse((perc3).toStringAsFixed(2))));
    module.deptWiseList.forEach((element) {
      var model = DiversitySubModuleData(name: element['DepartmentName'],
          diversityPercentage: element['Diversity']);
      grandTotal = grandTotal + element['Diversity'];
      deptWiseList.add(model);
    });

    isAPILoads = true;

    return DashBoard(leadWiseList: leadWiseList,
        deptWiseList: deptWiseList,
        countryWiseList: countryWiseList,
        gradeWiseList: gradeWiseList);
  } on SocketException catch (_) {
       // print('not connected');
       setState(() {
         _load = false;
       });
       if (!_isAlertShows)
          _showDialog(SOCKET_EXCEPTION_ERROR, "AID");

     }
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load ? new Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),
          child: new Center(child: new CircularProgressIndicator())),
    ) : new Container();
    return Scaffold(
      appBar: AppBar(
        title: Text(DIVERSITY_DASHBOARD),
      ),
      // body: _buildBody(),
      body: SmartRefresher (
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: () async {
          fetchData();
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
        currentIndex: _cIndex,
        type: BottomNavigationBarType.fixed ,
        items: [
          // new BottomNavigationBarItem(
          //     backgroundColor: Colors.white,
          //     icon: new Image.asset('Assets/close.png'),
          //     title: new Text("Route1", style: new TextStyle(
          //         color: const Color(0xFF06244e), fontSize: 14.0))),
          BottomNavigationBarItem(
              icon: Icon(Icons.home,color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Dashboard')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.speaker,color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Speak')
          )
        ],
        onTap: (index){
          _incrementTab(index);
        },
      ),
    );
  }

  _buildDashBoardView() {
    if (isAPILoads = false) {
        setState(() {
          _load = false;
        });
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
              _buildPageViewForSepak(),
              _buildCircleIndicatorForCircle(),
              // new Align(
              //   child: loadingIndicator, alignment: Alignment.centerRight,)
            ],
          ),
        ],
      ),
    );
  }
  _speakContainer(int index){
    return Container(
      // color: Colors.yellow.withAlpha(64)
      //  color: Colors.white,
        child: new Column(
          children: <Widget>[
            SizedBox(height: 40, child:  new Container(
              alignment: Alignment.centerLeft,
              color: Colors.black54,
              padding: const EdgeInsets.all(10.0),
              child: AutoSizeText(speachList[index]['Name'], maxLines: 1, maxFontSize: 21.0,style: new TextStyle(fontSize: 21.0,fontWeight: FontWeight.w400, color: Colors.white),) ,
            ),),
            SizedBox(height: 15,),
            _circleImaeNetwrok((speachList[index]['ResourceID'])),
            SizedBox(height: 15,),
            _message(index),
          ],
        )
    );
  }

  _buildPageView() {
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData.size.height;
    double height = 0.0;
    if (MediaQuery.of(context).orientation == Orientation.landscape){
      height = screenHeight - 127.0;
    }else {
      height = screenHeight - 184.0;
    }
    return Container(
      height: height,
      child: PageView.builder(
          itemCount: 4,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: _DiversityTableView(_currentPageNotifier.value),
            );
          },
          onPageChanged: (int index) {
            setState(() {
              _currentPageNotifier.value = index;
            });
          }),
    );
  }
  _buildCircleIndicator() {
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
  _circleImaeNetwrok(int resourceID){

     var image =  imageList.singleWhere((element) => element.resourceid == resourceID,orElse: () => null);
      print(image);
    // return Container(
    //   child:  CircleAvatar(
    //     radius: 125.0,
    //     backgroundImage: AssetImage('Assets/profile_img.png'),
    //     // backgroundImage:
    //     // NetworkImage(image.Image),
    //     backgroundColor: Colors.transparent,
    //   ),
        // child: CachedNetworkImage(
        //   imageUrl: image.Image,
        //   progressIndicatorBuilder: (context, url, downloadProgress) =>
        //       CircularProgressIndicator(value: downloadProgress.progress),
        //   placeholder: (context, url) => {return NetworkImage('')},
        //   errorWidget: (context, url, error) => Icon(Icons.error),
        // )
    //   margin: EdgeInsets.all(1.0),
    //   decoration: BoxDecoration(
    //       shape: BoxShape.circle
    //   ),
    //   child: FadeInImage.assetNetwork(
    //     placeholder: 'Assets/profile_img.png',
    //     image: image.Image ?? 'http://AID.cognizant.com/assets/img/profile/b30aba26-537e-4092-938d-f09640f4cd34.jpg',
    // ),
    // );

     // return Image.network("http://aid.cognizant.com/assets/img/profile/fbd976b9-f3f6-416d-88d6-60b05caa6d31.jpg", headers: {HttpHeaders.authorizationHeader: "Bearer $accessTokenValue"},);
     // return Image.network("http://10.154.201.115/Images/avatar5.png",  headers: {HttpHeaders.authorizationHeader: "Bearer $accessTokenValue"});
     return Image.network("https://homepages.cae.wisc.edu/~ece533/images/airplane.png",);

  }
  _message(int index) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.no,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.no,
      // color: Color.fromARGB(255, 225, 255, 199),
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );
    return Container(
      child:
         Bubble (
          shadowColor: Colors.red,
          elevation: 5,
          child: Text(speachList[index]['Message']),
        ),

    );
   // return  Container (
   //    child: Row(
   //      crossAxisAlignment: CrossAxisAlignment.center,
   //      mainAxisSize: MainAxisSize.max,
   //      mainAxisAlignment: MainAxisAlignment.start,
   //      children: <Widget>[
   //        new Container(
   //            child: new Column(
   //              crossAxisAlignment: CrossAxisAlignment.start,
   //              mainAxisAlignment: MainAxisAlignment.start,
   //              // mainAxisSize: MainAxisSize.max,
   //              children:<Widget> [
   //                // CachedNetworkImage(
   //                //   imageUrl: "http://via.placeholder.com/350x150",
   //                //   placeholder: (context, url) => CircularProgressIndicator(),
   //                //   errorWidget: (context, url, error) => Icon(Icons.error),
   //                // ),
   //                CircleAvatar(
   //                  radius: 30.0,
   //                  backgroundImage: AssetImage('Assets/profile_img.png'),
   //                  // backgroundImage:
   //                  // NetworkImage('https://via.placeholder.com/150'),
   //                  backgroundColor: Colors.transparent,
   //                )
   //              ],
   //            )
   //        ),
   //        Expanded(
   //          child: Bubble (
   //            shadowColor: Colors.red,
   //            elevation: 5,
   //            child: Text(speachList[index]['Message']),
   //          ),
   //        )
   //      ],
   //    ),
   //  );
  }
  _buildPageViewForSepak() {
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData.size.height;
    double height = 0.0;
    if (MediaQuery.of(context).orientation == Orientation.landscape){
      height = screenHeight - 127.0;
    }else {
      height = screenHeight - 184.0;
    }
    return Container(
      height: height,
      child: PageView.builder(
          itemCount: speachList.length,
          controller: _pageControllerForSpeak,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: new ListView.builder(itemCount: 1, itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: _speakContainer(_currentPageNotifierForSpeak.value),
                );
              }),
              // child: _speakContainer(_currentPageNotifierForSpeak.value),
            );
          },
          onPageChanged: (int index) {
            setState(() {
              _currentPageNotifierForSpeak.value = index;
            });
          }),
    );
  }
  _buildCircleIndicatorForCircle() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: speachList.length,
          currentPageNotifier: _currentPageNotifierForSpeak,
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

   _changeTheView(int index) {

      if(index == 0)
        return _buildDashBoardView();
      else if (index == 1)
        setState(() {
          _load = false;
        });
        return _buildDashBoardSpeak();

  }

  Map<int, Widget> _children = {
    0: Text('Dashboard'),
    1: Text('Speak'),
  };

  Container _DiversityTableView(int value)  {
    String title = '';
    String headerTitle = '';
    switch (value) {
      case 0: { finalData = module.leadWiseList; title = 'Lead-Wise'; headerTitle = 'Lead Name'; break;}
      case 1: { finalData = module.gradeWiseList; title = 'Grade-Wise'; headerTitle = 'GRADE'; break;}
      case 2: { finalData = module.countryWiseList; title = 'Country-Wise'; headerTitle = 'Country'; break;}
      case 3: { finalData = module.deptWiseList; title = 'Dept-Wise'; headerTitle = 'DEPT'; break;}
      default:
        break;
    }
    int length = finalData?.length ?? 0;
    return  new Container(
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
                    SizedBox(height: 45.0, child: new ListView.builder( itemCount: 1, physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            color : Colors.lightBlue[100],
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: <Widget>[
                                  HeadeName(headerTitle, FontWeight.bold, index, false),
                                  itemName("Diversity in %", FontWeight.bold, index, false),
                                ],
                              ),
                            ),
                          );
                        })),
//                      SizedBox(height: 20.0,),

                    new Expanded(child:ListView.builder(
                        itemCount: length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: (index%2==0)?Colors.grey[350] :Colors.white,
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  HeadeName(finalData[index].name.toString() ?? '', FontWeight.normal, index,true),
                                  itemName(finalData[index].diversityPercentage.toString() ?? '',FontWeight.normal, index, true),
                                  Divider(),
                                ],
                              ),
                            ),
                          );
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
  void _showDialog(String message, String msgtitle) {
    // flutter defined function
    _isAlertShows = true;
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
                _isAlertShows = false;
              },
            ),
          ],
        );
      },
    );
  }
@override
void dispose() {
 _refreshController.dispose();
 super.dispose();
}
}
class DashBoard {
  List<DiversitySubModuleData> leadWiseList;
  List<DiversitySubModuleData> countryWiseList;
  List<DiversitySubModuleData> gradeWiseList;
  List<DiversitySubModuleData> deptWiseList;

  DashBoard({this.leadWiseList, this.countryWiseList, this.deptWiseList, this.gradeWiseList,});
}
