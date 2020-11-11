import 'dart:convert';

import 'package:aid/Trainings/TrainingModel.dart';
import 'package:http/http.dart' as http;


Future<ClientTrainingDashboard> getClientTrainingDashboardDetailsAPI(bool filter, String url, {Map headers}) async {

  if(filter) {
    return http.get(url, headers: headers).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 400 || json == null) {
        return ClientTrainingDashboard(errorObj: Error(response.reasonPhrase, response.statusCode));
        throw new Exception("Error while fetching data");
      }
      return ClientTrainingDashboard.filteredJSON(json.decode(response.body));
    });
  }

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return ClientTrainingDashboard(errorObj: Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    return ClientTrainingDashboard.fromJson(json.decode(response.body));
  });
}

Future<MyTrainingDashboard> getMyTrainingDashboardDetailsAPI(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return MyTrainingDashboard(errorObj: Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    return MyTrainingDashboard.fromJson(json.decode(response.body));
  });
}

