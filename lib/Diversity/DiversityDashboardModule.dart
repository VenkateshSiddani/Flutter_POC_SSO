

import 'dart:ffi';

class DiversityDashboardModule {
  Map<String, dynamic> data ;

  final List<dynamic> leadWiseList;
  final List<dynamic> countryWiseList;
  final List<dynamic> gradeWiseList;
  final List<dynamic> deptWiseList;
  final Error errorObj;

  DiversityDashboardModule({ this.data, this.leadWiseList, this.countryWiseList, this.deptWiseList, this.gradeWiseList, this.errorObj});

  factory DiversityDashboardModule.fromJson(Map<String, dynamic> json) {

    final List<dynamic> leadWiseList1 = json['data']['diversityleadwiselist'];
    final List<dynamic> countryWiseList1 = json['data']['diversitycountrywiselist'];
    final List<dynamic> gradeWiseList1 = json['data']['diversitygradewiselist'];
    final List<dynamic> deptWiseList1 = json['data']['diversitydepwiselist'];

    return DiversityDashboardModule(
      data: json['data'],
      leadWiseList: leadWiseList1,
      countryWiseList: countryWiseList1,
      gradeWiseList: gradeWiseList1,
      deptWiseList: deptWiseList1,
    );
  }
}

class DiversityImageModule {
  List<dynamic> data ;
  // final List<dynamic> imagesURLList;

  final Error errorObj;
  DiversityImageModule({ this.data,this.errorObj});
  factory DiversityImageModule.fromJson(Map<String, dynamic> json) {
    return DiversityImageModule(
      data: json['data'],
    );
  }
}

class DiversitySubModuleData{
   String name;
   double diversityPercentage;
   DiversitySubModuleData({ this.name, this.diversityPercentage});
}

class DiversityImageModuleData{
  int resourceid;
  String resourcename;
  String Image;
  DiversityImageModuleData({ this.resourceid, this.resourcename, this.Image});
}


class Error {
  String ErrorDesc;
  int ErrorCode;
  Error(this.ErrorDesc, this.ErrorCode);
}