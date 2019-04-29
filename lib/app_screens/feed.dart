import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'item_details.dart';
import '../item_information.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => new _FeedState();
}

String _imageUrl = "";

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new Container(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: Search());
            },
          ),
        ],
        title: Text(
          'Search Feed',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('allItems')
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)));
          } else {
            return ListView.separated(
              itemBuilder: (context, index) =>
                  buildItemsList(context, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
            );
          }
        },
      ),
    );
  }
}

class Search extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: Colors.white,
      child: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('allItems')
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (query.isEmpty) {
            return Container();
          } else if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)));
          } else {
            final results = snapshot.data.documents
                .where((doc) =>
                    doc["price"]
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    doc["name"]
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .toList();
            if (results.length <= 0) {
              return Text("No Item found");
            }

            return ListView.separated(
              itemBuilder: (context, index) =>
                  buildItemsList(context, results[index]),
              itemCount: results.length,
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Colors.white,
      child: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('allItems')
            .orderBy("date", descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (query.isEmpty) {
            return Container();
          } else if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)));
          } else {
            final results = snapshot.data.documents
                .where((doc) =>
                    doc["price"]
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    doc["name"]
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .toList();
            if (results.length <= 0) {
              return Text("No Item found");
            }

            return ListView.separated(
              itemBuilder: (context, index) =>
                  buildItemsList(context, results[index]),
              itemCount: results.length,
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
            );
          }
        },
      ),
    );
  }
}

Widget buildItemsList(BuildContext context, DocumentSnapshot document) {
  _imageUrl = '${document['image']}';
  return new Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Container(
          padding: EdgeInsets.all(4.0),
          height: 90.0,
          width: 100.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: _imageUrl == ""
                ? Image.asset(
                    'images/placeholder.png',
                    height: 96.0,
                    width: 100.0,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    _imageUrl,
                    height: 96.0,
                    width: 100.0,
                    fit: BoxFit.cover,
                  ),
          )),
      new SizedBox(
        width: 8.0,
      ),
      new Expanded(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            '${document['name']}',
            style: new TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          new Row(
            children: <Widget>[
              new Icon(Icons.attach_money, color: Colors.green),
              new Text(
                '${document['price']}',
                style: new TextStyle(
                    fontSize: 16.0,
                    color: Colors.green,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
        ],
      )),
      new IconButton(
        icon: new Icon(
          Icons.arrow_right,
          size: 40.0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    new ItemDetails(itemInfo: getItemInfo(document))),
          );
        },
        color: Colors.grey,
        padding: new EdgeInsets.all(0.0),
      ),
      new SizedBox(
        width: 8.0,
      ),
    ],
  );
}

ItemInfo getItemInfo(DocumentSnapshot document) {
  ItemInfo itemInfo = new ItemInfo(
      '${document['name']}',
      '${document['description']}',
      '${document['address']}',
      '${document['author']}',
      '${document['degree']}',
      '${document['image']}',
      '${document['price']}',
      '${document['category']}',
      '${document['productID']}',
      '${document['sellerEmail']}',
      '${document['sellerID']}',
      '${document['status']}',
      '${document['date']}');
  return itemInfo;
}
