import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'item_details.dart';
import '../item_information.dart';

class Feed extends StatefulWidget{

  @override
  _FeedState createState() => new _FeedState();
}

String _imageUrl = "";

class _FeedState extends State<Feed> {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(appBar: new AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: Search());

              },
            ),
          ],

          title: new Text("Search Feed"), backgroundColor: Colors.black38,) ,

          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),


          body: new StreamBuilder<QuerySnapshot>(


        stream: Firestore.instance.collection('allItems').orderBy("date", descending: true).snapshots(),
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
      child: new  StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('allItems').orderBy("date", descending: true).snapshots(),
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
      child: new  StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('allItems').orderBy("date", descending: true).snapshots(),
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
  ItemInfo itemInfo = new ItemInfo('${document['name']}','${document['description']}', '${document['address']}', '${document['author']}', '${document['degree']}', '${document['image']}', '${document['price']}', '${document['category']}', '${document['productID']}',  '${document['sellerEmail']}','${document['sellerID']}', '${document['status']}', '${document['date']}');
  return itemInfo;
}
