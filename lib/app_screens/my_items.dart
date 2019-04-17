import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'item_details.dart';
import '../item_information.dart';
import '../authentication.dart';


class MyItems extends StatefulWidget {
  @override
  _MyItemsState createState() => new _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  String _imageUrl = "";

          @override
          Widget build(BuildContext context) {
        return new MaterialApp(
        home: new Scaffold(appBar: new AppBar(title: new Text("My Items"), backgroundColor: Colors.black38,) ,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),


        body: new StreamBuilder<QuerySnapshot>(


            stream: Firestore.instance
                .collection('users')
                .document(getUser().email)
                .collection('myItems')
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
        return Center(
        child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.red)));
        }
        else {
        return ListView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) =>
        buildItem(context, snapshot.data.documents[index]),
        itemCount: snapshot.data.documents.length,

        );
        }
        },
        ),
        )

        );
        }
            Widget buildItem(BuildContext context, DocumentSnapshot document){


    _imageUrl = '${document['image']}';
    return Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: RaisedButton(
    color: Color.fromRGBO(64, 75, 96, .9),
   /* onPressed: () {
    // ADD LOGIC
    ItemInfo itemInfo;
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => new ItemDetails(itemInfo: getItemInfo(document))),
    )
    }, */
    child:    ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
    padding: EdgeInsets.only(right: 12.0),

    child:_imageUrl == "" ? Image.asset('images/placeholder.png', height: 90.0,width: 100.0,)
        :Image.network(_imageUrl,height: 90.0, width: 100.0,),
    ),
    title: Text(
    '${document['name']}',
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
    ),

    subtitle: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new IconButton(
            icon: new Icon(Icons.arrow_forward),
            onPressed: () {
              // ADD LOGIC
              ItemInfo itemInfo;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new ItemDetails(itemInfo: getItemInfo(document))),
              );},
            color: Colors.green,
            // size: 30.0
          ),

          new IconButton(
            icon: new Icon(Icons.delete_forever),
            onPressed: () {
              _showDeleteAlert(document);
            },
            color: Colors.red,
            // size: 30.0
          ),
        ],
      ),
    ),

    ),

    ),
    );

    }


  void _showDeleteAlert(DocumentSnapshot document){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
              title: new Text("Permanently Delete Item"),
              content: new Text("Warning! This will remove your item completely from all instances in the marketplace."),
              actions: <Widget>[
                new FlatButton(onPressed: (){deleteItem(document);Navigator.of(context).pop();}, child: new Text("Delete")),
                new FlatButton(onPressed: (){Navigator.of(context).pop();}, child: new Text("Cancel"))
              ]
          );
        }
    );
  }

  Future deleteItem(DocumentSnapshot document) async{

    var id = document['productID'];
    String docID = id;
    var cat = document['category'];
    String category = cat;
    print(docID);
    //delete from myItems
    await Firestore.instance .collection('users')
        .document(getUser().email)
        .collection('myItems').document(docID).delete();

    //delete from allItems
    await Firestore.instance .collection('allItems').document(docID).delete();


    //delete from items
    await Firestore.instance .collection("items")
        .document("addItems")
        .collection(category)
        .document(docID).delete();
  }



    ItemInfo getItemInfo(DocumentSnapshot document){
      ItemInfo itemInfo = new ItemInfo('${document['name']}','${document['description']}', '${document['address']}', '${document['author']}', '${document['degree']}', '${document['image']}', '${document['price']}', '${document['category']}', '${document['productID']}',  '${document['sellerEmail']}','${document['sellerID']}', '${document['status']}', '${document['date']}');
      return itemInfo;
    }


  }

