
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