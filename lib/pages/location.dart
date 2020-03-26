import 'package:flutter/material.dart';
// import 'package:mishmash_flutter/services/authentication.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

import 'package:flutter/services.dart';
import 'dart:async';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

class MapPage extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => new _LocationState();
}


class _LocationState extends State<MapPage>  {
  
  GoogleMapController _controller;
  Position position;
  Geolocator geolocator = Geolocator();

  Position userLocation;
  Widget _child;
  String _userId = "";

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseUser user=null;

  @override
  void initState(){
    // _child= RippleIndicator("Getting Location");
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
       getAddress(userLocation.latitude, userLocation.longitude);
    });
   
    // getCurrentLocation();
  }

   List<Placemark> placemark;
  String address="";

  void getAddress(double latitude, double longitude) async{
    placemark= await geolocator.placemarkFromCoordinates(latitude, longitude);

    address=placemark[0].name.toString() +","+ placemark[0].locality.toString();
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            userLocation == null
                ? CircularProgressIndicator()
                : Text("Location:" +
                    userLocation.latitude.toString() +
                    " " +
                    userLocation.longitude.toString()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  _getLocation().then((value) {
                    setState(() {
                      userLocation = value;
                    });
                  });
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => mapWidget(userLocation)),
                  );
                },
                color: Colors.blue,
                child: Text(
                  "Get Location",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Marker marker;

   void updateMarkerAndCircle(LocationData newLocalData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.defaultMarker);
      // circle = Circle(
      //     circleId: CircleId("car"),
      //     radius: newLocalData.accuracy,
      //     zIndex: 1,
      //     strokeColor: Colors.blue,
      //     center: latlng,
      //     fillColor: Colors.blue.withAlpha(70));
    });
  }
    void googlemapbutton() async {
    try {

      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }


      _locationSubscription = _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(newLocalData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  Widget mapWidget(userLocation){

    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        // markers: createMarker(),
        markers: Set.of((marker != null) ? [marker] : []),
        initialCameraPosition: CameraPosition(
          target: LatLng(userLocation.latitude, userLocation.longitude),
          zoom: 12.0,
        ),
        onMapCreated: (GoogleMapController controller){
          _controller=controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            googlemapbutton();
          }),
    );
  }

   Set<Marker> createMarker(){
    return <Marker>[
      Marker(
        markerId: MarkerId("Home"),
        position: LatLng(userLocation.latitude, userLocation.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "Homeeeeeeeeeeee", snippet: address),
        
      ),

    ].toSet();
  }

 
  
}




