import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PlaceholderWidget extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => new _AlertState();
}


class _AlertState extends State<PlaceholderWidget>  {
//  final Color color;

//  PlaceholderWidget(this.color);
final databaseReference = FirebaseDatabase.instance.reference();


  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
int yes=1;
 @override
 Widget build(BuildContext context) {
   return AlertDialog(
          title: new Text("Alert Dialotle"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                // raghav();
                yescoronaRecord();
                // Navigator.of(context).pop();
                
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                nocoronaRecord();
                // Navigator.of(context).pop();
                
              },
            ),
          ],
      );
 }

 Widget raghav(){
   return Scaffold(
     appBar: AppBar(
       title: new Text("rgjhebrg")
     ),
     body: new Container(
       child: new Text("kjesfbwjehbfgj"),
     )
   );
 }

  var overalluserid;

  void inputData() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    overalluserid = user.uid;
    print(overalluserid);
    // return uid;
    // here you write the codes to input the data into firestore
  }
  var ids;

  void yescoronaRecord(){
    print("You enyetrered here");
    inputData();
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

    databaseReference.child("CoronaNo").child(overalluserid).remove();
    databaseReference.child("CoronaYes").child(overalluserid).set({
      'title': 'You have corona',
      // 'UserId': overalluserid,
      
    });
  }

    void nocoronaRecord(){
    print("You enyetrered into nocorona record here");
    inputData();
     databaseReference.child("CoronaNo").child(overalluserid).once().then((DataSnapshot snapshot) {
    print('Data : ${snapshot.value}');
    });
    //Ask alert multiple times because if by mistake click.
    databaseReference.child("CoronaYes").child(overalluserid).remove();
    databaseReference.child("CoronaNo").child(overalluserid).set({
      'title': 'You dont have corona',
      // 'UserId': overalluserid,
      
    });
  }

  

}




