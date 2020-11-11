class SurveyModel{
  int EmployeeId;
  String EmployeeName;
  int SecondaryLeadID;
  String SLeadName;
  String Department;
  String OfficeLocation;
  String AddressLine1;
  String AddressLine2;
  String AddressLine3;
  String ResidentialCountry;
  String ResidentialState;
  String ResidentialCity;
  String Zipcode;
  String Gender;
  String ContactNumber;
  String EmergencyContactNumber;
  String EmergencyContactName;
  String Grade;
  bool IsSafe;
  String SafeComments;
  bool IsConnect;
  String ConnectComments;
  bool IsCurrentAddress;
  String NewAddressLine;
  String NewResidentialCity;
  String NewResidentialState;
  String NewResidentialCountry;
  String CurrentDevice;
  bool IsDevicePurchased;
  bool IsNewDeviceAdded;
  bool IsCertified;
  String certifiedDate;
  Map<String, dynamic> data ;
  final Error errorObj;

  SurveyModel({this.EmployeeId, this.EmployeeName, this.SecondaryLeadID, this.SLeadName, this.Department, this.OfficeLocation, this.AddressLine1, this.AddressLine2,
  this.AddressLine3, this.ResidentialCountry, this.ResidentialState, this.ResidentialCity, this.Zipcode, this.Gender, this.ContactNumber, this.EmergencyContactName, this.EmergencyContactNumber,
  this.Grade,this.IsSafe, this.SafeComments, this.IsConnect, this.ConnectComments, this.IsCurrentAddress, this.NewAddressLine, this.NewResidentialCity, this.NewResidentialState, this.NewResidentialCountry,
  this.CurrentDevice,this.IsDevicePurchased, this.IsNewDeviceAdded, this.IsCertified, this.certifiedDate, this.data, this.errorObj});
  factory SurveyModel.fromJson(Map<String, dynamic> json) {

    return SurveyModel(
        data: json['data'],
        EmployeeId: json['data']['EmployeeId'],
        EmployeeName: json['data']['EmployeeName'],
        SecondaryLeadID: json['data']['SecondaryLeadID'],
        SLeadName: json['data']['SLeadName'],
        Department:json['data']['Department'],
        OfficeLocation: json['data']['OfficeLocation'],
        AddressLine1:json['data']['AddressLine1'],
        AddressLine2: json['data']['AddressLine2'],
        AddressLine3: json['data']['AddressLine3'],
        ResidentialCountry: json['data']['ResidentialCountry'],
        ResidentialState: json['data']['ResidentialState'],
        ResidentialCity:json['data']['ResidentialCity'],
        Zipcode: json['data']['Zipcode'],
        Gender:json['data']['Gender'],
        ContactNumber: json['data']['ContactNumber'],
        EmergencyContactName: json['data']['EmergencyContactName'],
        EmergencyContactNumber: json['data']['EmergencyContactNumber'],
        Grade: json['data']['Grade'],
        IsSafe:json['data']['IsSafe'],
        SafeComments: json['data']['SafeComments'],
        IsConnect:json['data']['IsConnect'],
        ConnectComments: json['data']['ConnectComments'],
        IsCurrentAddress: json['data']['IsCurrentAddress'],
        NewAddressLine: json['data']['NewAddressLine'],
        NewResidentialCity: json['data']['NewResidentialCity'],
        NewResidentialState:json['data']['NewResidentialState'],
        NewResidentialCountry: json['data']['NewResidentialCountry'],
        CurrentDevice:json['data']['CurrentDevice'],
        IsDevicePurchased: json['data']['IsDevicePurchased'],
        IsNewDeviceAdded: json['data']['IsNewDeviceAdded'],
        IsCertified: json['data']['IsCertified'],
        certifiedDate:json['data']['certifiedDate']
    );
  }

  // "HardwareData": {
  // "Id": 75,
  // "ResourceId": 773777,
  // "ResourceProfileId": 0,
  // "CTSDesktop": false,
  // "DesktopCPUMake": null,
  // "DesktopCPUModel": null,
  // "DesktopAssetID": null,
  // "IsDesktopEncrypted": false,
  // "AbbottDesktop": false,
  // "AbbottDesktopCPUMake": null,
  // "AbbottDesktopCPUModel": null,
  // "AbbottDesktopAssetID": null,
  // "CTSLaptop": true,
  // "LaptopMake": "Apple",
  // "LaptopModel": "Mac Book pro",
  // "LaptopSerialNo": "C02YD0V7JG5J",
  // "LaptopAssetID": "AMBIN01502",
  // "AbbottLaptop": false,
  // "AbbottLaptopMake": null,
  // "AbbottLaptopModel": null,
  // "AbbottLaptopSerialNo": null,
  // "AbbottLaptopAssetID": null,
  // "CTSiPad": true,
  // "iPadMake": "Apple / iPad Pro Wi-Fi + Cellular 64GB - Space Grey 10.5-inch",
  // "iPadModel": "iPad 2nd Generation",
  // "iPadSerialNo": "DMPXL01FJ28L",
  // "iPadAssetID": "AIP01427",
  // "CTSMobile": false,
  // "MobileMake": null,
  // "MobileModel": null,
  // "MobileSerialNo": null,
  // "MobileIMEINo": null,
  // "AbbottMobile": false,
  // "AbbottMobileMake": null,
  // "AbbottMobileModel": null,
  // "AbbottMobileSerialNo": null,
  // "AbbottMobileIMEINo": null,
  // "CTSDataCard": false,
  // "DataCardMake": null,
  // "DataCardModel": null,
  // "CTSSIM": false,
  // "ServiceProvider": null,
  // "SIMnumber": null,
  // "DataCardSerialNo": null,
  // "DataCardIMEINo": null,
  // "CTSWebex": false,
  // "WebexURL": null
  // },
  // "GSDTicketList": [],
  // "DeviceList": [
  // {
  // "DeviceId": 28,
  // "DevicePurchased": "Datacard",
  // "TotalCost": "1850",
  // "PurchasedDate": "2020-03-19T18:30:00",
  // "Receipt": true,
  // "ReceiptAvailable": null
  // }
  // ],
  // "EmpList": []
}
class Error {
  String ErrorDesc;
  int ErrorCode;
  Error(this.ErrorDesc, this.ErrorCode);
}

class SurveyList {

  int surveyID;
  int surveyDetailsID;
  String surveyName;
  String surveyDesc;
  String surveyStartDate;
  String surveyEndDate;
  int surveyStatusID;
  String surveyStatusName;
  String CompletedOn;
  String imageName;

  SurveyList({this.surveyID, this.surveyDetailsID, this.surveyName, this.surveyDesc, this.surveyStartDate, this.surveyEndDate, this.surveyStatusID,
  this.surveyStatusName, this.CompletedOn, this.imageName});
}

class LocationData {
  String location;
  int  TotalResources;
  int ConcernsRaised;
  int NonCabusers;
  int Cabusersnotraisedconcerns;
  LocationData({this.location, this.TotalResources, this.ConcernsRaised, this.NonCabusers, this.Cabusersnotraisedconcerns});

}
class SurveyCabDashboard{

  int Count;
  int CompletedCount;
  int NotCompletedCount;
  int ConcernRaised;
  int Totalresource;
  String Leadname;
  String startdate;
  String Enddate;
  SurveyCabDashboard({this.Count, this.CompletedCount, this.NotCompletedCount, this.ConcernRaised, this.Totalresource, this.Leadname,this.startdate, this.Enddate});

}

class WorkLocationDashboard{
  String question;
  List<WorkLocationAnswers> answerCount;
  WorkLocationDashboard({this.question, this.answerCount});
}
class WorkLocationAnswers{
  String ActualCityName;
  int actualCount;
  int preferredCount;
  String PreferredCity;

  WorkLocationAnswers({this.ActualCityName, this.actualCount, this.PreferredCity, this.preferredCount});

}