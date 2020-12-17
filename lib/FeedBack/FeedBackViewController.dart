
import 'dart:io';
import 'dart:ui';

import 'package:aid/CommonMethods.dart';
import 'package:aid/FeedBack/FeedbackAPI.dart';
import 'package:aid/FeedBack/FeedbackModel.dart';
import 'package:aid/VoiceOfAnAbbottian/VoiceModel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';
import 'package:aid/constants.dart';
import 'package:aid/FeedBack/FeedbackModel.dart';
import 'package:file_picker/file_picker.dart';
class FeedBackViewController extends StatefulWidget {

  final String accessToken;
  final String employeeID;
  final Map<String, dynamic> userDetails;  // final bool isPrimaryLead;
  final List< dynamic> roles;
  FeedBackViewController({Key key, @required this.accessToken, this.employeeID, this.roles, this.userDetails }) : super(key: key);

  @override
  _FeedBackViewControllerState createState() => _FeedBackViewControllerState();
}


class _FeedBackViewControllerState extends State<FeedBackViewController> with TickerProviderStateMixin  {
  RefreshController _refreshController =  RefreshController(initialRefresh: false);
  static final _myTabbedPageKey = new GlobalKey();
  String get accessToken => widget.accessToken;
  String get employeeID => widget.employeeID;
  bool _load = false;
  bool _isAlertShows = false;
  List< dynamic> get roles=> widget.roles;
  Map<String, dynamic> get userDetails => widget.userDetails;
  List<Employee> employees;
  final messageTextField = TextEditingController();
  final othersTextField = TextEditingController();

  static const List<String> typeDropDown = const ['Issue', 'Feedback', 'Enhancement', 'Test Suit', 'New Requirement', 'POC', 'Mobile', 'Content', 'Vulnerability'];
  String _type;
  ModuleList _MenuModules;
  ModuleList _subMenuModules;
  TabController tabController;
  FeedBack feedback;
  @override
  Widget build(BuildContext context) {

    // int tiles; // By default one dashborad should be there
    final List<Tab> myTabs = <Tab>[];
    TabBarView  tabBarViews;
    myTabs.add(new Tab(text: 'Feedback',));
    tabBarViews = new TabBarView(children: [myVoiceUI()]); // By default one dash board shoul be there

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
                    title: Text(FEEDBACK_MODULE),
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
      getFeedbackTitles();
    }
  }
  Map<String, String> get headers => {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  getFeedbackTitles() {
    setState(() {
      _load = true; //
    });
    try {
      getFeedbackModules(FEEDBACK_MODULES+employeeID, headers: headers).then((value) {
        if (mounted) {
          if(value.item2 != null &&  value.item2.ErrorCode == 401) {
            if (!_isAlertShows)
              Commonmethod.alertToShow("Session Expired...Please try to Login Again", 'Warning', context);
          }
          else if (value.item2 != null) {
            if (!_isAlertShows)
              Commonmethod.alertToShow((value.item2.ErrorDesc), 'Error', context);
          }

        }
        feedback = value.item1;
        setState(() {
          _load = false;
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

    return  new ListView.builder(itemCount: 1,shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(1),
            margin: EdgeInsets.all(1),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        ListTile(
                          title:   RichText(
                            text: TextSpan(
                                text: 'Type',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                                children:
                                [
                                  TextSpan(
                                    text:' *',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16.0),
                                  ),                                           ]
                            ),
                          ),
                          subtitle: DropdownButton<String>(
                            isExpanded: true,
                            value: _type,
                            underline: Container(),
                            items: typeDropDown
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
                                _type = value;
                                _subMenuModules = null;
                                _MenuModules = null;
                                othersTextField.text = '';
                              });
                            },
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title:   RichText(
                            text: TextSpan(
                                text: 'Module Name',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                                children:
                                [
                                  TextSpan(
                                    text:' *',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16.0),
                                  ),                                           ]
                            ),
                          ),
                          subtitle: DropdownButton<ModuleList>(
                            isExpanded: true,
                            value: _MenuModules ?? null,
                            underline: Container(),
                            items: (feedback != null) ? feedback.Modules.map<DropdownMenuItem<ModuleList>>((ModuleList value) {
                              return DropdownMenuItem<ModuleList>(
                                value: value,
                                child: Text(value.ModuleName, overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: true,),
                              );
                            }).toList() : [],
                            onChanged: (ModuleList value) {
                              setState(() {
                                _MenuModules = value;
                                _subMenuModules = null;
                                // _subMenuModules = value.subModuleList[0] ?? ModuleList();
                              });
                            },
                          ),
                        ),
                        Divider(),
                        (_MenuModules != null && _MenuModules.ModuleName == 'Others') ? ListTile(
                          title : RichText(
                            text: TextSpan(
                                text: 'Give a valid issue classification (Module)',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                                children:
                                [
                                  TextSpan(
                                    text:' *',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16.0),
                                  ),
                                ]
                            ),
                          ),
                          subtitle: TextField(
                            controller: othersTextField,
                            minLines: 1,
                            maxLines: 1,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: '',
                              filled: true,
                              // fillColor: Color(0xFFDBEDFF),
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
                          trailing: IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              // do something
                              othersTextField.text = "";
                            },
                          ),
                        ) : Container(),
                        (_MenuModules.ModuleName == 'Others') ? Container() : (_MenuModules?.subModuleList?.length == 0) ? Container()  : ListTile(
                          title:   RichText(
                            text: TextSpan(
                                text: 'Sub Module Name',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                                children:
                                [
                                  TextSpan(
                                    text:' *',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16.0),
                                  ),
                                ]
                            ),
                          ),
                          subtitle: DropdownButton<ModuleList>(
                            isExpanded: true,
                            value: _subMenuModules ?? null,
                            underline: Container(),
                            items: (_MenuModules != null) ?_MenuModules.subModuleList.map<DropdownMenuItem<ModuleList>>((ModuleList value) {
                              return DropdownMenuItem<ModuleList>(
                                value: value,
                                child: Text(value.ModuleName, overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: true,),
                              );
                            }).toList() : [],
                            onChanged: (ModuleList value) {
                              setState(() {
                                _subMenuModules = value;
                              });
                            },
                          ),
                        ) ,
                        ListTile(
                          title: Text((_type ?? '') + " Description"),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextField(
                              controller: messageTextField,
                              minLines: 10,
                              maxLines: 15,
                              autocorrect: false,
                              decoration: InputDecoration(
                                hintText: '',
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            _uploadButton(),
                            _submitButton()
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

        });
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
            _submitFeedBack();
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

  _uploadButton() {
    return Material (
      elevation: 5.0,
      borderRadius:  BorderRadius.circular(30.0),
      color: Color(0xFFDBEDFF),
      child: MaterialButton(
        // minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: ()
          async {
            FilePickerResult result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['docx', 'pdf', 'doc'],
            );
            if(result != null) {
              PlatformFile file = result.files.first;
              print(file.name);
              print(file.bytes);
              print(file.size);
              print(file.extension);
              print(file.path);
            } else {
              // User canceled the picker
            }
          },
          child: Text(
            "Upload",
            textAlign: TextAlign.center,
            // style: style.copyWith(
            //     color: Colors.white, fontWeight: FontWeight.bold),
          )
      ),
    );
  }
  get toPostParameters => jsonEncode({
    'UploadAttachmentList': [],
    'EmployeeId': employeeID ?? "",
    'Type': _type ?? "",
    'ModuleName': _MenuModules.ModuleName,
    'SubModuleName': (_MenuModules.subModuleList?.length > 0) ? _subMenuModules.ModuleName : "",
    'Description': messageTextField.text,
    'Status':1,
    'OtherModule': othersTextField.text ?? "",
    'OtherSubModule':null,
    'Developer':'111111',
    'IssueId':'',
    'ReleasenotestableId':1
  });

  _submitFeedBack(){

    if(_type == "" || _type == null)
      return Commonmethod.alertToShow("Please select the Type of issue", 'Warning', context);
    else if(_MenuModules == null) {
      return Commonmethod.alertToShow("Please select the Module Name", 'Warning', context);
    }else if (_MenuModules.ModuleName != 'Others') {
       if (_MenuModules?.subModuleList?.length > 0 &&_subMenuModules == null) {
       return Commonmethod.alertToShow("Please select the sub module name", 'Warning', context);
      }
    }else if(_MenuModules.ModuleName == 'Others' && othersTextField.text.length == 0){
      return Commonmethod.alertToShow("Please enter the others field", 'Warning', context);
    }
    else if (messageTextField.text.length == 0) {
      return Commonmethod.alertToShow("Please enter the description", 'Warning', context);
    }
    setState(() {
      _load = true; //
    });
    submitFeedback(SUBMIT_FEEDBACK, body: toPostParameters, headers: headers).then((response) {
      setState(() {
        _load = false; //
      });
      if (response) {
          _type = '';
          _subMenuModules = ModuleList();
          _MenuModules = ModuleList();
          messageTextField.text = '';
          othersTextField.text = '';
          Commonmethod.alertToShow("Feedback is created successfully", 'Success', context);

      }else {
        Commonmethod.alertToShow("Internal server error. Please try again", 'Error', context);
      }
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}

