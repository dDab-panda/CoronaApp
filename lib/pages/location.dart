import 'package:flutter/material.dart';
// import 'package:mishmash_flutter/services/authentication.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

import 'package:flutter/services.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

class MapPage extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => new _LocationState();
}


class _LocationState extends State<MapPage>  {
  
  final databaseReference = FirebaseDatabase.instance.reference();
  GoogleMapController _controller;
  Position position;
  Geolocator geolocator = Geolocator();

  LocationData userLocation;
  Widget _child;
  String _userId = "";

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // final FirebaseUser user=null;

  @override
  void initState(){
    // _child= RippleIndicator("Getting Location");
    super.initState();
    inputData();
    _getLocation().then((position) {
      userLocation = position;
      //  getAddress(userLocation.latitude, userLocation.longitude);
    });
   
    // getCurrentLocation();
  }
  Map<MarkerId, Marker> usersmarkers = <MarkerId, Marker>{};


  void initmarker(double latitude, double longitude){

    final Marker differentuser =Marker(
      markerId: MarkerId("HOME 2"),
      position: LatLng(latitude,longitude),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: "Homeeeeeeeeeeee"),

    );
    setState(() {
      usersmarkers[markerId]=differentuser;
    });
  }

  var overalluserid;

  void inputData() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    overalluserid = user.uid;
    print(overalluserid);
    // return uid;
    // here you write the codes to input the data into firestore
  }

  void createRecord(double latitude, double longitude, List<Placemark> placemark){
    print("You enyetrered here");
    // print();
    inputData();
    databaseReference.child("LOCATIONSs").child(overalluserid).set({
   'latitude': latitude,
    'longitude': longitude,
    'Address': address,
    'Country': placemark[0].country,
    'Locality': placemark[0].locality,
    'AdministrativeArea': placemark[0].administrativeArea,
    'PostalCode': placemark[0].postalCode,
    'Name': placemark[0].name,
    'ISO_CountryCode':placemark[0].isoCountryCode,
    'SubLocality': placemark[0].subLocality,
    'SubThoroughfare': placemark[0].subThoroughfare,
    'Thoroughfare': placemark[0].thoroughfare,
    });
  }

 

  void updateRecord(double latitude, double longitude, List<Placemark> placemark){
    print("Update record fucntion");
    inputData();
    print(overalluserid);

    int checkid=0;
          databaseReference.child("LOCATIONS").once().then((DataSnapshot snapshot) {
            print('${snapshot.value.keys}');
            for(var userids in snapshot.value.keys){
              if(overalluserid==userids){
                checkid=1;
                print(check);
              }
            }
          });



         databaseReference.child("CoronaYes").once().then((DataSnapshot snapshot) {
    print('${snapshot.value.keys}');
    // print(snapshot.value.keys);
    for (var id in snapshot.value.keys){
        print(id);
        print("raghav");
          databaseReference.child("LOCATIONS").child(id).once().then((DataSnapshot snapshot) {
          // print('${snapshot.value['latitude']}');
          if(snapshot.value!=null){
            print(snapshot.value['latitude']);
            print(snapshot.value['longitude']);
          }
        });
      }
    });

    
          if(checkid==0){
             databaseReference.child("LOCATIONS").child(overalluserid).set({
            'latitude': latitude,
              'longitude': longitude,
              'Address': address,
              'Country': placemark[0].country,
              'Locality': placemark[0].locality,
              'AdministrativeArea': placemark[0].administrativeArea,
              'PostalCode': placemark[0].postalCode,
              'Name': placemark[0].name,
              'ISO_CountryCode':placemark[0].isoCountryCode,
              'SubLocality': placemark[0].subLocality,
              'SubThoroughfare': placemark[0].subThoroughfare,
              'Thoroughfare': placemark[0].thoroughfare,
              });
          }
          else{
            databaseReference.child("LOCATIONS").child(overalluserid).update({
            'latitude': latitude,
            'longitude': longitude,
            'Address': address,
            'Country': placemark[0].country,
            'Locality': placemark[0].locality,
            'AdministrativeArea': placemark[0].administrativeArea,
            'PostalCode': placemark[0].postalCode,
            'Name': placemark[0].name,
            'ISO_CountryCode':placemark[0].isoCountryCode,
            'SubLocality': placemark[0].subLocality,
            'SubThoroughfare': placemark[0].subThoroughfare,
            'Thoroughfare': placemark[0].thoroughfare,
            });
          }
          // if(snapshot.value!=null){
          //   print(snapshot.value['latitude']);
          //   print(snapshot.value['longitude']);
          // }

    
  }
  



int check=0;

   List<Placemark> placemark;
  String address="";

  void getAddress(double latitude, double longitude) async{

    placemark= await geolocator.placemarkFromCoordinates(latitude, longitude);

    address=placemark[0].name.toString() +","+ placemark[0].locality.toString();
    print(address);


      updateRecord(latitude, longitude, placemark);
    
  }





  Future<LocationData> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await _locationTracker.getLocation();
      // currentLocation = await geolocator.getCurrentPosition();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }





  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return user;
  }

  
  // void alertcorona() {
  //   // flutter defined function
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: new Text("Alert Dialog title"),
  //         content: new Text("Alert Dialog body"),
  //         actions: <Widget>[
  //           // usually buttons at the bottom of the dialog
  //           new FlatButton(
  //             child: new Text("Close"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  // _getLocation().then((value) {
                  //   setState(() {
                  //     userLocation = value;
                  //   });
                  // });
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => mapWidget()),
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


LatLng sendlocation;

    void googlemapbutton() async {
    try {
      var location = await _locationTracker.getLocation();

      // createRecord();
      getAddress(location.latitude, location.longitude);
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
              check=1;
              print("sefsf");
          updateMarkerAndCircle(newLocalData);
          print("sefsf");
          getAddress(newLocalData.latitude, newLocalData.longitude);
          
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  
  
  
  
  
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );






  Widget mapWidget(){
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        // markers: createMarker(),
        markers: Set.of((marker != null) ? [marker] : []),
        // initialCameraPosition: CameraPosition(
        //   target: LatLng(userLocation.latitude, userLocation.longitude),
        //   zoom: 12.0,
        // ),
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller){
          _controller=controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            googlemapbutton();
            //  alertcorona();
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




