
import 'package:aid/CommonMethods.dart';
import 'package:aid/FeedBack/FeedbackAPI.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:tuple/tuple.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';

import '../constants.dart';

Future<Tuple2<FeedBack, Error>> getFeedbackModules(String url, {Map headers}) async {

  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {

      return Tuple2(FeedBack(),Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    List<dynamic> modules = getData["data"]["Modulelist"];
    List<dynamic> subModules = getData["data"]["SubModulelist"];

    List<ModuleList> menuModules = [];
    List<ModuleList> subMenuModules = [];
    modules.forEach((element) {
     List<dynamic> subModulesMenu = subModules.where((item) => item["SubmenuId"] == element["Id"] ).toList();
     List<ModuleList> subMenuModules = [];
     subModulesMenu.forEach((element1) {
       subMenuModules.add(ModuleList(id: element1['SubmenuId'],ModuleName: element1['SubModuleName']));
     });
     menuModules.add(ModuleList(id: element['Id'],ModuleName: element['ModuleName'],subModuleList: subMenuModules));
    });


    return Tuple2(FeedBack(Modules: menuModules,), null);
  });
}

Future<Tuple2<List<FeedbackIssues>, Error>> getFeedBackEvaluation(String url, {Map headers}) async {
  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return Tuple2(List(),Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    List<dynamic> productBackLog = getData["data"]["SubmittedList"];

    List<FeedbackIssues> tickets = [];
    productBackLog.forEach((element) {

      tickets.add(FeedbackIssues(ID: element['Id'], issueID: element['IssueId'],issueString: element['IssueString'], EmployeeId: element['EmployeeId'], Module: element['ModuleName'], subModule: element['SubModuleName'], createdBy: element['CreatedBy'],submittedDate: element['CreatedDate'],description: element['Description'],LeadComments: element['LeadComments'], ReleasenotestableId: element['ReleasenotestableId'], Developer: element['Developer']));
    });
    return Tuple2(tickets, null);
  });
}

Future<Tuple2<List<Developers>, Error>> getEmployeesList(String url, {Map headers}) async {
  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return Tuple2(List(),Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    List<dynamic> productBackLog = getData["data"]["Employeelist"];

    List<Developers> employees = [];
    productBackLog.forEach((element) {

      employees.add(Developers(Employeeid: element['Employeeid'], EmployeeName: element['EmployeeName']));
    });
    return Tuple2(employees, null);
  });
}

Future<Tuple4<List<FeedbackIssues>,List<FeedbackIssues>,List<FeedbackIssues>, Error>> getProductBackLog(String url, {Map headers}) async {
  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return Tuple4(List(),List(),List(),Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    List<dynamic> productBackLog = getData["data"]; // ProductBacklog
    List<dynamic> underDev = getData['data2']; //  under Dev
    List<dynamic> underQA = getData['data1']; // underQA

    List<FeedbackIssues> tickets = [];
    List<FeedbackIssues> tickets1 = [];
    List<FeedbackIssues> tickets2 = [];
    productBackLog.forEach((element) {
      tickets.add(FeedbackIssues(ID: element['Id'] , issueID: element['IssueId'],issueString: element['IssueString'],Module: element['ModuleName'], subModule: element['SubModuleName'], createdBy: element['CreatedBy'],submittedDate: element['CreatedDate'],description: element['Description'], LeadComments: element['LeadComments'],
      DeveloperName: element['DeveloperName'], modifiedDate: element['ModifiedDate'], ReleasenotestableId: element['ReleasenotestableId'], EmployeeId: element['EmployeeId'], Developer: element['Developer']));
    });
    underDev.forEach((element) {
      tickets1.add(FeedbackIssues(ID: element['Id'] , issueID: element['IssueId'],issueString: element['IssueString'],Module: element['ModuleName'], subModule: element['SubModuleName'], createdBy: element['CreatedBy'],submittedDate: element['CreatedDate'],description: element['Description'], LeadComments: element['LeadComments'],
          DeveloperName: element['DeveloperName'], modifiedDate: element['ModifiedDate'], ReleasenotestableId: element['ReleasenotestableId'], EmployeeId: element['EmployeeId'], Developer: element['Developer']));
    });
    underQA.forEach((element) {
      tickets2.add(FeedbackIssues(ID: element['Id'] , issueID: element['IssueId'],issueString: element['IssueString'],Module: element['ModuleName'], subModule: element['SubModuleName'], createdBy: element['CreatedBy'],submittedDate: element['CreatedDate'],description: element['Description'], LeadComments: element['LeadComments'],
          DeveloperName: element['DeveloperName'], modifiedDate: element['ModifiedDate'], ReleasenotestableId: element['ReleasenotestableId'], EmployeeId: element['EmployeeId'], Developer: element['Developer']));
    });
    return Tuple4(tickets,tickets1,tickets2, null);
  });
}


Future<Tuple2<List<FeedbackIssues>, Error>> getReleaseNoteDetails(String url, {Map headers}) async {
  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return Tuple2(List(),Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    Map<String, dynamic> pendingList = getData["pendingList"]; // underQA
    List<FeedbackIssues> tickets = [];
    Iterable<String> listKeys = pendingList.keys;

    listKeys.forEach((element1) {
      List<dynamic> QA = pendingList[element1.toString()];
      QA.forEach((element){
        tickets.add(FeedbackIssues(ID: element['Id'],  issueID: element['IssueId'],issueString: element['IssueString'],Module: element['ModuleName'], subModule: element['SubModuleName'], createdBy: element['CreatedBy'],submittedDate: element['CreatedDate'],description: element['Description'], LeadComments: element['LeadComments'],
             modifiedDate: element['ModifiedDate'], ReleasenotestableId: element['ReleasenotestableId'], EmployeeId: element['EmployeeId'], DeveloperName: element['Developer'],ReleaseVersion: element1,DevComments: element['ChangesDone'] ,ReleaseDate: element['ReleaseDate']));
      });

    });


    return Tuple2(tickets, null);
  });
}

Future<Tuple2<List<FeedbackIssues>, Error>> getDashboardDetails(String url, {Map headers}) async {
  return http.get(url, headers: headers).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return Tuple2(List(),Error(response.reasonPhrase, response.statusCode));
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    List<dynamic> productBackLog = getData["data"]["DashboardList"]; // ProductBacklog

    List<FeedbackIssues> tickets = [];
    productBackLog.forEach((element) {
      tickets.add(FeedbackIssues(ID: element['Id'] , issueID: element['IssueId'],issueString: element['IssueString'],Module: element['ModuleName'], subModule: element['SubModuleName'], createdBy: element['CreatedBy'],submittedDate: element['CreatedDate'],description: element['Description'], LeadComments: element['LeadComments'],
          DeveloperName: element['DeveloperName'], modifiedDate: element['ModifiedDate'], releaseVersion: element['ReleaseVersion'], deploymentDate: element['DeploymentDate'], status: element['StatusName'], ReleasenotestableId: element['ReleasenotestableId'], EmployeeId: element['EmployeeId']));
    });
    return Tuple2(tickets, null);
  });
}

Future<bool> submitFeedback(url, {Map<String, String> headers, body, Encoding encoding}) async {
  return http.post(url, body: body, headers: headers).then((
      http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return false;
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    Singleton.feedBackIssuIDMessage = getData['issueid'] ?? "" + "submitted successfully.";
    return true;
  });
}

 Future<Tuple2<List<dynamic>, List<dynamic>>> uploadImage1(File _file, String _FileName, {Map headers}) async {

  // open a byteStream
  var stream = new http.ByteStream(DelegatingStream.typed(_file.openRead()));
  // get file length
  var length = await _file.length();

  // string to uri
  var uri = Uri.parse(FEEDBACK_ATTACHMENT);

  // create multipart request
  var request = new http.MultipartRequest("POST", uri);

  // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
  // request.fields["filename"] = 'Testing.docx';
  request.fields["name"] = "_User";

  // multipart that takes file.. here this "image_file" is a key of the API request
  var multipartFile = new http.MultipartFile(_FileName, stream, length, filename: basename(_file.path));
  //add headers
  request.headers.addAll(headers);

  // add file to multipart
  request.files.add(multipartFile);

  String fileGUID = '';
  // send request to upload image
  List<dynamic> fileGUIDList;
  List<dynamic> fileNameList;
  await request.send().then((response) async {
    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      Map<String, dynamic> fileResponse = jsonDecode(value);
      fileGUIDList = fileResponse['data']['FileGuidList'];
      fileNameList = fileResponse['data']['FileNameList'];
    });

  }).catchError((e) {
    print(e);
  });

  return Tuple2(fileNameList, fileGUIDList);
}