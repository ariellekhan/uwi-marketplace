import 'package:flutter/material.dart';

class Feed extends StatefulWidget{

  @override
  _FeedState createState() => new _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text("Feed"),
          backgroundColor: Colors.pink,
        ),

        body: Text("Implement Feed"),
      );

}
