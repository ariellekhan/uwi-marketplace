import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';

class Chat extends StatefulWidget{

  @override
  _ChatState createState() => new _ChatState();
}

class _ChatState extends State<Chat> {
  String peerId;
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
          backgroundColor: Colors.pink,
        ),

        body: Text("Implement Chat"),
      );




}
