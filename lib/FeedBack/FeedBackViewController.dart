
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
import 'package:image_picker/image_picker.dart';
import '../alert.dart';
import '../dialog_button.dart';
import 'FeedbackAPI.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  List<Developers> employees;
  Developers employee;
  final messageTextField = TextEditingController();
  final othersTextField = TextEditingController();

  static const List<String> typeDropDown = const ['Issue', 'Feedback', 'Enhancement', 'Test Suit', 'New Requirement', 'POC', 'Mobile', 'Content', 'Vulnerability'];
  String _type;
  ModuleList _MenuModules;
  ModuleList _subMenuModules;
  TabController tabController;
  FeedBack feedback;
  // List<Map<String, dynamic>> attachments = List<Map<String, dynamic>>();
  List<PlatformFile> attachments = List<PlatformFile>();
  String fileGUID = '';
  List<dynamic> fileNameList;
  List<dynamic> fileGUIDList;
  bool _isButtonDisabled;
  List<FeedbackIssues> productBL;
  List<FeedbackIssues> filteredProductBL;
  List<FeedbackIssues> feedBackEvalution;
  List<FeedbackIssues> underDev;
  List<FeedbackIssues> underQA;
  List<FeedbackIssues> dashboardTickets;
  SlidableController slidableController;
  TextEditingController editingController = TextEditingController();
  File _image;
  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  TextEditingController _commentsTextfieldController = TextEditingController();
  StateSetter _setState;

  @override
  Widget build(BuildContext context) {

    // int tiles; // By default one dashborad should be there
    final List<Tab> myTabs = <Tab>[];
    TabBarView  tabBarViews;
    List<dynamic> isPrimary = roles.where((element) => element["Name"] == "PrimaryLead").toList();
    List<dynamic> isAdmin = roles.where((element) => element["Name"] == "Admin").toList();
    if(isPrimary.length > 0) {
      myTabs.add(new Tab(text: 'Feedback',));
      myTabs.add(new Tab(text: 'Feedback Evaluation',));
      myTabs.add(new Tab(text: 'Product Backlog',));
      myTabs.add(new Tab(text: 'Under Dev',));
      myTabs.add(new Tab(text: 'Under QA',));
      tabBarViews = new TabBarView(children: [submitFeedBack(), feedbackEvaluation(), productBacklogTable(productBL), underDevTable(underDev), underQATable(underQA)]); // By default one dash board shoul be there
    }else if (isAdmin?.length > 0) {
      myTabs.add(new Tab(text: 'Feedback',));
      myTabs.add(new Tab(text: 'Product Backlog',));
      myTabs.add(new Tab(text: 'Under Dev',));
      myTabs.add(new Tab(text: 'Under QA',));
      tabBarViews = new TabBarView(children: [submitFeedBack(), productBacklogTable(productBL), underDevTable(underDev), underQATable(underQA)]); // By default one dash board shoul be there
    }else{
      myTabs.add(new Tab(text: 'Feedback',));
      tabBarViews = new TabBarView(children: [submitFeedBack()]);
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
  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    _isButtonDisabled = false;
    fetchData();
    super.initState();
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
      getProductBacklogs();
      getFeedbackEvaluation();
      getDashboard();
      getDevelopersDetails();
      getReleaseNotes();
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

  getProductBacklogs(){

    setState(() {
      _load = true;
    });
    try {
      getProductBackLog(PRODUCT_BACKLOGS + employeeID, headers: headers).then((value) {
        if (mounted) {
          if(value.item4 != null &&  value.item4.ErrorCode == 401) {
            if (!_isAlertShows)
              Commonmethod.alertToShow("Session Expired...Please try to Login Again", 'Warning', context);
          }
          else if (value.item4 != null) {
            if (!_isAlertShows)
              Commonmethod.alertToShow((value.item4.ErrorDesc), 'Error', context);
          }

        }
        productBL = value.item1.reversed.toList();
        underDev = value.item2;
        setState(() {
          _load = false;
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        });
      });
    }on SocketException catch (_) {
      setState(() {
        _load = false;
        _refreshController.loadComplete();
        _refreshController.refreshCompleted();
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);
    }
  }

  getReleaseNotes(){

    setState(() {
      _load = true;
    });
    try {
      getReleaseNoteDetails(RELEASENOTE_DETAILS, headers: headers).then((value) {
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
        underQA = value.item1;
        setState(() {
          _load = false;
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        });
      });
    }on SocketException catch (_) {
      setState(() {
        _load = false;
        _refreshController.loadComplete();
        _refreshController.refreshCompleted();
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);
    }
  }
  getDashboard(){

    setState(() {
      _load = true;
    });
    try {
      getDashboardDetails(DASHBOARD_DETAILS + employeeID, headers: headers).then((value) {
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
        dashboardTickets = value.item1;
        setState(() {
          _load = false;
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        });
      });
    }on SocketException catch (_) {
      setState(() {
        _load = false;
        _refreshController.loadComplete();
        _refreshController.refreshCompleted();
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);
    }
  }

  getDevelopersDetails(){

    setState(() {
      _load = true;
    });
    try {
      getEmployeesList(DEVELOPER_DETAILS, headers: headers).then((value) {
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
        employees = value.item1;
        setState(() {
          _load = false;
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        });
      });
    }on SocketException catch (_) {
      setState(() {
        _load = false;
        _refreshController.loadComplete();
        _refreshController.refreshCompleted();
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);
    }
  }

  getFeedbackEvaluation(){

    setState(() {
      _load = true;
    });
    try {
      getFeedBackEvaluation(FEEDBACK_EVALUATION, headers: headers).then((value) {
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
        feedBackEvalution = value.item1;
        setState(() {
          _load = false;
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        });
      });
    }on SocketException catch (_) {
      setState(() {
        _load = false;
        _refreshController.loadComplete();
        _refreshController.refreshCompleted();
      });
      if (!_isAlertShows)
        Commonmethod.alertToShow(SOCKET_EXCEPTION_ERROR, 'AID', context);
    }
  }


  Widget submitFeedBack(){

    return  new ListView.builder(itemCount: 1, shrinkWrap: true,
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
                        (_MenuModules != null && _MenuModules?.ModuleName == 'Others') ? Container() : (_MenuModules?.subModuleList != null && _MenuModules?.subModuleList?.length == 0) ? Container()  : ListTile(
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
                        ),
                        attachmentsTable(),
                        dashboardTable(dashboardTickets)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

        });
  }


  attachmentsTable(){
    return  ListView.builder(
        itemCount: (_image != null) ? 1 : 0,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                constraints: BoxConstraints(
                ),
                child: Center(
                  // child: Text(attachments[index].name.toString()),
                  child: ListTile(
                    title:Text(_image.path.split('/').last),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          // attachments.removeAt(index);
                          _image = null;
                        });
                      },
                    ),
                  ),
                ),
              )
          );
        });
  }

  feedbackEvaluation(){

    return Column (
      children: [
        Container(
          color : Colors.lightBlue[100],
          padding: const EdgeInsets.all(2),
          child: Center (
            child: ListTile(
                title: Text("Issue ID -- Module -- Sub Module -- Submitter -- Submitted Date -- Description",textAlign: TextAlign.center)),
          ),
        ),
        Expanded(
            child:  SmartRefresher(
                controller: _refreshController,
                enablePullUp: true,
                onRefresh: () async {
                  refreshTheDashboard();
                },
                child: ListView.builder(itemCount: feedBackEvalution?.length ?? 0,itemBuilder : (BuildContext context, int index) {
                  final Axis slidableDirection = Axis.horizontal;
                  return Slidable(
                    key: Key('Test'),
                    controller: slidableController,
                    direction: slidableDirection,
                    dismissal: SlidableDismissal(
                      child: SlidableDrawerDismissal(),
                    ),
                    actionPane: SlidableBehindActionPane(),
                    actionExtentRatio: 0.25,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'View',
                        color: Colors.lightBlueAccent,
                        icon: Icons.archive,
                        onTap: () => viewFeedbackAlert(feedBackEvalution[index]),
                        closeOnTap: false,
                      ),
                    ],
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        child: Center (
                          child: ListTile(
                            title: Text(feedBackEvalution[index].issueString + " -- " + (feedBackEvalution[index].Module ?? "") + " -- " + (feedBackEvalution[index].subModule ?? "") + " -- " + (feedBackEvalution[index].createdBy + " -- " + Commonmethod.convertDateToDefaultFomrate(feedBackEvalution
                            [index].submittedDate) ?? "") + " -- " + (feedBackEvalution[index].description ?? ""),textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                  );
                })
            )
        )
      ],
    );
  }
  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
  List<FeedbackIssues>  onItemChanged(String value, List<FeedbackIssues> feedback) {
    List<FeedbackIssues> searchResults = feedback
        .where((string) => string.issueString.contains(value) || string.Module.contains(value) || string.subModule.contains(value))
        .toList();
  }
  cancelAlert(){
    _commentsTextfieldController = TextEditingController();
  }
  viewFeedbackAlert(FeedbackIssues feedback){
    Alert(
      context: context,
      type: AlertType.none,
      title: "User Description",
      textFieldController: _commentsTextfieldController, //as TextEditingController()
      desc: feedback.description ?? "",
      imageURL: "",
      closeFunction: cancelAlert,
      buttons: [
        DialogButton(
          child: Text(
            "Approve",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            if(_commentsTextfieldController.text == '')
              return Commonmethod.alertToShow("Please Enter Comments", "Warning", context);
            else
              submitFeedbackWithChange(_commentsTextfieldController.text, 2, feedback, 111111, false);

          },
          color: Colors.greenAccent,
        ),
        DialogButton(
          child: Text(
            "Reject",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            if(_commentsTextfieldController.text == '')
              return Commonmethod.alertToShow("Please Enter Comments", "Warning", context);
            else
              submitFeedbackWithChange(_commentsTextfieldController.text, 3, feedback, 111111, false);
          },
          color: Colors.red[300],
        ),

      ],
    ).approveFeedbackAlert();
  }

  assignFeedbackIssue(FeedbackIssues feedback){

    showDialog(
      context: context,
      builder: (context) {
        String contentText = "Select Developer";
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              // title: Text("Select Developer"),
              content: DropdownButton<Developers>(
                isExpanded: true,
                value: employee ?? null,
                underline: Container(),
                items: (employees != null) ? employees.map<DropdownMenuItem<Developers>>((Developers value) {
                  return DropdownMenuItem<Developers>(
                    value: value ?? null,
                    child: Text(value.EmployeeName, overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true, ),
                  );
                }).toList() : [],
                onChanged: (Developers value) {
                  setState(() {
                    employee = value;
                    // _subMenuModules = value.subModuleList[0] ?? ModuleList();
                  });
                },
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: ()  async {
                    submitFeedbackWithChange("", 4, feedback, employee.Employeeid,false);
                  } ,
                  child: Text("Save"),
                ),
              ],

            );
          },
        );
      },
    );
  }

  devCompletedAlert(FeedbackIssues feedback){

    Alert(
      context: context,
      type: AlertType.none,
      title: "User Description",
      textFieldController: _commentsTextfieldController, //as TextEditingController()
      desc: feedback.description ?? "",
      secondTitle: "Product Owner Comments",
      secondDesc: feedback.LeadComments ?? "",
      imageURL: "",
      closeFunction: cancelAlert,
      buttons: [
        DialogButton(
          child: Text(
            "Save",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            if(_commentsTextfieldController.text == '')
              return Commonmethod.alertToShow("Please Enter Comments", "Warning", context);
            else
              devCompleted(_commentsTextfieldController.text, 5, feedback, feedback.Developer);

          },
          color: Colors.greenAccent,
        ),
        DialogButton(
          child: Text(
            "Back",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.red[300],
        ),

      ],
    ).devCompletedAlert();
  }


  // {"UploadAttachmentList":[],"EmployeeId":202980,"Id":2353,"IssueId":10352,"Developer":111111,"Status":2,"LeadComments":"Approved","ReleasenotestableId":1}

  getParameters(FeedbackIssues issue, String Comments, int approveOrReject, int DeveloperID) {
    return jsonEncode({
      'UploadAttachmentList': [],
      'EmployeeId': issue.EmployeeId,
      'Id': issue.ID,
      'IssueId': issue.issueID,
      'Status':approveOrReject,
      'Developer':DeveloperID,
      'LeadComments':Comments,
      'ReleasenotestableId':issue.ReleasenotestableId.toString() ?? ""
    });
  }

  submitFeedbackWithChange(String comments, int approveOrReject, FeedbackIssues issue, int DeveloperID, bool isRemooveAlert){
    if(!isRemooveAlert) {
      Navigator.pop(context);
    }

    setState(() {
      _load = true; //
    });
    submitFeedback(SUBMIT_FEEDBACK, body: getParameters(issue, comments, approveOrReject, DeveloperID), headers: headers).then((response) {
      setState(() {
        _load = false; //
      });
      if (response) {
        _commentsTextfieldController.text = "";
        fetchData();
        if(approveOrReject == 3){
          Commonmethod.alertToShow(Singleton.feedBackIssuIDMessage + " Rejected Successfully.", 'Success', context);
        }else if(approveOrReject == 2) {
          Commonmethod.alertToShow(Singleton.feedBackIssuIDMessage + " Submitted Successfully.", 'Success', context);
        }else if(approveOrReject == 4) {
          Commonmethod.alertToShow(Singleton.feedBackIssuIDMessage + " Assign Successfully.", 'Success', context);
          employee = null;
        }
      }else {
        Commonmethod.alertToShow("Internal server error. Please try again", 'Error', context);
      }
    });
  }

  devCompletedParameters(FeedbackIssues issue, String Comments, int approveOrReject, int DeveloperID) {
    return jsonEncode({
      'UploadAttachmentList': [],
      'EmployeeId': issue.EmployeeId,
      'Id': issue.ID,
      'IssueId': issue.issueID,
      'Status':approveOrReject,
      'Developer':DeveloperID,
      'LeadComments':issue.LeadComments,
      'ReleasenotestableId':issue.ReleasenotestableId.toString() ?? "",
      'AdminComments':Comments,
      'btnAction':1
    });
  }
  devCompleted(String comments, int approveOrReject, FeedbackIssues issue, int DeveloperID){
    Navigator.pop(context);
    setState(() {
      _load = true; //
    });
    submitFeedback(SUBMIT_FEEDBACK, body: devCompletedParameters(issue, comments, approveOrReject, DeveloperID), headers: headers).then((response) {
      setState(() {
        _load = false; //
      });
      if (response) {
        _commentsTextfieldController.text = "";
        fetchData();
        if(approveOrReject == 5){
          Commonmethod.alertToShow(Singleton.feedBackIssuIDMessage + " Saved Successfully.", 'Success', context);
        }
      }else {
        Commonmethod.alertToShow("Internal server error. Please try again", 'Error', context);
      }
    });
  }
  productBacklogTable(List<FeedbackIssues> feedback){
    // filteredProductBL = feedback;
    return Column (
      children: [
        Container(
          color : Colors.lightBlue[100],
          padding: const EdgeInsets.all(2),
          child: Center (
            child: ListTile(
                title: Text("Issue ID -- Module -- Sub Module -- Submitter -- Submitted Date -- Description -- PO Comments", textAlign: TextAlign.center,)),
          ),
        ),
        filteredList(feedback),
      ],
    );
  }

  filteredList(List<FeedbackIssues> feedback){
    return  Expanded(
        child:  SmartRefresher(
          controller: _refreshController,
          enablePullUp: true,
          onRefresh: () async {
            refreshTheDashboard();
          },
          child: (feedback?.length == 0) ? ListTile(
            title: Text("No Records Found",textAlign: TextAlign.center,),) : ListView.builder(itemCount: feedback?.length ?? 0,itemBuilder : (BuildContext context, int index) {
            final Axis slidableDirection = Axis.horizontal;
            return Slidable(
              key: Key('Test'),
              controller: slidableController,
              direction: slidableDirection,
              dismissal: SlidableDismissal(
                child: SlidableDrawerDismissal(),
              ),
              actionPane: SlidableBehindActionPane(),
              actionExtentRatio: 0.25,
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Assign',
                  color: Colors.lightBlueAccent,
                  icon: Icons.archive,
                  onTap: () => assignFeedbackIssue(feedback[index]),
                  closeOnTap: false,
                ),
              ],
              child:   Card(
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: Center (
                    child: ListTile(
                      title: Text((feedback[index].issueString ?? "") + " -- " + (feedback[index].Module ?? "") + " -- " + (feedback[index].subModule ?? "") + " -- " + (feedback[index].createdBy ?? "") + " -- " + (Commonmethod.convertDateToDefaultFomrate(feedback
                      [index].submittedDate) ?? "") + " -- " + (feedback[index].description ?? "") + " -- " + (feedback[index].LeadComments ?? ""), textAlign: TextAlign.center,),
                    ),
                  ),
                ),
              ),
            );

          }),
        )
    );
  }


  underDevTable(List<FeedbackIssues> feedback){
    return Column (
      children: [
        Container(
          color : Colors.lightBlue[100],
          padding: const EdgeInsets.all(2),
          child: Center (
            child: ListTile(
              title: Text("Issue ID -- Submitted Date -- Module -- Sub Module -- Submitter -- Description -- PO Comments -- Developer -- Dev Start Date", textAlign: TextAlign.center,),),
          ),
        ),
        Expanded(
            child:  SmartRefresher(
                controller: _refreshController,
                enablePullUp: true,
                onRefresh: () async {
                  refreshTheDashboard();
                },
                child: (feedback?.length == 0) ? ListView.builder(itemCount: 1,itemBuilder : (BuildContext context, int index) {
                  return Card(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: Center (
                        child: ListTile(
                          title: Text("No Records Found",textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                  );
                },
                ) : ListView.builder(itemCount: feedback?.length ?? 0,itemBuilder : (BuildContext context, int index) {
                  final Axis slidableDirection = Axis.horizontal;
                  return Slidable(
                    key: Key('Test'),
                    controller: slidableController,
                    direction: slidableDirection,
                    dismissal: SlidableDismissal(
                      child: SlidableDrawerDismissal(),
                    ),
                    actionPane: SlidableBehindActionPane(),
                    actionExtentRatio: 0.25,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Product Backlog',
                        color: Colors.lightBlueAccent,
                        icon: Icons.settings_backup_restore,
                        onTap: () =>  submitFeedbackWithChange(feedback[index].LeadComments, 2, feedback[index], feedback[index].Developer, true),

                        closeOnTap: false,
                      ),
                      IconSlideAction(
                        caption: 'Dev Completed',
                        color: Colors.lightBlueAccent,
                        icon: Icons.forward,
                        onTap: () => devCompletedAlert(feedback[index]),
                        closeOnTap: false,
                      ),
                    ],
                    child:   Card(
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        child: Center (
                          child: ListTile(
                            title: Text((feedback[index].issueString ?? "") + " -- " + (Commonmethod.convertDateToDefaultFomrate(feedback
                            [index].submittedDate) ?? "") + " -- " + (feedback[index].Module ?? "") + " -- " + (feedback[index].subModule ?? "") + " -- " + (feedback[index].createdBy ?? "")  + " -- " + (feedback[index].description ?? "") + " -- " + (feedback[index].LeadComments ?? "")
                                + " -- " + (feedback[index].DeveloperName ?? "") + " -- " + (Commonmethod.convertDateToDefaultFomrate(feedback
                            [index].modifiedDate) ?? ""), textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                )
            )
        )
      ],
    );
  }

  underQATable(List<FeedbackIssues> feedback){
    return Column (
      children: [
        Container(
          color : Colors.lightBlue[100],
          padding: const EdgeInsets.all(2),
          child: Center (
            child: ListTile(
              title: Text("Version -- Issue ID -- Release Date -- Module -- Sub Module -- Developer -- User Description  -- PO Comments -- Dev Comment", textAlign: TextAlign.center,),),
          ),
        ),
        Expanded(
            child:  SmartRefresher(
                controller: _refreshController,
                enablePullUp: true,
                onRefresh: () async {
                  refreshTheDashboard();
                },
                child: (feedback?.length == 0) ? ListView.builder(itemCount: 1,itemBuilder : (BuildContext context, int index) {
                  return Card(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: Center (
                        child: ListTile(
                          title: Text("No Records Found",textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                  );
                },
                ) : ListView.builder(itemCount: feedback?.length ?? 0,itemBuilder : (BuildContext context, int index) {
                  final Axis slidableDirection = Axis.horizontal;
                  return Container(
                    child:  Card(
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        child: Center (
                          child: ListTile(
                            title: Text((feedback[index].ReleaseVersion ?? "") + " -- " + (feedback[index].issueString ?? "") + " -- " + (Commonmethod.convertDateToDefaultFomrate(feedback
                            [index].ReleaseDate) ?? "") + " -- " + (feedback[index].Module ?? "") + " -- " + (feedback[index].subModule ?? "") + " -- " + (feedback[index].DeveloperName ?? "")  + " -- " + (feedback[index].description ?? "") + " -- " + (feedback[index].LeadComments ?? "")
                                 + " -- " + ((feedback
                            [index].DevComments) ?? ""), textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                )
            )
        )
      ],
    );
  }

  dashboardTable(List<FeedbackIssues> feedback){
    return Column (
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.all(2),
            child: Center (
              child: ListTile(
                  title: Text("Dashboard", textAlign: TextAlign.center, style: TextStyle(
                    fontWeight: FontWeight.w700, // light
                    fontStyle: FontStyle.normal, // italic
                  ),)),
            ),
          ),
        ),
        Container(
          color : Colors.lightBlue[100],
          padding: const EdgeInsets.all(2),
          child: Center (
            child: ListTile(
                title: Text("Issue ID -- Module -- Sub Module -- Submitted Date -- Description -- Status -- Release Version -- Deployment", textAlign: TextAlign.center,)),
          ),
        ),
        (feedback?.length == 0) ? ListView.builder(shrinkWrap: true, physics: ClampingScrollPhysics(),itemCount: 1,itemBuilder : (BuildContext context, int index) {
          return Card(
            child: Container(
              padding: const EdgeInsets.all(2),
              child: Center (
                child: ListTile(
                  title: Text("No Records Found",textAlign: TextAlign.center,),
                ),
              ),
            ),
          );
        },
        ) : ListView.builder(
            shrinkWrap: true, physics: ClampingScrollPhysics(),itemCount: feedback?.length ?? 0,itemBuilder : (BuildContext context, int index) {
          return Card(
            child: Container(
              padding: const EdgeInsets.all(2),
              child: Center (
                child: ListTile(
                  title: Text((feedback[index].issueString ?? "") + " -- " + (feedback[index].Module ?? "") + " -- " + (feedback[index].subModule ?? "") + " -- " + (Commonmethod.convertDateToDefaultFomrate(feedback
                  [index].submittedDate) ?? "") + " -- " + (feedback[index].description ?? "") + " -- " + (feedback[index].status ?? "") + " -- " + ((feedback[index].releaseVersion  !=  null ? feedback[index].releaseVersion.toString() : "")) + " -- " + (Commonmethod.convertDateToDefaultFomrate(feedback
                  [index].deploymentDate) ?? "") , textAlign: TextAlign.center,),
                ),
              ),
            ),
          );
        })
      ],
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
            var connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.none)  {
              Commonmethod.alertToShow(CONNECTIVITY_ERROR, 'AID', context);
            }{
              _submitFeedBack();
            }
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
            _showPicker(context);
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

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _isButtonDisabled = true;
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _isButtonDisabled = true;
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  uploadDocuments() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx', 'pdf', 'doc'], //allowMultiple: true
    );
    if(result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();

      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      setState(() {
        attachments.add(file);
      });

    } else {
      // User canceled the picker
    }
  }

  get toPostParameters => jsonEncode({
    'UploadAttachmentList': [],
    'EmployeeId': employeeID ?? "",
    'Type': _type ?? "",
    'ModuleName': _MenuModules?.ModuleName ?? "",
    'SubModuleName': _subMenuModules?.ModuleName ?? "",
    'Description': messageTextField.text,
    'Status':1,
    'OtherModule': othersTextField.text ?? "",
    'OtherSubModule':null,
    'Developer':'111111',
    'IssueId':'',
    'ReleasenotestableId':1,
    'FileGuidList': fileGUIDList ?? [],
    'FileNameList':fileNameList ?? [],
    "Count":1
  });

  _submitFeedBack() async{
    setState(() {
      _load = true; //
    });
    if(_image != null) {
      await uploadImage1(File(_image.path),_image.path.split('/').last, headers: headers).then((value) {
        if(value != null) {
          fileNameList = value.item1;
          fileGUIDList = value.item2;
        }
      });
    }
    Singleton.feedBackIssuIDMessage = "";
    if(_type == "" || _type == null)
      return Commonmethod.alertToShow("Please select the Type of issue", 'Warning', context);
    else if(_MenuModules == null) {
      return Commonmethod.alertToShow("Please select the Module Name", 'Warning', context);
    }else if (_MenuModules != null && _MenuModules.ModuleName != 'Others') {
      if (_MenuModules?.subModuleList?.length > 0 &&_subMenuModules == null) {
        return Commonmethod.alertToShow("Please select the sub module name", 'Warning', context);
      }
    }else if(_MenuModules.ModuleName == 'Others' && othersTextField.text.length == 0){
      return Commonmethod.alertToShow("Please enter the others field", 'Warning', context);
    }
    else if (messageTextField.text.length == 0) {
      return Commonmethod.alertToShow("Please enter the description", 'Warning', context);
    }

    submitFeedback(SUBMIT_FEEDBACK, body: toPostParameters, headers: headers).then((response) {
      setState(() {
        _load = false; //
      });
      if (response) {
        _type = null;
        _subMenuModules = null;
        _MenuModules = null;
        messageTextField.text = '';
        othersTextField.text = '';
        _image = null;
        fetchData();
        Commonmethod.alertToShow(Singleton.feedBackIssuIDMessage + " Submitted Successfully.", 'Success', context);

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


