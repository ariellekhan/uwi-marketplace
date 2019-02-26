import 'package:flutter/material.dart';

class Home extends StatefulWidget{

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          backgroundColor: Colors.pink,
        ),

        body: Text("Welcome"),
      );

}
