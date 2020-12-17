

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Commonmethod {
  static void alertToShow(String message, String msgtitle, BuildContext context) {
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

  static String convertDateToDefaultFomrate(String dateInString){
    if(dateInString != null && dateInString != 'null'){
      DateTime date = DateTime.parse(dateInString);
      return DateFormat('dd MMMM yyyy').format(date);
    }else {
      return "-";
    }

  }

  static Widget noRecordsFoundContainer(String message) {

    return SizedBox(
      height: 100,
      child: Container(
        child:  Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(message, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
        ),
      ),
    );
  }

  static Widget getCircularImage(String urlString, String accessToken) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10000.0),
      child: CachedNetworkImage(
        httpHeaders: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
        imageUrl: urlString ?? "",
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        placeholder: (context, url) =>  CircleAvatar(
          radius: 30.0,
          backgroundImage: AssetImage('Assets/profile_img.png'),
          backgroundColor: Colors.transparent,
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: 30.0,
          backgroundImage: AssetImage('Assets/profile_img.png'),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

class Singleton {
  static Singleton _instance;
  static String profileURL;
  static String roleName;

  Singleton._internal() {
    _instance = this;
  }

  factory Singleton() => _instance ?? Singleton._internal();
}