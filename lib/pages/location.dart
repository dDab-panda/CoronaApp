import 'package:flutter/material.dart';
import 'package:mishmash_flutter/pages/chat.dart';

class Location extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _LocationState();
}


class _LocationState extends State<Location>  {
  
   @override
  Widget build(BuildContext context) {
    return new MaterialApp(
     title: "LOcation Page",
     theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new PlaceholderWidget(Colors.black)
    );
  }
}