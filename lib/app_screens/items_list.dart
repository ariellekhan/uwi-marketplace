import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'item_details.dart';
import '../item_information.dart';

class AllItems extends StatefulWidget{
  final String value;
  AllItems({Key key, this.value}) : super(key: key);

  @override
  _AllItemsState createState() => new _AllItemsState();

}
String _imageUrl = "";

class _AllItemsState extends State<AllItems>{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(appBar: new AppBar(title: new Text("${widget.value}"), backgroundColor: Colors.black38,) ,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),

        body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('items').document('addItems').collection("${widget.value}").snapshots(),
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
        onPressed: () {
          // ADD LOGIC
          ItemInfo itemInfo;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => new ItemDetails(itemInfo: getItemInfo(document))),
          );
        },
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

            subtitle: Row(
              children: <Widget>[
                Icon(Icons.attach_money, color: Colors.green),
                Text('${document['price']}', style: TextStyle(color: Colors.greenAccent))
              ],
            ),
            trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)),
      ),
    );

  }


  ItemInfo getItemInfo(DocumentSnapshot document){
    ItemInfo itemInfo = new ItemInfo('${document['name']}','${document['description']}', '${document['address']}', '${document['author']}', '${document['degree']}', '${document['image']}', '${document['price']}', '${document['category']}', '${document['productID']}', '${document['sellerEmail']}', '${document['sellerID']}', '${document['status']}', '${document['date']}');
    return itemInfo;
  }






}

