import 'dart:io';

import 'package:flutter/material.dart';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:aid/SpotLight/SpotLightModule.dart';
import 'package:aid/constants.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/options.dart';


class SpotLightState extends StatefulWidget {

  final String folderName;
  final String titleOfScreen;
  final List<SpotLightImage> results;
  final String accessToken;


  SpotLightState({Key key, @required this.folderName, this.titleOfScreen, this.results, this.accessToken}) : super(key: key);

  _SpotLightState createState() => new _SpotLightState();
}

class _SpotLightState extends State<SpotLightState> with SingleTickerProviderStateMixin {
//  Animation<double> animation;
//  AnimationController controller;

  String get folderName => widget.folderName;
  String get title => widget.titleOfScreen;
  List<SpotLightImage> get results => widget.results;
  String get accessToken => widget.accessToken;

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

   }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

 List<String> getImages(String folderName)  {

  List<String> listOFImages = [];
    var baseImageURL = kSpotLightFolder + '/assets/img/${folderName}/';
    results.forEach((element) {
      listOFImages.add(baseImageURL+element.originalPath);
    });
    return listOFImages;

  }
  //
  // getImage() async {
  //
  //   var dio = await Dio();
  //   dio.options.baseUrl = 'http://10.154.201.115/assets/img/Kyctsteam/1.jpg';
  //   dio.options.headers = headers;//add your type of authentication
  //   Response response = await dio.get("/uri/");
  //   print(response);
  //   // final response = await Dio.get(
  //   //     url,
  //   //     options: Options(
  //   //       headers: {
  //   //         'Authorization': 'Bearer $token',
  //   //       },
  //   //     )
  //   // );
  // }

  Map<String, String> get headers => {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
    // 'Accept': 'application/json',
  };

  // NetworkImage getNetworkImage(String url,String authKey){
  //   return NetworkImage(url,headers: headers);
  // }
  CarouselSlider touchDetectDemo(String folderName) {


    //User input pauses carousels automatic playback
    final CarouselSlider touchDetectionDemo = CarouselSlider(
      viewportFraction: 0.9,
      aspectRatio: 2.0,
      autoPlay: true,
      enlargeCenterPage: true,
      pauseAutoPlayOnTouch: Duration(seconds: 3),
      items: getImages(folderName).map(
            (url) {
          return Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              // child: CachedNetworkImage(
              //   placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              //   imageUrl: url,
              //   fit: BoxFit.fitHeight,
              //   httpHeaders: headers,
              // ),
              child: Image.network(url, headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},),),
          );
        },
      ).toList(),
    );

    return touchDetectionDemo;
  }



  @override
  Widget build(BuildContext context) {

//    final title = "Know Your CTS TeamMate";
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.height;

    return new Scaffold(
      appBar: AppBar(
          title: Text(title),
//          automaticallyImplyLeading: true,
//          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
//            onPressed: () => Navigator.pop(context),
//          )
      ),
      backgroundColor: Colors.white,
      body: new Center(
        child: new Container(
          padding: const EdgeInsets.all(20.0),
          height: screenHeight,
          child: new ClipRRect(
            borderRadius: BorderRadius.circular(0.0),
            child: new Stack(
              children: [
                touchDetectDemo(folderName),
                // banner,
              ],
            ),
          ),
        ),
      ),
    );
  }

//  dispose() {
//    controller.dispose();
//    super.dispose();
//  }
}
