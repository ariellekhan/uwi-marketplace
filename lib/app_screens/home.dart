import 'package:flutter/material.dart';
import '../authentication.dart';

class Home extends StatefulWidget{

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  String email = getUser().email; //temporary code - can be deleted
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          backgroundColor: Colors.pink,
        ),

        body: Text("Welcome $email"),
      );

}
