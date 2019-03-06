import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../authentication.dart';


class MyItems extends StatefulWidget{
  @override
  _MyItemsState createState() => new _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(title: new Text('My Items')),
      body: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('items').document('addItems').collection('Text Book').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          //return new ListView(children: snapshot.data.documents.map((document)) => new Text(document['some_field']).toList();
          return ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) => buildItem(context, snapshot.data.documents[index]),
            itemCount: snapshot.data.documents.length,
          );
        },
      ),
      )
    );

      return StreamBuilder<QuerySnapshot>(
        //stream: Firestore.instance.collection('userItems').document(getUser().uid).collection('Text Books').snapshots(),
        stream: Firestore.instance.collection('items').document('addItems').collection('Text Book').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          //return new ListView(children: snapshot.data.documents.map((document)) => new Text(document['some_field']).toList();
          return ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) => buildItem(context, snapshot.data.documents[index]),
            itemCount: snapshot.data.documents.length,
          );
        },
      );


    }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
              maxHeight: 100.0,
              maxWidth: 300.0,
              minWidth: 300.0,
              minHeight: 100.0
          ),
          margin: new EdgeInsets.all(20.0),
          padding: const EdgeInsets.all(20.0),
          color: Colors.teal.shade700,
          alignment: Alignment.center,
          child: Text('${document['name']}' + "  " + ('\$'.toString()) + '${document['price']}', style: TextStyle(fontSize: 20.0, color: Colors.white), textAlign: TextAlign.center),
        ),
      ],
    );
  }

}