
import 'dart:ffi';

class FeedBack {

  List<ModuleList> Modules;
  FeedBack({this.Modules});

}

class ModuleList{
  int id;
  String ModuleName;
  List<ModuleList> subModuleList;
  ModuleList({this.id,this.ModuleName, this.subModuleList});
}
class Error {
  String ErrorDesc;
  int ErrorCode;
  Error(this.ErrorDesc, this.ErrorCode);
}

class FeedbackIssues{
  int ID;
  int issueID;
  String issueString;
  String Module;
  String subModule;
  String createdBy;
  String submittedDate;
  String description;
  String LeadComments;
  String DeveloperName;
  String modifiedDate;
  double releaseVersion;
  String deploymentDate;
  String status;
  int ReleasenotestableId;
  int EmployeeId;
  int Developer;
  String ReleaseVersion;
  String ReleaseDate;
  String DevComments;

  FeedbackIssues({this.ID, this.issueID, this.issueString, this.Module, this.subModule, this.createdBy, this.submittedDate, this.description, this.LeadComments, this.DeveloperName, this.modifiedDate
  ,this.releaseVersion, this.deploymentDate, this.status, this.ReleasenotestableId, this.EmployeeId, this.Developer, this
  .ReleaseVersion, this.ReleaseDate, this.DevComments});
}

class Developers {
  int Employeeid;
  String EmployeeName;
  Developers({this.Employeeid, this.EmployeeName});
}