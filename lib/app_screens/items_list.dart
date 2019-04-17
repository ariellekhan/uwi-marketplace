import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'item_details.dart';
import '../item_information.dart';

String _category;
String _title;

class AllItems extends StatefulWidget{
  final String value;
  AllItems({Key key, this.value}) : super(key: key);

  @override
  _AllItemsState createState() => new _AllItemsState();

}
String _imageUrl = "";

class _AllItemsState extends State<AllItems>{

  @override
  initState() {
    super.initState();

    _category = "${widget.value}";
    if("${widget.value}" == "Stationery"){
      _title = "Stationery";
    }
    else  if("${widget.value}" == "Dorm"){
      _title = "Dorm Essentials";
    }
    else  if("${widget.value}" == "Text Book"){
      _title = "Books";
    }
    else  if("${widget.value}" == "Electronics"){
      _title = "Electronics";
    }
    else  if("${widget.value}" == "Special Equipment"){
      _title = "Special Equipment";
    }
    else{
      _title = "Misc. Items";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(appBar: new AppBar(
        title: Text("Search " + _title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: Search());

            },
          ),
        ],) ,
        // backgroundColor: Color.fromRGBO(58, 66, 86, 1.0) ,

        body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('items').document('addItems').collection(_category).snapshots(),
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

}





ItemInfo getItemInfo(DocumentSnapshot document){
  ItemInfo itemInfo = new ItemInfo('${document['name']}','${document['description']}', '${document['address']}', '${document['author']}', '${document['degree']}', '${document['image']}', '${document['price']}', '${document['category']}', '${document['productID']}', '${document['sellerEmail']}', '${document['sellerID']}', '${document['status']}', '${document['date']}');
  return itemInfo;


}


Widget buildItem(BuildContext context, DocumentSnapshot document){
  if(document == null){
    return Container();
  }
  _imageUrl = '${document['image']}';
  return Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: RaisedButton(
      // color: Color.fromRGBO(64, 75, 96, .9),
      color: Colors.white70,
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
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
          ),

          subtitle: Row(
            children: <Widget>[
              Icon(Icons.attach_money, color: Colors.green),
              Text('${document['price']}', style: TextStyle(color: Colors.green))
            ],
          ),
          trailing:
          Icon(Icons.favorite_border, color: Colors.grey, size: 30.0)),
    ),
  );


}
class Search extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () {
        query = "";
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,),
        onPressed: () {
          close(context, null);

        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('items').document('addItems').collection(_category).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(query.isEmpty){
            return Container();
          }
          else if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)));
          }
          else {
            final results = snapshot.data.documents.where((doc) => doc["price"].toString().toLowerCase().contains(query.toLowerCase()) || doc["name"].toString().toLowerCase().contains(query.toLowerCase()) ).toList();
            if(results.length <=0){
              return Text("No Item found");
            }

            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) =>
                  buildItem(context, results[index]),
              itemCount: results.length,

            );
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('items').document('addItems').collection(_category).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(query.isEmpty){
            return Container();
          }
          else if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)));
          }
          else {
            final results = snapshot.data.documents.where((doc) => doc["price"].toString().toLowerCase().contains(query.toLowerCase()) || doc["name"].toString().toLowerCase().contains(query.toLowerCase()) ).toList();
            if(results.length <=0){
              return Text("No Item found");
            }

            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) =>
                  buildItem(context, results[index]),
              itemCount: results.length,

            );
          }
        },
      ),
    );
  }



}
