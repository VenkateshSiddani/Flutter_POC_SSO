

class LeadDefaulters{

  Map<String, dynamic> data ;
 int Employeeid;
 String EmployeeName;
 String LeadName;
 int TotalAssociatesCount;
 int DefaulterCount; 
 int TrainingCount; 
 List<DefalterEmployee> EmployeeList;
 // int EmployeeList
 // int courselist : null
 int TotalEscalationcount; 
 int TotalCount;
 int RedCount; 
 int AmberCount;
 int GreenCount;
 int TotalDefaulterCount; 
 int FRemainderCount;
 int TRemainderCount; 
 int RedCountDisplay; 
 int AmberCountDisplay;
 int GreenCountDisplay;

 LeadDefaulters({this.Employeeid, this.EmployeeName, this.LeadName, this.TotalAssociatesCount, this.DefaulterCount, this.TrainingCount, this.TotalEscalationcount, 
 this.TotalCount, this.RedCount, this.AmberCount, this.GreenCount, this.TotalDefaulterCount, this.FRemainderCount, this.TRemainderCount, this.RedCountDisplay,
 this.AmberCountDisplay, this.GreenCountDisplay, this.data, this.EmployeeList});

}

class ClientTrainingDashboard{

  final Map<String, dynamic> data ;
  final List<dynamic> filterData ;
  final int Employeeid;
  final String EmployeeName;
  final String LeadName;
  final int TotalAssociatesCount;
  final int DefaulterCount;
  final int TrainingCount;
  final List<dynamic> Leadlist;
  // int EmployeeList
  // int courselist : null
  final int TotalEscalationcount;
  final int TotalCount;
  final int RedCount;
  final int AmberCount;
  final int GreenCount;
  final int TotalDefaulterCount;
  final int FRemainderCount;
  final int TRemainderCount;
  final int RedCountDisplay;
  final int AmberCountDisplay;
  final int GreenCountDisplay;
  final Error errorObj;

  ClientTrainingDashboard({this.Employeeid, this.EmployeeName, this.LeadName, this.TotalAssociatesCount, this.DefaulterCount, this.TrainingCount, this.TotalEscalationcount,
    this.TotalCount, this.RedCount, this.AmberCount, this.GreenCount, this.TotalDefaulterCount, this.FRemainderCount, this.TRemainderCount, this.RedCountDisplay,
    this.AmberCountDisplay, this.GreenCountDisplay, this.data, this.Leadlist, this.errorObj, this.filterData});

  factory ClientTrainingDashboard.fromJson(Map<String, dynamic> json) {
    return ClientTrainingDashboard(
        data: json['data'] ,
        Leadlist: json['data']['Leadlist'],
        TotalCount:json['data']['TotalCount'],
        TotalEscalationcount: json['data']['TotalEscalationcount'],
      TotalDefaulterCount: json['data']['TotalDefaulterCount'],
      RedCount: json['data']['RedCount'],
        AmberCountDisplay: json['data']['AmberCountDisplay'],
        GreenCountDisplay: json['data']['GreenCountDisplay'],
        AmberCount: json['data']['AmberCount'],
        GreenCount:json['data']['GreenCount'],
    );
  }

  factory ClientTrainingDashboard.filteredJSON(Map<String, dynamic> json) {
    return ClientTrainingDashboard(
      filterData: json['data'] ,
    );
  }
  factory ClientTrainingDashboard.filteredJSONForSecondaryLead(Map<String, dynamic> json) {
    return ClientTrainingDashboard(
      data: json['data'] ,
    );
  }
}


class Error {
  String ErrorDesc;
  int ErrorCode;
  Error(this.ErrorDesc, this.ErrorCode);
}

class MyTrainingDashboard {
  final Map<String, dynamic> data ;
  final List<CoursesList> ISOReport;
  final List<CoursesList> ITILCourses;
  final List<CoursesList> ADMCourses;
  final List<CoursesList> AccountCourses;

  final Error errorObj;

  MyTrainingDashboard({this.ISOReport, this.data, this.errorObj, this.ITILCourses, this.ADMCourses, this.AccountCourses});
  factory MyTrainingDashboard.fromJson(Map<String, dynamic> json) {
    return MyTrainingDashboard(
      data: json['data'],
    );
  }

}

class DefalterEmployee{
  int Employeeid;
  String EmployeeName;
  int TotalCourses;
  List <Courses> courseslist;
  String Grade;
  String Department;
  String City;
  String Country;
  String AssocCategory1;
  String AssocCategory2;
  String AssocCategory3;
  int TotalAssociatesCount;
  int DefaulterCount;
  int TrainingCount;
  int TotalEscalationcount;
  int TotalCount;
  int RedCount;
  int AmberCount;
  int GreenCount;
  int TotalDefaulterCount;
  int FRemainderCount;
  int TRemainderCount;
  int RedCountDisplay;
  int AmberCountDisplay;
  int GreenCountDisplay;
  // Image : "https://aid.cognizant.com/assets/img/profile/"
  // BCPcritical : true
  DefalterEmployee({this.Employeeid, this.EmployeeName, this.Grade, this.Department, this.City, this.Country, this.TotalCourses, this.courseslist, this.TotalAssociatesCount,
  this.DefaulterCount,this.TrainingCount, this.TotalEscalationcount,this.TotalCount,this.RedCount,this.AmberCount, this.GreenCount,this.TotalDefaulterCount,
  this.FRemainderCount,this.TRemainderCount,this.RedCountDisplay, this.AmberCountDisplay,this.GreenCountDisplay});
}

class Courses{
  String CourseCode;
  String CourseName;
  String DueDate;
  int Aging;
  // "ModuleCode": "EPDDV-DARIUS-M00001",
  // "defaultercnt": 0,
  // "Remainder": null,
  // "Secleaddefaultercnt": 0
  Courses({this.CourseCode, this.CourseName, this.DueDate, this.Aging,});

}
class CoursesList {
  // Id : 0
 String CourseCode;
 String CourseName; // : "Scanned Document Management for BTS SLC Deliverables"
 String  DueDate; // : "2019-06-02T00:00:00"
 String  Status; //: "Completed"
 String CompletedDate; // : "2019-05-08T00:00:00"
 int Aging; // : 0
  // ModuleCode : "BTS-M01950"
  // Employeeid : 773777
  // AssignmentDate : "2019-05-03T00:00:00"
  // InjectStatus : 0
  // ModifiedDate : null

 CoursesList({this.DueDate, this.Aging, this.CourseName, this.CourseCode, this.CompletedDate, this.Status});
}
//
// class ITILCourses {
//   // Id : 0
//   String CourseCode;
//   String CourseName; // : "Scanned Document Management for BTS SLC Deliverables"
//   String  DueDate; // : "2019-06-02T00:00:00"
//   String  Status; //: "Completed"
//   String CompletedDate; // : "2019-05-08T00:00:00"
//   int Aging; // : 0
//   // ModuleCode : "BTS-M01950"
//   // Employeeid : 773777
//   // AssignmentDate : "2019-05-03T00:00:00"
//   // InjectStatus : 0
//   // ModifiedDate : null
//
//   ITILCourses({this.DueDate, this.Aging, this.CourseName, this.CourseCode, this.CompletedDate, this.Status});
// }
// class AccountCourses {
//   // Id : 0
//   String CourseCode;
//   String CourseName; // : "Scanned Document Management for BTS SLC Deliverables"
//   String  DueDate; // : "2019-06-02T00:00:00"
//   String  Status; //: "Completed"
//   String CompletedDate; // : "2019-05-08T00:00:00"
//   int Aging; // : 0
//   // ModuleCode : "BTS-M01950"
//   // Employeeid : 773777
//   // AssignmentDate : "2019-05-03T00:00:00"
//   // InjectStatus : 0
//   // ModifiedDate : null
//
//   AccountCourses({this.DueDate, this.Aging, this.CourseName, this.CourseCode, this.CompletedDate, this.Status});
// }
// class ADMCourses {
//   // Id : 0
//   String CourseCode;
//   String CourseName; // : "Scanned Document Management for BTS SLC Deliverables"
//   String  DueDate; // : "2019-06-02T00:00:00"
//   String  Status; //: "Completed"
//   String CompletedDate; // : "2019-05-08T00:00:00"
//   int Aging; // : 0
//   // ModuleCode : "BTS-M01950"
//   // Employeeid : 773777
//   // AssignmentDate : "2019-05-03T00:00:00"
//   // InjectStatus : 0
//   // ModifiedDate : null
//
//   ADMCourses({this.DueDate, this.Aging, this.CourseName, this.CourseCode, this.CompletedDate, this.Status});
// }