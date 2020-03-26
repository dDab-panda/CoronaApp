import 'package:flutter/material.dart';
import 'package:mishmash_flutter/services/authentication.dart';
import 'package:mishmash_flutter/pages/location.dart';
import 'package:mishmash_flutter/pages/chat.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}


class _HomePageState extends State<HomePage>  {
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int index=0;


   signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } 
    catch (e) {
      print(e);
    }
  }

  void onTabTapped(int value) {
   setState(() {
    //  _currentIndex = index;
     print(index);
     index=value;
   });
 }
   @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Home Page erge '),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
       ),
        body: getpages(index),

        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
        // this will be set when a new tab is tapped
       items: [
         BottomNavigationBarItem(
           icon: new Icon(Icons.home),
           title: new Text('Home'),
           
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.mail),
           title: new Text('Messages'),
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.person),
           title: Text('Profile')
         )
       ],
     ),
    );
  }

  Widget getpages(int index){
    //Here on index we can return different pages!
    if(index==0){
      return MapPage();
    }
    else{
      return PlaceholderWidget(Colors.deepOrange);
    }
  }



}