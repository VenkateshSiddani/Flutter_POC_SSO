/*
 * rflutter_alert
 * Created by Ratel
 * https://ratel.com.tr
 *
 * Copyright (c) 2018 Ratel, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:aid/FeedBack/FeedbackAPI.dart';
import 'package:aid/Menu.dart';
import 'package:aid/Survey/SurveyViewController.dart';
import 'package:aid/VoiceOfAnAbbottian//VoiceofanAbbottianViewController.dart';

/// Alert types
enum AlertType { error, success, info, warning, profile, none }

/// Alert animation types
enum AnimationType {
  fromRight,
  fromLeft,
  fromTop,
  fromBottom,
  grow,
  shrink
}

// Production
// const kBaseURL = 'http://10.142.130.86/webapi/api';
// const kSpotLightFolderURForProd = 'http://10.142.130.86';


// const kBaseURL = 'http://aid.cognizant.com/webapi/api';
// const kSpotLightFolder = 'http://aid.cognizant.com';

//DEv

//http://10.142.128.102:85

// const kBaseURL = 'http://10.142.128.102:85/WebApi/api';
// const kSpotLightFolderURForDev = 'http://10.142.128.102:85';

// Updated QA URL
const kBaseURL = 'http://10.154.201.115/webApi/api';
const kSpotLightFolder = 'http://10.154.201.115';


// Login
const kLoginURL = '${kBaseURL}/auth/GetToken';

// Allocation
const kGetAllocationURL = '${kBaseURL}/auth/GetAllocation';

//DiveristDashboard
const kDiversityDashBoardURL = '${kBaseURL}/EmpActiveLead/GetDiversityDetails';
const kDiversityImagedURL = '${kBaseURL}/EmpActiveLead/GetProfileImageforDiversity';

// Request URL: http://10.154.201.115/webapi/api/EmpActiveLead/GetDiversityDetails
//MilesStone API
const KMilestoneCalendarAPI = '${kBaseURL}/MilestoneWishes/GetCalendarData?empid=';
const KMyMilestoneDetailsAPI = '${kBaseURL}/MilestoneWishes/GetMyMilestones?empid=';
const KIsExcludedWish = '${kBaseURL}/MilestoneWishes/ExcludeWish';
const KSendGreetings = '${kBaseURL}/MilestoneWishes/SaveWishes';


// Spot Light
const kSpotLightURL = '${kBaseURL}/Spotlight/GetNumOfFiles?Folder=';

// Debt Analysis
const kDebtAnalysisReportsURL = '${kBaseURL}/DebtAnalysis/GetDebtAnalysiseportbyempid?empid=';
const kDebtAdherenceURL = '${kBaseURL}/DebtAnalysis/GetDebtTrendAnalysisReport?empid=';
const kDebtEffortsURL = '${kBaseURL}/DebtAnalysis/GetEffortTrackingByEmployee?empid=';
const kDebtClassificationURL = '${kBaseURL}/DebtAnalysis/GetDebtStatisticsReport?empid=';
const kDebtStatasticsURL = '${kBaseURL}/DebtAnalysis/QueryDebtStatisticRNDData';

//GetoverallDebtAnalysisReport

const kOverAllDebtAdherenceURL = '${kBaseURL}/DebtAnalysis/GetoverallDebtAnalysisReport?empid=';
const kAppCertificationURL = '${kBaseURL}/Appliactiondlcertify/GetCertifiedCount?Empid=';
const kUpdateLatLong = "${kBaseURL}/iclient/Createupdatedeletelocation";

//Training Reports
const KGETCLIENTDASHBOARD_URL = '${kBaseURL}/Training/GetClientDashboard?empid=';
const KCOGNIZANTDASHBOARD_URL = '${kBaseURL}/Training/GetCognizantDashboard?empid=';
const KMYTRAINING_STATUS_URL = '${kBaseURL}/Training/GetMYTrainingStatusList?employeeid=';
const KANALYTICS_STATUS_URL = '${kBaseURL}/Training/TotalEscalationhistoryrecords';
const KDEFAULTER_DISPLAYCLIENT = '${kBaseURL}/Training/DefaulterDisplayClient?empid=';
const KFILTER_ASSOCIATES = '${kBaseURL}/Training/Filteredassociates?empid=';
const KDEFAULTER_DISPLAY = '${kBaseURL}/Training/DefaulterDisplay?empid=';
const KREMIDER_1 = '${kBaseURL}/Training/Filteredassociatesforcognizanttraining?empid=';
const SecondaryLeadAPI = '${kBaseURL}/Training/TotalAssociatesSecLead?empid=';
const SecondaryLeadAPICTS = '${kBaseURL}/Training/TotalAssociatesSecLeadCog?empid=';

//Survey
const SURVEY_DETAILSAPI = '${kBaseURL}/EmpActiveLead/GetEmpCovid19Status?empid=';
const SURVEY_LISTAPI = '${kBaseURL}/Survey/GetSurveyList?empID=';
const CAB_DASHBOARD_SURVEY = '${kBaseURL}/Survey/GetCabSurveyStatistict?surveyID=2';
const WORKLOCATION_DASHBOARD_SURVEY = '${kBaseURL}/Survey/GetSurveyDetails?surveyID=1';
const CAB_DASHBOARD_SURVEYSTATISTICS = '${kBaseURL}/Survey/GetSurveyStatistict?surveyID=1';


//Voice of An Abbottian
const VOICE_ABBOTTIAN = '${kBaseURL}/ResourceProfile/GetVoiceOfAbbottian?empID=';
const VOICE_ALLEMPLOYEES = '${kBaseURL}/EmpActiveLead/GetEmployeeListForVoice';
const VOICE_SUBMIT = '${kBaseURL}/ResourceProfile/SubmitVoiceOfAbbottian';


//Feedback
const FEEDBACK_MODULES = '${kBaseURL}/Feedback/GetModuleDetails?empid=';
const SUBMIT_FEEDBACK = '${kBaseURL}/Feedback/SaveFeedbackDetails';

/// Library images path
const String kImagePath = "Assets";

//ViewController Title Names:
const String WORLD_CLOCK_TITLE = "World Clock";
const String DIVERSITY_DASHBOARD = "Diversity Module";
const String TRAININGS = "Trainings";
const String SURVEY_MODULE = "Survey Module";
const String CAB_DASHBOARD = "Cab Dashboard";
const String WORK_DASHBOARD = "Work Location Dashboard";
const String VOICE_MODULE = "Voice of an Abbottian";
const String FEEDBACK_MODULE = "Feedback";


// Time Zone
const INDIA_TIMEZONE = "Asia/Kolkata";
const SINGAPORE_TIMEZONE = "Asia/Singapore";
const CHINA_TIMEZONE = "Asia/Shanghai";
const JAPAN_TIMEZONE = "Asia/Tokyo";
const GERMANY_TIMEZONE = "Europe/Berlin";
const NETHARLAND_TIMEZONE = "Europe/Amsterdam";
const UK_TIMEZONE = "Europe/London";
const ARGENTINA_TIMEZONE = "America/Argentina/Jujuy";
const BRAZIL_TIMEZONE = "America/Bahia";
const MEXICO_TIMEZONE = "America/Cancun";
const US_TIMEZONE = "America/Indiana/Indianapolis";
const CANADA_TIMEZONE = "America/Regina";


//Messages
const CONNECTIVITY_ERROR = "Please check the interenet connection";
const SOCKET_EXCEPTION_ERROR = "Connect VPN and try again";

//Santosh Image
const SANTOSH_IMAGE_URL = "https://aid.cognizant.com/assets/img/profile/6e72e10b-95d9-4a21-a20f-85ec8da93f48.jpg";

