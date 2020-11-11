

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
}
