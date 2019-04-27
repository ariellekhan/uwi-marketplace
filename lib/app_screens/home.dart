import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'item_details.dart';
import '../item_information.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

String _itemImageUrl = "";
String _favImageUrl = "";

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final body = new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
        elevation: 0.0,
        backgroundColor: Colors.pink,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                Icons.help_outline,
                color: Colors.white,
              ),
              onPressed: () {
                _showHelpAlert();
              })
        ],
      ),
      backgroundColor: Colors.white,
      body: new Container(
        child: new Stack(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(top: 10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Padding(
                        padding: new EdgeInsets.only(left: 8.0),
                        child: new Text(
                          'Favourites',
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  //favourites
                  new Container(
                    height: 250.0,
                    width: _width,
                    child: new StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('users')
                          .document(getUser().email)
                          .collection('myFavourites')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.red)));
                        } else {
                          return ListView.builder(
                            itemBuilder: (context, index) =>
                                buildFavouritesList(context,
                                    snapshot.data.documents[index], index),
                            itemCount: snapshot.data.documents.length,
                            scrollDirection: Axis.horizontal,
                          );
                        }
                      },
                    ),
                  ),
                  //myItems
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Padding(
                        padding: new EdgeInsets.only(left: 8.0),
                        child: new Text(
                          'My Items',
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  new Expanded(
                    child: new StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('users')
                          .document(getUser().email)
                          .collection("myItems")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.red)));
                        } else {
                          return ListView.separated(
                            itemBuilder: (context, index) => buildItemsList(
                                context, snapshot.data.documents[index]),
                            itemCount: snapshot.data.documents.length,
                            separatorBuilder: (context, index) => Divider(
                                  color: Colors.black,
                                ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return new Container(
      decoration: new BoxDecoration(
        color: const Color(0xFF273A48),
      ),
      child: new Stack(
        children: <Widget>[
          new CustomPaint(
            size: new Size(_width, _height),
          ),
          body,
        ],
      ),
    );
  }

  Widget buildFavouritesList(
      BuildContext context, DocumentSnapshot document, index) {
    _favImageUrl = '${document['image']}';
    String itemName = '${document['name']}';
    if (itemName.length > 15) {
      itemName = itemName.substring(0, 14) + '...';
    }

    EdgeInsets padding = index == 0
        ? const EdgeInsets.only(left: 20.0, right: 10.0, top: 4.0, bottom: 60.0)
        : const EdgeInsets.only(
            left: 10.0, right: 10.0, top: 4.0, bottom: 60.0);

    return new Padding(
      padding: padding,
      child: new InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    new ItemDetails(itemInfo: getItemInfo(document))),
          );
        },
        child: new Container(
          height: 200.0,
          width: 150.0,
          child: new Stack(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(4.0),
                  color: const Color(0xFF273A48),
                  width: 160,
                  height: 200.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: _favImageUrl == ""
                        ? Image.asset(
                            'images/placeholder.png',
                            height: 96.0,
                            width: 96.0,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: _favImageUrl,
                            height: 96.0,
                            width: 96.0,
                            fit: BoxFit.cover,
                          ),
                  )),
              new Align(
                alignment: Alignment.bottomCenter,
                child: new Container(
                    decoration: new BoxDecoration(
                        color: const Color(0xFF273A48),
                        borderRadius: new BorderRadius.only(
                            bottomLeft: new Radius.circular(10.0),
                            bottomRight: new Radius.circular(10.0))),
                    height: 50.0,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          itemName,
                          style: new TextStyle(color: Colors.white),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItemsList(BuildContext context, DocumentSnapshot document) {
    _itemImageUrl = '${document['image']}';
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
            padding: EdgeInsets.all(4.0),
            height: 72.0,
            width: 72.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: _itemImageUrl == ""
                  ? Image.asset(
                      'images/placeholder.png',
                      height: 96.0,
                      width: 96.0,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: _itemImageUrl,
                      height: 96.0,
                      width: 96.0,
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
                      fontSize: 12.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
          ],
        )),
        new IconButton(
          icon: new Icon(Icons.arrow_forward),
          onPressed: () {
            // ADD LOGIC
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      new ItemDetails(itemInfo: getItemInfo(document))),
            );
          },
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
    );
  }

  void _showDeleteAlert(DocumentSnapshot document) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Permanently Delete Item"),
              content: new Text(
                  "Warning! This will remove your item completely from all instances in the marketplace."),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      deleteItem(document);
                      Navigator.of(context).pop();
                    },
                    child: new Text("Delete")),
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("Cancel"))
              ]);
        });
  }

  Future deleteItem(DocumentSnapshot document) async {
    var id = document['productID'];
    String docID = id;
    var cat = document['category'];
    String category = cat;
    print(docID);
    //delete from myItems
    await Firestore.instance
        .collection('users')
        .document(getUser().email)
        .collection('myItems')
        .document(docID)
        .delete();

    //delete from allItems
    await Firestore.instance.collection('allItems').document(docID).delete();

    //delete from items
    await Firestore.instance
        .collection("items")
        .document("addItems")
        .collection(category)
        .document(docID)
        .delete();
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

  void _showHelpAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Help"),
              content: new Text(
                  "1. To list an item for sale, Navigate to Categories and click on the icon at the top right of the app bar.\n\n2. To Favourite an item, click on the heart icon on the item details page"),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("Close"))
              ]);
        });
  }
}
