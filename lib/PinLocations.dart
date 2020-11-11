import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';
import 'dart:async';


//void main() => runApp(PinLocations());


class PinLocations extends StatefulWidget {

  final Map<String, dynamic> userDetails;

  PinLocations({Key key, @required this.userDetails}) : super(key: key);

  @override
  _PinLocationsState createState() => _PinLocationsState();

}

class _PinLocationsState extends State<PinLocations> {

  Completer<GoogleMapController> _controller = Completer();
  Map<String, dynamic> get userDetails => widget.userDetails;
  final List<dynamic> locations = [];
  Set<Marker> markers = Set();
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Position _currentPosition;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  String address = "";
  String zipCode = "";

  static final UPDATE_LOCATION = kUpdateLatLong;

  void fetchData(){
    setCustomMapPin();
    setState(() {
      multiplePins();

    });
  }

  @override
  void initState() {
    super.initState();
   fetchData();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'Assets/destination_map_marker.png');
  }

//  12.902744, 80.234874
  static LatLng pinPosition = LatLng(12.902744, 80.234874);

  // these are the minimum required values to set
  // the camera position
  CameraPosition initialLocation = CameraPosition(
      zoom: 16,
      bearing: 30,
      target: pinPosition
  );

  void multiplePins(){
    for (var i = 0; i < 3; i++) {
      if (i == 0){
        // Create a new marker
        Marker resultMarker = Marker(
          markerId: MarkerId("${i}"),
          infoWindow: InfoWindow(
              title: "Temple",
              snippet: "Siddani"),
          position: LatLng(12.899983, 80.235486),
        );
        markers.add(resultMarker);

      } else if (i == 1){
        // Create a new marker
        Marker resultMarker = Marker(
          markerId: MarkerId("${i}"),
          infoWindow: InfoWindow(
              title: "Temple2",
              snippet: "Siddani"),
          position: LatLng(12.901709, 80.233662),
        );
        markers.add(resultMarker);

      } else  if (i == 2){
        // Create a new marker
        Marker resultMarker = Marker(
          markerId: MarkerId("${i}"),
          infoWindow: InfoWindow(
              title: "Temple3",
              snippet: "Siddani"),
          position: LatLng(12.902744, 80.234874),
        );

        markers.add(resultMarker);
      }


    }
  }


// Add it to Set


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text("Locations"),
          automaticallyImplyLeading: true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, false),
          ),
          actions: <Widget>[
      // action button
            new Center(
              child: RaisedButton(onPressed: () {
                _getCurrentLocation();
              },
                child: new Text(
                  "Update",
                  textScaleFactor: 1.5,
                  style: new TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),),


            )

            ]
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: markers,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
//          markers: markers,
//          setState(() {
//            markers: markers;
//            _markers.add(
//                Marker(
//                    markerId: MarkerId('Venky'),
//                    position: pinPosition,
//                    icon: pinLocationIcon,
//                )
//            );
//          });
        },
      ),
    );
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        print(position.latitude);
        print(position.longitude);
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {

       print ("${place.locality}, ${place.postalCode}, ${place.country}");
       address = "${place.name}, ${place.locality}, ${place.country}";
       zipCode = place.postalCode;
       _showDialog("Capturing the Current location :\n${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}", "Confirm");


      });
    } catch (e) {
      print(e);
    }
  }

  // Confirm : Capturing the current location
  // user defined function
  void _showDialog(String message, String msgtitle) async  {
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
              child: new Text("Proceed"),
              onPressed: () {
                updateLocationToBackeEnd();
                Navigator.of(context).pop();
              },

            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // user defined function
  void _successAlert(String message, String msgtitle)  {
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
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  updateLocationToBackeEnd() async {

    // Post parameters to update location and latitude
    Location jsonDictionary = new Location(
      empID: userDetails["EmployeeId"].toString(),
      latitude: _currentPosition.latitude.toString(),
      longitude: _currentPosition.longitude.toString(),
      zipCode: zipCode.toString(),
      isActive: "1",
      address: address,
      createdBy: userDetails["EmployeeId"].toString(),
      action: "3",
    );
    Location l = await createPost(UPDATE_LOCATION,
        body: jsonDictionary.toMap());
    if (l.data == "Success") {
          _successAlert("Updated successfully" , "Info");
    } else {
      _successAlert("Internal server error occured", "Error");

    }
    return false;
  }
}



class Location {
  final String empID;
  final String latitude;
  final String longitude;
  final String zipCode;
  final String isActive;
  final String address;
  final String createdBy;
  final String action;
  final String data;
//  final List<dynamic> roles;
  final Map<String, dynamic> json;
  final  List<dynamic> employeeLocations;

  Location({this.empID, this.latitude, this.longitude, this.zipCode, this.isActive, this.address, this.createdBy, this.action, this.json, this.data, this.employeeLocations});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      data: json["data"]

    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["empid"] = empID;
    map["Latitude"] = latitude;
    map["Longitude"] = longitude;
    map["Zipcode"] = zipCode;
    map["IsActive"] = isActive;
    map["Address"] = address;
    map["CreatedBy"] = createdBy;
    map["Action"] = action;

    return map;
  }
}

Future<Location> createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    print(http.Response);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return Location.fromJson(json.decode(response.body));
  });
}
