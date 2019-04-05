import 'package:flutter/material.dart';
import '../authentication.dart';
import 'add_items.dart';

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

        body: Container(
          child:
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              onPressed: () {
                // ADD LOGIC - change
                // Navigator.of(context).pushNamed(Categories.tag);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new ItemForm()),
                );
              },
              padding: EdgeInsets.all(12),
              color: Colors.green,
              child: Text('Add Items', style: TextStyle(color: Colors.white)),
            ),
          ),
        )
  );

}
