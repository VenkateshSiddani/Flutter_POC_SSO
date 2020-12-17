import 'dart:io';
import 'dart:ui';

import 'package:aid/CommonMethods.dart';
import 'package:aid/VoiceOfAnAbbottian/VoiceModel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';
import 'package:aid/constants.dart';
import 'DottedBorder.dart';
import 'VoiceOfAnAbbottianAPI.dart';
import 'dart:convert';
import 'package:flutter_gifimage/flutter_gifimage.dart';


class VoiceOfAnAbbottianViewController extends StatefulWidget {

  final String accessToken;
  final String employeeID;
  final Map<String, dynamic> userDetails;  // final bool isPrimaryLead;
  final List< dynamic> roles;
  VoiceOfAnAbbottianViewController({Key key, @required this.accessToken, this.employeeID, this.roles, this.userDetails }) : super(key: key);

  @override
  _VoiceOfAnAbbottianViewControllerState createState() => _VoiceOfAnAbbottianViewControllerState();
}


class _VoiceOfAnAbbottianViewControllerState extends State<VoiceOfAnAbbottianViewController> with TickerProviderStateMixin  {
  RefreshController _refreshController =  RefreshController(initialRefresh: false);
  static final _myTabbedPageKey = new GlobalKey();
  String get accessToken => widget.accessToken;
  String get employeeID => widget.employeeID;
  bool _load = false;
  bool _isAlertShows = false;
  List< dynamic> get roles=> widget.roles;
  Voices voices = Voices(myVoices: [], allVoices: [], otherVoices: []);
  Map<String, dynamic> get userDetails => widget.userDetails;
  List<Employee> employees;
  final messageTextField = TextEditingController();
  static const List<String> myVoiceSubject = const [
    'I have a feedback about a process',
    'I have a feedback / appreciation for someone',
    'I am frustrated, I would like to share my thoughts / emotions',
    'I would like a change in my role',
    'I would like to be an agent of change',
    'I would like to suggest some improvements',
    'One thing I would change if I were the Delivery Lead ',
  ];
  String _suject;
  bool _IsAnonymous = false;
  var scr= new GlobalKey(); // Screenshot without border
  var scr1= new GlobalKey(); // Screenshot with border
  String base64Image = "";
  List<Map> VoiceOfAbbottianToList = new List();
  bool submitVoiceGIF = false;
  bool screenShotImage = false;
  TabController tabController;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GifController controller1;
  List<Employee> selectedEmployees = [];
  // Image image;
  AssetImage image;

  @override
  Widget build(BuildContext context) {

    // int tiles; // By default one dashborad should be there
    final List<Tab> myTabs = <Tab>[];
    TabBarView  tabBarViews;
    
    List<dynamic> isPrimary = roles.where((element) => element["Name"] == "PrimaryLead").toList();
    
    if(isPrimary.length > 0) {// Primary lead we are showing AllVoices Tab
      myTabs.add(new Tab(text: 'My Voice',));
      myTabs.add(new Tab(text: 'My Voices',));
      myTabs.add(new Tab(text: 'Shoutouts to me',));
      myTabs.add(new Tab(text: 'All Voices',));
      tabBarViews = new TabBarView(children: [myVoiceUI(),(voiceDetailsUI(1, voices.myVoices)),(voiceDetailsUI(2, voices.otherVoices)),(voiceDetailsUI(3, voices.allVoices)) ]); // By default one dash board shoul be there
    }else {
      myTabs.add(new Tab(text: 'My Voice',));
      myTabs.add(new Tab(text: 'My Voices',));
      myTabs.add(new Tab(text: 'Shoutouts to me',));
      tabBarViews = new TabBarView(children: [myVoiceUI(),(voiceDetailsUI(1, voices.myVoices)),(voiceDetailsUI(2, voices.otherVoices)), ]); // By default one dash board shoul be there

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
            child: DefaultTabController(
              length: myTabs.length ?? 0,
              child: new Scaffold(
                  appBar: new AppBar(
                    title: Text(VOICE_MODULE),
                    bottom: new TabBar(
                      isScrollable: true,
                      tabs: myTabs,
                    ),
                  ) ,
                  body: new Stack(
                    children: [
                      tabBarViews,
                      new Align(
                        child: loadingIndicator, alignment: Alignment.center,
                      )
                    ],
                  )
              ) ,
            ),
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        }
    );
  }


  @override
  void initState() {
    super.initState();
    image = AssetImage('Assets/VOAbottian/postcard-animation.gif');
    // TODO: implement initState
    controller1 = GifController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_){
      controller1.repeat(min: 0,max: 238,period: Duration(milliseconds: 20000));
    });
    fetchData();
  }

  refreshTheDashboard(){
    fetchData();
  }
  void fetchData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none)  {
      Commonmethod.alertToShow(CONNECTIVITY_ERROR, 'AID', context);
    } else {
      getAllVoiceAbbottian();
      getAllVoiceOFEmployees();
    }
  }
  Map<String, String> get headers => {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };


  getAllVoiceAbbottian() {
    setState(() {
      _load = true; //
    });
    try {
      getVoiceOfAbbottian(VOICE_ABBOTTIAN+employeeID, headers: headers).then((value) {
        if (mounted) {
          if(value.item2 != null &&  value.item2.ErrorCode == 401) {
            if (!_isAlertShows)
              Commonmethod.alertToShow("Session Expired...Please try to Login Again", 'Warning', context);
          }
          else if (value.item2 != null) {
            if (!_isAlertShows)
              Commonmethod.alertToShow((value.item2.ErrorDesc), 'Error', context);
          }
          _load = false;
        }
        setState(() {
          voices = value.item1;
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        });
      });

    } on SocketException catch (_) {
      setState(() {
        _load = false;
        _refreshController.loadComplete();
        _refreshController.refreshCompleted();
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);
    }
  }

  getAllVoiceOFEmployees() {
    setState(() {
      _load = true; //
    });
    try {
      getAllEmployees(VOICE_ALLEMPLOYEES, headers: headers).then((value) {
        if (mounted) {
          if(value.item2 != null &&  value.item2.ErrorCode == 401) {
            if (!_isAlertShows)
              Commonmethod.alertToShow("Session Expired...Please try to Login Again", 'Warning', context);
          }
          else if (value.item2 != null) {
            if (!_isAlertShows)
              Commonmethod.alertToShow((value.item2.ErrorDesc), 'Error', context);
          }
          _load = false;
        }
        setState(() {
          employees = value.item1;
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        });
      });

    } on SocketException catch (_) {
      setState(() {
        _load = false;
        _refreshController.loadComplete();
        _refreshController.refreshCompleted();
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);
    }
  }


  Widget myVoiceUI(){
    return (submitVoiceGIF) ? new Container(
        width: 125.0,
        height: 125.0,
        decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            image: new DecorationImage(
                fit: BoxFit.fitWidth,
                image: image
            )
        )) : new ListView.builder(itemCount: 2,shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            // color : Colors.lightBlue[100],
            padding: EdgeInsets.all(1),
            margin: EdgeInsets.all(1),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: (index == 0) ? Column(
                children: <Widget>[
                  RepaintBoundary (
                    key: scr,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("Assets/VOAbottian/Postcard.png"),
                              fit: BoxFit.fill
                          )
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          ListTile(
                            title: Text("From :",style: TextStyle(
                              color: Colors.grey,
                            ),),
                            subtitle: (_IsAnonymous) ? Text("Anonymous", style: TextStyle(
                              color: Colors.black,
                            ),) : Text("\n${userDetails["FirstName"]} ${userDetails["LastName"]}", style: TextStyle(
                              color: Colors.black,
                            ),),
                            trailing: Commonmethod.getCircularImage(Singleton.profileURL, accessToken)   //_circleImaeNetwrok(),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Subject",style: TextStyle(
                              color: Colors.grey,
                            ),),
                            subtitle: DropdownButton<String>(
                              isExpanded: true,
                              value: _suject,
                              underline: Container(),
                              items: myVoiceSubject
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,),
                                );
                              }).toList(),
                              onChanged: (String value) {
                                setState(() {
                                  _suject = value;
                                });
                              },
                            ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("To",style: TextStyle(
                              color: Colors.grey,
                            )),
                            subtitle:  (_suject != "I have a feedback / appreciation for someone") ? new Container(
                              child: Text("Santosh Damodara", style: TextStyle(
                                color: Colors.black,
                              ),),
                            ) : _searchEmployees(),
                           trailing: (_suject != "I have a feedback / appreciation for someone") ? Commonmethod.getCircularImage(SANTOSH_IMAGE_URL, accessToken) : null
                          ),
                          Divider(),
                          Text("${Commonmethod.convertDateToDefaultFomrate(DateTime.now().toString())}", style: TextStyle(color: Colors.black54, fontSize: 18.0),),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextField(
                                controller: messageTextField,
                                minLines: 10,
                                maxLines: 15,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  hintText: 'Seek meaning to your voice',
                                  filled: true,
                                  fillColor: Color(0xFFDBEDFF),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: _CTSLogo(),
                            trailing: _abbottLogo(),
                          ),
                          Divider(),
                        ],
                      ),
                    ),

                  )
                ],
              ) : Column(
                children: [
                  Card(
                    child: MergeSemantics(
                      child: ListTile(
                        title: Text("Do you want to voice out anonymously? "),
                        trailing: CupertinoSwitch(
                            value: _IsAnonymous,
                            onChanged: (bool value) {
                              setState(() {
                                _IsAnonymous = value;
                              });
                            }
                        ),
                        onTap: () {
                          setState(() {
                            _IsAnonymous = !_IsAnonymous;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  _submitButton(),
                  // RepaintBoundary(
                  //     key: scr,
                  //     child: new FlutterLogo(size: 50.0,))
                ],
              ),
            ),
          );

        });
  }

  _searchEmployees(){

    List datasource = [];
    employees.forEach((element) {
      var identifier = new Map();
      identifier["name"] = element.empName;
      identifier["code"] = element.empID.toString();
      datasource.add(identifier);
    });
    return new Form(
      key: _formKey,
      autovalidate: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new MultiSelect(
              autovalidate: true,
              initialValue: [],
              titleText: '',
              maxLength: 4, // optional
              validator: (dynamic value) {
                if (value == null) {
                  return 'Please select one or more option(s)';
                }
                selectedEmployees = [];
                value.forEach((element){
                  print(element);
                  List<Employee> list = employees.where((item) => item.empID.toString() == element ).toList();
                  if(list.length > 0){
                    selectedEmployees.add(list[0]);
                  }
                });

                return null;
              },
              errorText: 'Please select one or more option(s)',
              dataSource: datasource,
              textField: "name",
              valueField: "code",
              filterable: true,
              required: true,
              onSaved: (value) {
                // print('The value is $value');
              },
              selectIcon: Icons.arrow_drop_down_circle,
              saveButtonColor: Theme.of(context).primaryColor,
              checkBoxColor: Theme.of(context).primaryColorDark,
              cancelButtonColor: Theme.of(context).primaryColorLight,
            ),
          ),
        ],
      ),
    );
  }
  _submitButton() {
    return Material (
      elevation: 5.0,
      borderRadius:  BorderRadius.circular(30.0),
      color: Color(0xFFDBEDFF),
      child: MaterialButton(
        // minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: ()
          async {
            takescrshotWithoutBorder();
          },
          child: Text(
            "Submit",
            textAlign: TextAlign.center,
            // style: style.copyWith(
            //     color: Colors.white, fontWeight: FontWeight.bold),
          )
      ),
    );
  }


  myVoiceGreeting(String base64){
    return RepaintBoundary(
      key: scr1,
      child: Container(
        decoration: BoxDecoration (
            image: DecorationImage(
                image: AssetImage("Assets/VOAbottian/Postcard.png"),
                fit: BoxFit.fill
            )
        ),
        child: Image.memory(base64Decode(base64)),
      ),
    );
  }

  takescrshotWithoutBorder() async {
    RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    base64Image = base64Encode(pngBytes);
    if(base64Image.length > 0){
      submitVoice();
    }else {
      Commonmethod.alertToShow("Internal server error, Please try again", 'Error', context);
    }
  }
  takescrshotWithBorder() async {

    RenderRepaintBoundary boundary = scr1.currentContext.findRenderObject();
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    // base64Image = base64Encode(pngBytes);
    // base64Image = base64Encode(pngBytes);
    if(base64Image.length > 0){
      submitVoice();
    }else {
      Commonmethod.alertToShow("Internal server error, Please try again", 'Error', context);
    }
  }

  List<Map> toVoiceOfAbbottainList() {
    List<Map> toList = [];
    selectedEmployees.forEach((element) {
      var map = new Map<String, dynamic>();
      map["ToId"] = element.empID ?? "";
      map["ToImage"] = "";
      map["toImage"] = "";
      map["ToName"] = element.empName ?? "";
      toList.add(map);
    });
    return toList;
  }



  get toPostParameters => jsonEncode({
    'FromId':userDetails['EmployeeId'],
    'IsAnonymous': (_IsAnonymous) ? true : null,
    'Message':messageTextField.text ?? "",
    'PostcardImage':'data:image/png;base64,${base64Image ?? ""}',
    'SubmissionType': _suject,
    'VoiceOfAbbottianToList':toVoiceOfAbbottainList(),
    'Content-Type': 'application/json'
  });

  submitVoice(){
    // VoiceOfAbbottianToList.add(toVoiceOfAbbottainList());
    if(_suject == "" || _suject == null)
      return Commonmethod.alertToShow("Please select the subject", 'Warning', context);
    if(_suject != "I have a feedback / appreciation for someone") {
      Employee emp = Employee(empName:"Santosh Damodara" ,empID: 202980, empIMG:"" );
      selectedEmployees.add(emp);
    }
    if(selectedEmployees.length == 0)
      return Commonmethod.alertToShow("Please select To employee field", 'Warning', context);
    if(messageTextField.text.length == 0)
      return Commonmethod.alertToShow("Please enter message", 'Warning', context);
    setState(() {
      _load = true; //
    });
    submitVoiceAPI(VOICE_SUBMIT, body: toPostParameters, headers: headers).then((response) {
      setState(() {
        _load = false; //
      });
      if (response) {
        // Commonmethod.alertToShow("Submitted Successfully", 'Success', context);
        setState(() {
          submitVoiceGIF = true;
        });

        Future.delayed(const Duration(milliseconds: 20000), () {
          setState(() {
            submitVoiceGIF = false;
            _suject = null;
            selectedEmployees = [];
            messageTextField.text = "";
            _IsAnonymous = false;
            fetchData(); // Refresh
            image.evict(); // To start GIF from initial frame
          });

        });

      }else {
        Commonmethod.alertToShow("Internal server error. Please try again", 'Error', context);
      }
    });
  }


  _circleImaeNetwrok(){
    return Container(
      child:  CircleAvatar(
        radius: 30.0,
        backgroundImage: AssetImage('Assets/profile_img.png'),
        // backgroundImage:
        // NetworkImage(image.Image),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  _abbottLogo(){
    return Container(
      child: Image.asset('Assets/VOAbottian/abbott.png'),
    );
  }

  _CTSLogo(){
    return Container(
      child:  Image.asset('Assets/VOAbottian/CTS.png',),
    );
  }
  Widget voiceDetailsUI(int index, List<VoicesOfAnAbbottian> voicesOfAnAbbottian) {

    int count = voicesOfAnAbbottian.length ?? 0;
    if(count == 0)
      return Commonmethod.noRecordsFoundContainer("No Records Found");
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
                    cabDashboardList(voicesOfAnAbbottian,index),
//                      SizedBox(height: 20.0,),
                  ],

                ),
              ),
            )
          ],

        )
    );
  }



  cabDashboardList(List<VoicesOfAnAbbottian> voicesOfAnAbbottian, int selctedTab){

    // if(voicesOfAnAbbottian != null)
    //   return Commonmethod.noRecordsFoundContainer("No Records Found");
    int count = voicesOfAnAbbottian.length ?? 0;
    if(count == 0)
      return Commonmethod.noRecordsFoundContainer("No Records Found");

    List<Widget> coulums = [];
    if (selctedTab == 1){
      coulums.add(HeadeName("To", FontWeight.bold,));
      coulums.add(HeadeName("Subject", FontWeight.bold,));
      coulums.add(HeadeName("Message", FontWeight.bold,));
      coulums.add(HeadeName("Submitted Date", FontWeight.bold,));
    }else if (selctedTab > 1) {
      coulums.add(HeadeName("From", FontWeight.bold,));
      coulums.add(HeadeName("To", FontWeight.bold,));
      coulums.add(HeadeName("Subject", FontWeight.bold,));
      coulums.add(HeadeName("Message", FontWeight.bold,));
      coulums.add(HeadeName("Submitted Date", FontWeight.bold,));
    }
    return new Expanded(child: SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      onRefresh: () async {
        refreshTheDashboard();
      },
      child: ListView.builder(
          itemCount: count == 0 ? 1 : count + 1,
          itemBuilder: (context, index) {
            if (index == 0) { // Header
              return Container(
                color : Colors.lightBlue[100],
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                      children: coulums
                  ),
                ),
              );;
            }

            if(selctedTab == 1) {
              return InkWell(
                  onTap: () {
                    print('tapped ${index-1})');
                  },
                  child: Container(
                    color: ((index-1)%2==0)?Colors.grey[350] :Colors.white,
                    // color: Colors.green[300],
                    child:  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          itemName(voicesOfAnAbbottian[index-1].ToName ?? "",FontWeight.normal),
                          itemName(voicesOfAnAbbottian[index-1].SubmissionType ?? "",FontWeight.normal),
                          itemName(voicesOfAnAbbottian[index-1].Message,FontWeight.normal),
                          itemName(Commonmethod.convertDateToDefaultFomrate(voicesOfAnAbbottian[index-1].SubmittedDate),FontWeight.normal,),
                        ],
                      ),
                    ),
                  ));
            }
            return InkWell(
                onTap: () {
                  print('tapped ${index-1})');
                },
                child: Container(
                  color: ((index-1)%2==0)?Colors.grey[350] :Colors.white,
                  // color: Colors.green[300],
                  child:  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        itemName((voicesOfAnAbbottian[index-1].IsAnonymous) ? "Anonymous" :voicesOfAnAbbottian[index-1].FromName ,FontWeight.normal),
                        itemName(voicesOfAnAbbottian[index-1].ToName ?? "",FontWeight.normal),
                        itemName(voicesOfAnAbbottian[index-1].SubmissionType ?? "",FontWeight.normal),
                        itemName(voicesOfAnAbbottian[index-1].Message,FontWeight.normal),
                        itemName(Commonmethod.convertDateToDefaultFomrate(voicesOfAnAbbottian[index-1].SubmittedDate),FontWeight.normal,),
                      ],
                    ),
                  ),
                ));
          }
      ),
    ),
    );

  }
  // color: (index%2==0)?Colors.grey[350] :Colors.white,
  Widget itemName(String title, FontWeight fontWeight) {
    Widget column = Expanded(
      child: Column(
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 16, fontWeight: fontWeight), textAlign: TextAlign.center,),
        ],
      ),
    );
    return column;
  }

  Widget HeadeName(String name, FontWeight fontWeight,){
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

  @override
  void dispose() {
    _refreshController.dispose();
    image.evict();
    super.dispose();
  }
}

