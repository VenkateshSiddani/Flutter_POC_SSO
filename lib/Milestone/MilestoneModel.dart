

class MileStone {
  Map<String, dynamic> data ;

  final List<dynamic> birthdaysList;
  final List<dynamic> abbottAniversaryList;
  final List<dynamic> holidaysList;
  final List<dynamic> ctsAniversaryList;
  final List<dynamic> todayBirthdayList;
  final List<dynamic> regionalHolidayList;
  final List<dynamic> nationalHollidayList;
  final Error errorObj;

  MileStone({ this.data, this.birthdaysList, this.abbottAniversaryList, this.holidaysList, this.ctsAniversaryList,this.todayBirthdayList,this.regionalHolidayList,this.nationalHollidayList, this.errorObj});

  factory MileStone.fromJson(Map<String, dynamic> json) {

    return MileStone(
      data: json['data'],
      birthdaysList: json['data']['BirthdayList'],
      abbottAniversaryList: json['data']['AbbottAnniversaryList'],
      holidaysList: json['data']['HolidayList'],
      ctsAniversaryList: json['data']['CTSAnniversaryList'],
      todayBirthdayList:json['data']['TodayBirthdayList'],
      regionalHolidayList: json['data']['RegionalHolidayList'],
      nationalHollidayList:json['data']['NationalHolidayList']
    );
  }
}
class Error {
  String ErrorDesc;
  int ErrorCode;
  Error(this.ErrorDesc, this.ErrorCode);
}
class Event{
  int employeeID;
  String title;
  String Image;
  String DOB;
  int Differenceyears;
  String color;
  String Email;
  String SecondaryEmail;
  String Type;
  int HolidayType;

  Event({ this.employeeID, this.title, this.Image, this.DOB, this.Differenceyears, this.color, this.Email, this.SecondaryEmail, this.Type, this.HolidayType});
}

class MilestoneEvents {
  List<Event> BirthdayList;
  List<Event> AbbottAnniversaryList;
  List<Event> HolidayList;
  List<Event> CTSAnniversaryList;
  List<Event> TodayBirthdayList;
  List<Event> RegionalHolidayList;
  List<Event> NationalHolidayList;

  MilestoneEvents({this.BirthdayList, this.AbbottAnniversaryList, this.HolidayList, this.CTSAnniversaryList, this.TodayBirthdayList, this.RegionalHolidayList, this.NationalHolidayList});
}

class MyMileStone {
  Map<String, dynamic> data ;
  String DOB;
  String CognizantDOJ;
  String AbbottDOJ;
  bool IsExclude;
    // Wisherslist
  int Totaldays;
  int TotalMonth;
  int TotalYear;
  int TotaldaysCognizant;
  int TotalMonthCognizant;
  int TotalYearCognizant;
  int TotaldaysAbbott;
  int TotalMonthAbbott;
  int TotalYearAbbott;
  int ID;
  List<dynamic>  myWishes;

  final Error errorObj;

  MyMileStone({ this.data, this.ID, this.DOB,this.CognizantDOJ, this.AbbottDOJ, this.IsExclude, this.myWishes, this.Totaldays,this.TotalMonth,this.TotalYear,this.TotaldaysCognizant,this.TotalMonthCognizant, this.TotalYearCognizant, this.TotaldaysAbbott, this.TotalMonthAbbott, this.TotalYearAbbott, this.errorObj});

  factory MyMileStone.fromJson(Map<String, dynamic> json) {

    return MyMileStone(
        data: json['data'],
        DOB: json['data']['DOB'],
        ID:json['data']['Id'],
        CognizantDOJ: json['data']['CognizantDOJ'],
        AbbottDOJ: json['data']['AbbottDOJ'],
        IsExclude: json['data']['IsExclude'],
        Totaldays: json['data']['Totaldays'],
        TotalMonth:json['data']['TotalMonth'],
        TotalYear: json['data']['TotalYear'],
        TotaldaysCognizant:json['data']['TotaldaysCognizant'],
        TotalMonthCognizant:json['data']['TotalMonthCognizant'],
        TotalYearCognizant:json['data']['TotalYearCognizant'],
        TotaldaysAbbott:json['data']['TotaldaysAbbott'],
        TotalMonthAbbott:json['data']['TotalMonthAbbott'],
        TotalYearAbbott:json['data']['TotalYearAbbott'],
        myWishes:json['data']['Wisherslist']
    );
  }
}

class MyWishes{
  String EmployeeName;
  String Image;
  String Comments;
  MyWishes({this.EmployeeName, this.Image, this.Comments});

}