
import 'package:aid/Milestone/MilestoneModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


Future<MileStone> getCalendarEventDetails(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return MileStone(errorObj: Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    return MileStone.fromJson(json.decode(response.body));
  });
}

Future<MyMileStone> getMyMilestoneDetails(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return MyMileStone(errorObj: Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    return MyMileStone.fromJson(json.decode(response.body));
  });
}

Future<bool> isExcludedWish(url, {Map<String, String> headers, body, Encoding encoding}) async {

  return http.post(url, body: body, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return false;
    }
    Map<String, dynamic> responseData = json.decode(response.body);
    if(responseData['data'] == 'Success'){
      return true;
    }else{
      return false;
    }
  });
}
Future<bool> sendWishes(url, {Map<String, String> headers, body, Encoding encoding}) async {
  return http.post(url, body: body, headers: headers).then((
      http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return false;
    }
    Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData['data'] != null) {
      return true;
    } else {
      return false;
    }
  });
}