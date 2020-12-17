
import 'package:aid/FeedBack/FeedbackAPI.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:tuple/tuple.dart';
import 'package:aid/FeedBack/FeedbackModel.dart';


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

Future<bool> submitFeedback(url, {Map<String, String> headers, body, Encoding encoding}) async {
  return http.post(url, body: body, headers: headers).then((
      http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return false;
    }
    Map<String, dynamic> getData = json.decode(response.body) ;
    return true;
  });
}