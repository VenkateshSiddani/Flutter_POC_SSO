

import 'package:flutter/cupertino.dart';

class VoicesOfAnAbbottian {
  String FromName;
  String ToName;
  String SubmissionType;
  String SubmittedDate;
  String Message;
  bool IsAnonymous;
  List<VoiceOfAbbottianToList> toList;

  VoicesOfAnAbbottian({this.FromName, this.ToName, this.SubmissionType, this.SubmittedDate, this.Message, this.IsAnonymous, this.toList});



}
class Voices {

  List<VoicesOfAnAbbottian> myVoices;
  List<VoicesOfAnAbbottian> otherVoices;
  List<VoicesOfAnAbbottian> allVoices;

  Voices({this.myVoices, this.otherVoices, this.allVoices});
}

class VoiceOfAbbottianToList{

  String ToName;
  String ToImage;
  VoiceOfAbbottianToList({this.ToName, this.ToImage});
}


class Employee {

  int empID;
  String empName;
  String empIMG;

  Employee({this.empID, this.empIMG, this.empName});

  get toJson => null;
}
class Voice {
  final String FromId;
  final String FromName;
  final String SubmissionType;
  final String Message;
  final Map<String, dynamic> json;
  Voice(
      {this.FromId, this.FromName, this.SubmissionType, this.Message, this.json,});
  factory Voice.fromJson(Map<String, dynamic> json) {
    return Voice(
        FromId: json['FromId'],
        FromName: json['FromName'],
        SubmissionType: json['SubmissionType'],
        Message: json['Message'],
        json: json

    );
  }
}