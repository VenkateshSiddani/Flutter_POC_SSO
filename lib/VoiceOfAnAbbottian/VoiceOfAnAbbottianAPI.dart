


import 'package:aid/Survey/SurveyModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:tuple/tuple.dart';
import 'package:aid/VoiceOfAnAbbottian/VoiceModel.dart';

Future<Tuple2<Voices, Error>> getVoiceOfAbbottian(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {

      return Tuple2(Voices(),Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    List<dynamic> myVoices = getData["data"]["MyVoices"];
    List<dynamic> otherVoices = getData["data"]["OtherVoices"];
    List<dynamic> allVoices = getData["data"]["AllVoices"];


    List<VoicesOfAnAbbottian> myVoicesModel = [];
    List<VoicesOfAnAbbottian> otherVoicesModel = [];
    List<VoicesOfAnAbbottian> allVoicesModel = [];

    myVoices.forEach((element) {
      List<dynamic> toList = element["VoiceOfAbbottianToList"];
      List<VoiceOfAbbottianToList> toListModel = [];
      String ToName = "";
      toList.forEach((to) {
        if(ToName.length > 0) {
          ToName += "\n${to["ToName"]}";
        }else {
          ToName += "${to["ToName"]}";
        }

        toListModel.add(VoiceOfAbbottianToList(ToName: to["ToName"],ToImage: to["ToImage"]));
      });
      myVoicesModel.add(VoicesOfAnAbbottian(FromName: element["FromName"],ToName:ToName,SubmissionType:element["SubmissionType"] , SubmittedDate:element["SubmittedDate"] , Message:element["Message"] , IsAnonymous: element["IsAnonymous"],toList: toListModel));
    });
    otherVoices.forEach((element) {
      List<dynamic> toList = element["VoiceOfAbbottianToList"];
      List<VoiceOfAbbottianToList> toListModel = [];
      String ToName = "";
      toList.forEach((to) {
        if(ToName.length > 0) {
          ToName += "\n${to["ToName"]}";
        }else {
          ToName += "${to["ToName"]}";
        }
        toListModel.add(VoiceOfAbbottianToList(ToName: to["ToName"],ToImage: to["ToImage"]));
      });
      otherVoicesModel.add(VoicesOfAnAbbottian(FromName: element["FromName"],ToName:ToName ,SubmissionType:element["SubmissionType"] , SubmittedDate:element["SubmittedDate"] , Message:element["Message"] , IsAnonymous: element["IsAnonymous"],toList: toListModel));
    });
    allVoices.forEach((element) {
      List<dynamic> toList = element["VoiceOfAbbottianToList"];
      List<VoiceOfAbbottianToList> toListModel = [];
      String ToName = "";
      toList.forEach((to) {
        if(ToName.length > 0) {
          ToName += "\n${to["ToName"]}";
        }else {
          ToName += "${to["ToName"]}";
        }
        toListModel.add(VoiceOfAbbottianToList(ToName: to["ToName"],ToImage: to["ToImage"]));
      });

      allVoicesModel.add(VoicesOfAnAbbottian(FromName: element["FromName"],ToName:ToName ,SubmissionType:element["SubmissionType"] , SubmittedDate:element["SubmittedDate"] , Message:element["Message"] , IsAnonymous: element["IsAnonymous"],toList: toListModel));
    });

    return Tuple2(Voices(myVoices: myVoicesModel, otherVoices: otherVoicesModel, allVoices: allVoicesModel), null);
  });
}

Future<Tuple2<List<Employee>, Error>> getAllEmployees(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {

      return Tuple2(List<Employee>(),Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    List<dynamic> employees = getData["EmployeeList"];
    List<Employee> myEmployeeModel = [];

    employees.forEach((element) {

      myEmployeeModel.add(Employee(empID: element["empID"],empIMG: element["empIMG"], empName: element["empName"]));
    });

    return Tuple2(myEmployeeModel, null);
  });
}
Future<bool> submitVoiceAPI(url, {Map<String, String> headers, body, Encoding encoding}) async {
  return http.post(url, body: body, headers: headers).then((
      http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return false;
    }
    return true;
  });
}
