
import 'package:aid/Survey/SurveyModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:tuple/tuple.dart';


Future<SurveyModel> getSurveyDetails(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return SurveyModel(errorObj: Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    return SurveyModel.fromJson(json.decode(response.body));
  });
}


Future<Tuple2<List<SurveyList>, Error>> getSurveyListDetails(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {

      return Tuple2([],Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    List<dynamic> surveyListData = getData["data"]["surveyList"];
    List<SurveyList> surveyList = List();
    surveyListData.forEach((element) {
      String imagePath = 'Assets/Survey/COVID19.png';
      if(element['surveyName'] == "Cab Survey"){
        imagePath = 'Assets/Survey/CabSurvey.png';
      }else if(element['surveyName'] == "Work Location"){
        imagePath = 'Assets/Survey/WorkLocationImage.png';
      }
      surveyList.add(SurveyList(surveyID:element['surveyID'] , surveyDetailsID:element['surveyDetailsID'] , surveyName:element['surveyName'] , surveyDesc:element['surveyDesc'] , surveyStartDate: element['surveyStartDate'], surveyEndDate:element['surveyEndDate'] , surveyStatusID:element['surveyStatusID'] , surveyStatusName:element['surveyStatusName'] , CompletedOn: element['CompletedOn'], imageName: imagePath));
    });

    return Tuple2(surveyList, null);
  });
}

Future<Tuple3<List<SurveyCabDashboard>,List<LocationData>, Error>> getCabSurveyDashboardDetails(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {

      return Tuple3([],[],Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    List<dynamic> cabSurveyTable1 = getData["data"]["CabSurveyNotCompletedList"];
    List<SurveyCabDashboard> surveyList = List();
    cabSurveyTable1.forEach((element) {
      surveyList.add(SurveyCabDashboard(Count: element['Count'],CompletedCount: element['CompletedCount'], startdate: element['startdate'], Enddate: element['Enddate'],
          NotCompletedCount: element['NotCompletedCount'], ConcernRaised: element['ConcernRaised'], Totalresource: element['Totalresource'], Leadname: element['Leadname']));
    });
    List<dynamic> cabSurveyTable2 = getData["locationdata"];
    List<LocationData> locationdata = List();
    cabSurveyTable2.forEach((element) {
      locationdata.add(LocationData(location: element['location'], TotalResources: element['TotalResources'], ConcernsRaised:element['ConcernsRaised'],
      NonCabusers: element['NonCabusers'],Cabusersnotraisedconcerns: element['Cabusersnotraisedconcerns']));
    });

    return Tuple3(surveyList,locationdata, null);
  });
}

Future<Tuple2<List<WorkLocationDashboard>, Error>> getWorkLocationSurveyDashboardDetails(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {

      return Tuple2([],Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    List<dynamic> answersList = getData["data"]["answersList"];
    List<WorkLocationDashboard> workDashboard = List();
    answersList.forEach((element) {
      List<dynamic> answerCount = element["answerCount"];
      List<WorkLocationAnswers> workLocationAnswers = List();
      answerCount.forEach((element1) {
        workLocationAnswers.add(WorkLocationAnswers(ActualCityName: element1['ActualCityName'], actualCount:element1['actualCount'] , PreferredCity: element1['PreferredCity'], preferredCount: element1['preferredCount'],));
      });
      workDashboard.add(WorkLocationDashboard(question: element['question'],answerCount: workLocationAnswers));
    });

    return Tuple2(workDashboard, null);
  });
}

Future<Tuple2<List<SurveyCabDashboard>, Error>> getWorkLocationSurveyStatisticDashboard(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {

      return Tuple2([],Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    List<dynamic> cabSurveyTable1 = getData["data"]["SurveyNotCompletedList"];
    List<SurveyCabDashboard> surveyList = List();
    cabSurveyTable1.forEach((element) {
      surveyList.add(SurveyCabDashboard(Count: element['Count'],CompletedCount: element['CompletedCount'], startdate: element['startdate'], Enddate: element['Enddate'],
          NotCompletedCount: element['NotCompletedCount'], ConcernRaised: element['ConcernRaised'], Totalresource: element['Totalresource'], Leadname: element['Leadname']));
    });

    return Tuple2(surveyList, null);
  });
}
