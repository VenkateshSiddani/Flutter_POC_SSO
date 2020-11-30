
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'Menu.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // HttpOverrides.global = new MyHttpOverrides();
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(new MyApp());

}



class Post {
  final String associateID;
  final String password;
  final String message;
  final String accessToken;
//  final int EmployeeId;
  //final int roleId;
//  final List<dynamic> roles;
  final Map<String, dynamic> json;
  final Map<String, dynamic> userDetails;


  Post({this.associateID, this.password, this.message, this.accessToken, this.json, this.userDetails});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        associateID: json['Associateid'],
        password: json['Password'],
        message: json['Message'],
        accessToken: json['AccessToken'],
        userDetails: json['UserName'],
        json: json
      //roleId: json['UserName']['roles'][0]['Id'],
//        roles: json['UserName']['roles'],
//        EmployeeId: json['UserName']['EmployeeId']
      //roles :json['UserName']

    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["Associateid"] = associateID;
    map["Password"] = password;
//    map["Message"] = message;
    return map;
  }
}

class MenuIcons{

  String menuTitle;
  String assetPath;

  MenuIcons({this.menuTitle, this.assetPath});
}

Future<Post> createPost(String url, {Map body}) async {
  return http.post(url, body: body,).then((http.Response response) {
    final int statusCode = response.statusCode;

    print(http.Response);
    if (statusCode < 200 || statusCode > 400 || json == null || statusCode == 302) {
      throw new Exception("Error while fetching data");
    }
    return Post.fromJson(json.decode(response.body));
  });
}




class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<Post> post;
  MyApp({Key key, this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AID',
      debugShowCheckedModeBanner: false,
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
      home: MyHomePage(title: 'AID Login'),
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

//bool isValid= false
  final associateTextController= TextEditingController();
  final passwordTextController= TextEditingController();
  static final CREATE_LOGIN_URL = kLoginURL;

  TextStyle style = TextStyle(fontFamily: 'Montserrat' , fontSize: 20.0);
  bool _load = false;

  final ScrollController _scrollController = ScrollController();
  static final Config config = new Config("d047e984-35e7-46b3-8d6d-42d91c2e2dd0", "e417e50e-821c-460a-b047-982eff89d263", "openid profile offline_access", "https://login.live.com/oauth20_desktop.srf",);
  final AadOAuth oauth = AadOAuth(config);
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var rectSize =  Rect.fromLTWH(0.0, 25.0, screenSize.width, screenSize.height - 25);
    oauth.setWebViewScreenSize(rectSize);
    final associateidField = TextField(
      controller: associateTextController,
      //secured field true or false
      obscureText: false,
      //text style
      style: style,
      keyboardType: TextInputType.text,
      //textfield decoration
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        //Placeholder
        hintText: 'Associate ID',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );


//Creating Password test field
    final passwordField = TextField(
      //secured field true or false
      controller: passwordTextController,
      obscureText:true,
      //text style
      style: style,
      keyboardType: TextInputType.text,
      //textfield decoration
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        //Placeholder
        hintText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );



//Creating Login button

    final loginButton = Material (
      elevation: 5.0,
      borderRadius:  BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: ()
        async{
          login();
        },
//         async{
//
//           bool valid=validateInputs(associateTextController.text, passwordTextController.text);
//           if(valid== true) {
//             Post newPost = new Post(
//                 associateID: associateTextController.text,
//                 password: passwordTextController.text);
//
//             try {
//               var connectivityResult = await (Connectivity().checkConnectivity());
//               if (connectivityResult == ConnectivityResult.none)  {
//                 _showDialog(CONNECTIVITY_ERROR, "AID");
//                 return;
//               }
//               setState(() {
//                 _load = true;
//               });
//               // Post p = await createPost(CREATE_LOGIN_URL,
//                   // body: newPost.toMap());
//
//               createPost(CREATE_LOGIN_URL, body: newPost.toMap()).then((response) {
//                 if (response.message== "Success")
//                 {
//                   setState(() {
//                     _load = false;
//                   });
//                   final int EmployeeID = response.json['UserName']['EmployeeId'];
//                   final List<dynamic> roles =  response.json['UserName']['roles'];
//                   final String profileName = response.json['UserName']['FirstName'] + ' ' + response.json['UserName']['LastName'];
//
//                   final List<dynamic> menusResponse =  response.json['UserName']['Menus'];
//
//                   // List<Map<String, dynamic>> menuTitles = [{'Title':'Survey','Icon':'Assets/MenuIcons/Survey.png'},
//                   //   {'Title':'World Time','Icon':'Assets/MenuIcons/World_Clock.png'},
//                   //   {'Title':'Spot Light','Icon':'Assets/MenuIcons/Spotlight.png'},
//                   //   {'Title':'Diversity Module','Icon':'Assets/MenuIcons/Diversity.png'},
//                   //   {'Title':'Milestone','Icon':'Assets/MenuIcons/Calendar.png'},
//                   //   {'Title':'Training','Icon':'Assets/MenuIcons/Training.png'}];
//
//                   // List<MenuIcons> MenuIconsBasedRole = List();
//                   // menusResponse.forEach((menu) {
//                   //   var assetPath = 'Assets/AID_Logo.png';
//                   //   if( menu['label'] == 'Survey') {
//                   //     assetPath =  'Assets/MenuIcons/Survey.png';
//                   //   } else if( menu['label'] == 'World Clock') {
//                   //     assetPath =  'Assets/MenuIcons/World_Clock.png';
//                   //   } else if( menu['label'] == 'Spotlight') {
//                   //     assetPath =  'Assets/MenuIcons/Spotlight.png';
//                   //   }else if( menu['label'] == 'Diversity Dashboard') {
//                   //     assetPath =  'Assets/MenuIcons/Diversity.png';
//                   //   }else if( menu['label'] == 'Milestones') {
//                   //     assetPath =  'Assets/MenuIcons/Calendar.png';
//                   //   }else if( menu['label'] == 'Training') {
//                   //     assetPath =  'Assets/MenuIcons/Training.png';
//                   //   }
//                   //   MenuIconsBasedRole.add(MenuIcons(menuTitle: menu['label'], assetPath: assetPath));
//                   // });
//
//                   List<MenuIcons> MenuIconsBasedRole = List();
//                   MenuIconsBasedRole.add(MenuIcons(menuTitle: 'World Clock', assetPath: 'Assets/MenuIcons/World_Clock.png'));
//                   MenuIconsBasedRole.add(MenuIcons(menuTitle: 'Spotlight', assetPath: 'Assets/MenuIcons/Spotlight.png'));
//                   MenuIconsBasedRole.add(MenuIcons(menuTitle: 'Training', assetPath: 'Assets/MenuIcons/Training.png'));
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Menu(accessToken: response.accessToken, roles: roles, employeeID: EmployeeID.toString(), profileName: profileName, userDetails: response.userDetails, menuIcons: MenuIconsBasedRole,),
// //                        builder: (context) => Menu(),
//                       ));
//                 }
//                 else {
//                   setState(() {
//                     _load = false;
//                   });
//                   _showDialog(response.message, "AID");
//                 }
//               });
//
//             } on SocketException catch (_) {
//               // print('not connected');
//               setState(() {
//                 _load = false;
//               });
//               _showDialog(SOCKET_EXCEPTION_ERROR, "AID");
//
//             }
//
//           }
//           else
//           {
//             setState(() {
//               _load = false;
//             });
//             print("fail");
//           }
//           //print(p.title);
//         },

        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: style.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );


    //Arrainging UI after creating necessary widgets(text fields/buttos)

    final title = 'AID';
    AssetImage login_logo = AssetImage('Assets/AID_Logo.png');

    double screenHeight = MediaQuery.of(context).size.height ;
    Widget loadingIndicator = _load ? new Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),
          child: new Center(child: new CircularProgressIndicator())),
    ) : new Container();
    return new Scaffold(
//      appBar: new AppBar(
//
//      ),
//      resizeToAvoidBottomInset: false,
      body:  new Stack(children: <Widget>[new Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
          child: KeyboardAvoider(autoScroll: true,
              child:  new Center(
                child: new Container(
                  height: screenHeight - 30,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
//            color:  Colors.white,
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 125,
                        child: (Image(image: login_logo, fit: BoxFit.contain,)),
                      ),
                      SizedBox(height: 25.0,),
                      associateidField,
                      SizedBox(height: 25.0,),
                      passwordField,
                      SizedBox(height: 25.0,),
                      loginButton,
                    ],

                  ),
                ),
              ))
      ),
        new Align(
          child: loadingIndicator, alignment: FractionalOffset.center,),]),
    );

  }

  bool validateInputs( String associate, String associatepassword) {

    if(associate == "" || associatepassword== "")
    {
      _showDialog("Please enter valid credentials", "AID");
      return false;
    }


    return true;
  }

  // user defined function
  void _showDialog(String message, String msgtitle) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(msgtitle),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void showMessage(String text) {
    var alert = new AlertDialog(content: new Text(text), actions: <Widget>[
      new FlatButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void login() async {
    FirebaseCrashlytics.instance.crash();

//     try {
//       await oauth.login();
//       String accessToken = await oauth.getAccessToken();
//       showMessage("Logged in successfully, your access token: $accessToken");
//
// //       List<MenuIcons> MenuIconsBasedRole = List();
// //       MenuIconsBasedRole.add(MenuIcons(menuTitle: 'World Clock', assetPath: 'Assets/MenuIcons/World_Clock.png'));
// //       MenuIconsBasedRole.add(MenuIcons(menuTitle: 'Spotlight', assetPath: 'Assets/MenuIcons/Spotlight.png'));
// //       MenuIconsBasedRole.add(MenuIcons(menuTitle: 'Training', assetPath: 'Assets/MenuIcons/Training.png'));
// //       Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) => Menu(accessToken: '', roles: [], employeeID: '', profileName: '', userDetails: null, menuIcons: MenuIconsBasedRole,),
// // //                        builder: (context) => Menu(),
// //           ));
//     } catch (e) {
//       showError(e);
//     }
  }
  void showError(dynamic ex) {
    showMessage(ex.toString());
  }
  void logout() async {
    await oauth.logout();
    showMessage("Logged out");
  }
}

// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
//   static Future<HttpClient> getHttpClient(String userName, String password) async {
//     HttpClient client = new HttpClient()
//       ..badCertificateCallback =
//       ((X509Certificate cert, String host, int port) => true);
//     client.authenticate = (uri, scheme, realm) {
//       client.addCredentials(
//           uri, realm, new HttpClientDigestCredentials(userName, password));
//       return new Future.value(true);
//     };
//     return client;
//   }
// }