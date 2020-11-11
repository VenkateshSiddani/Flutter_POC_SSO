import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';


class CovidDashboard extends StatefulWidget {
  CovidDashboard({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CovidDashboardState createState() => _CovidDashboardState();
}

class _CovidDashboardState extends State<CovidDashboard> {
  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;

  @override
  void initState() {
    user.initData(100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 100,
        rightHandSideColumnWidth: 1500,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: user.userInfo.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
      ),
      height: MediaQuery
          .of(context)
          .size
          .height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Lead Name', 200),
      _getTitleItemWidget('Total Associates', 100),
      _getTitleItemWidget('AID Enabled Associates', 100),
      _getTitleItemWidget1('jhfa',800),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 100,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400])
      ),
    );
  }

  Widget _getTitleItemWidget1(String label, double width) {
    // return Container(
    //   child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
    //   width: width,
    //   height: 56,
    //   padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
    //   alignment: Alignment.centerLeft,
    // );
    return Container(
      height: 101,
      width: 406,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400])
      ),
      // margin: const EdgeInsets.all(1.0),
      // decoration: BoxDecoration(
      //     border: Border.all(color: Colors.grey[400])
      // ),
      child: Column(
        children: <Widget>[
          Container(
            child: Text('25-09-2020', style: TextStyle(fontWeight: FontWeight.bold)),
            width: 404,
            height: 39,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
          ),
          Divider(color: Colors.grey[400],
            height: 1,
            thickness: 1,
            indent: 0,
            endIndent: 0,),
          Container(
            child: IntrinsicHeight(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Text('Associate Healthy', style: TextStyle(fontWeight: FontWeight.bold)),
                    width: 100,
                    height: 59,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.grey[400],
                  ),
                  Container(
                    child: Text('Abbott Connectivity Successful', style: TextStyle(fontWeight: FontWeight.bold)),
                    width: 100,
                    height: 59,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.grey[400],
                  ),
                  Container(
                    child: Text('Un healthy/Not able to connect', style: TextStyle(fontWeight: FontWeight.bold)),
                    width: 100,
                    height: 59,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.grey[400],
                  ),
                  Container(
                    child: Text('Not Participated', style: TextStyle(fontWeight: FontWeight.bold)),
                    width: 100,
                    height: 59,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                  ),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Container(
            //       child: Text('Associate Healthy', style: TextStyle(fontWeight: FontWeight.bold)),
            //       width: 200,
            //       height: 40,
            //       padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            //       alignment: Alignment.centerLeft,
            //     ),
            //     VerticalDivider(
            //       width: 1,
            //       thickness: 1,
            //       indent: 0,
            //       endIndent: 0,
            //       color: Colors.red,
            //     ),
            //     Container(
            //       child: Text('Abbott Connectivity Successful', style: TextStyle(fontWeight: FontWeight.bold)),
            //       width: 200,
            //       height: 40,
            //       padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            //       alignment: Alignment.centerLeft,
            //     ),
            //     Container(
            //       child: Text('Un healthy/Not able to connect', style: TextStyle(fontWeight: FontWeight.bold)),
            //       width: 200,
            //       height: 40,
            //       padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            //       alignment: Alignment.centerLeft,
            //     ),
            //     Container(
            //       child: Text('Not Participated', style: TextStyle(fontWeight: FontWeight.bold)),
            //       width: 200,
            //       height: 40,
            //       padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            //       alignment: Alignment.centerLeft,
            //     ),
            //     // Text('Associate Healthy', maxLines: 2, style: TextStyle(fontWeight: FontWeight.bold)),
            //     // Text('Abbott Connectivity Successful', style: TextStyle(fontWeight: FontWeight.bold)),
            //     // Text('Un healthy/Not able to connect', style: TextStyle(fontWeight: FontWeight.bold)),
            //     // Text('Not Participated', style: TextStyle(fontWeight: FontWeight.bold)),
            //   ],
            // ),
          )
        ],
      ),
    );
  }
  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(user.userInfo[index].name),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Icon(
                  user.userInfo[index].status
                      ? Icons.notifications_off
                      : Icons.notifications_active,
                  color: user.userInfo[index].status ? Colors.red : Colors
                      .green),
              Text(user.userInfo[index].status ? 'Disabled' : 'Active')
            ],
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user.userInfo[index].phone),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user.userInfo[index].registerDate),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user.userInfo[index].terminationDate),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}

User user = User();

class User {
  List<UserInfo> _userInfo = List<UserInfo>();

  void initData(int size) {
    for (int i = 0; i < size; i++) {
      _userInfo.add(UserInfo(
          "User_$i", i % 3 == 0, '+001 9999 9999', '2019-01-01', 'N/A'));
    }
  }

  List<UserInfo> get userInfo => _userInfo;

  set userInfo(List<UserInfo> value) {
    _userInfo = value;
  }

  ///
  /// Single sort, sort Name's id
  void sortName(bool isAscending) {
    _userInfo.sort((a, b) {
      int aId = int.tryParse(a.name.replaceFirst('User_', ''));
      int bId = int.tryParse(b.name.replaceFirst('User_', ''));
      return (aId - bId) * (isAscending ? 1 : -1);
    });
  }

  ///
  /// sort with Status and Name as the 2nd Sort
  void sortStatus(bool isAscending) {
    _userInfo.sort((a, b) {
      if (a.status == b.status) {
        int aId = int.tryParse(a.name.replaceFirst('User_', ''));
        int bId = int.tryParse(b.name.replaceFirst('User_', ''));
        return (aId - bId);
      } else if (a.status) {
        return isAscending ? 1 : -1;
      } else {
        return isAscending ? -1 : 1;
      }
    });
  }
}

class UserInfo {
  String name;
  bool status;
  String phone;
  String registerDate;
  String terminationDate;

  UserInfo(this.name, this.status, this.phone, this.registerDate,
      this.terminationDate);
}