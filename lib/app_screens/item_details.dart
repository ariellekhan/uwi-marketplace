import 'package:flutter/material.dart';
import '../item_information.dart';
import 'chat.dart';
import '../authentication.dart';
import 'nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDetails extends StatefulWidget {
  final ItemInfo itemInfo;
  ItemDetails({Key key, @required this.itemInfo}) : super(key: key);

  @override
  _ItemDetailsState createState() => new _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  @override
  initState() {
    super.initState();

    getDocument().then((doc) {
      setState(() {
        if (doc.exists) {
          iconState = Icon(
            Icons.favorite,
            color: Colors.red,
          );
          isFav = true;
        }
      });
    });
  }

  Icon iconState = Icon(
    Icons.favorite_border,
  );
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    String _imageUrl = widget.itemInfo.imageUrl;
    final img = Container(
      padding: EdgeInsets.only(right: 12.0),
      child: _imageUrl == ""
          ? Image.asset(
        'images/placeholder.png',
        height: 200.0,
        width: 200.0,
      )
          : Image.network(
        _imageUrl,
        height: 200.0,
        width: 200.0,
      ),
    );

    final name = Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          '${widget.itemInfo.name}',
          style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );

    final cost = Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          r'$' '${widget.itemInfo.price}',
          style: TextStyle(color: Colors.green, fontSize: 24),
        ),
      ),
    );

    final description = Center(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          'Description: ${widget.itemInfo.description}',
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
      ),
    );

    final author = Center(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          'Author: ${widget.itemInfo.author}',
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
      ),
    );

    final address = Center(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          'Address: ${widget.itemInfo.address}',
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
      ),
    );

    final proID = Center(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          'ID: ${widget.itemInfo.productID}',
          style: TextStyle(color: Colors.grey, fontSize: 14 ),
        ),
      ),
    );

    final orderButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          buyItem(context);
        },
        padding: EdgeInsets.all(12),
        color: Colors.orangeAccent,
        child: Text('Buy', style: TextStyle(color: Colors.white)),
      ),
    );

    final favIcon = new IconButton(
      icon: iconState,
      onPressed: () {
        setState(() {
          isFav = !isFav;
          if (isFav) {
            iconState = Icon(
              Icons.favorite,
              color: Colors.red,
            );
            addToFavourites();
          } else {
            iconState = Icon(
              Icons.favorite_border,
            );
            deleteFromFavourites();
          }
        });
      },
    );

    List<Widget> getItemDetails() {
      if (widget.itemInfo.category == "Text Book") {
        return <Widget>[
          img,
          SizedBox(height: 8.0),
          name,
          SizedBox(height: 24.0),
          author,
          SizedBox(height: 8.0),
          cost,
          SizedBox(height: 8.0),
          description,
          SizedBox(height: 8.0),
          favIcon,
          orderButton,
          proID,
        ];
      } else if (widget.itemInfo.category == "Dorm") {
        return <Widget>[
          img,
          SizedBox(height: 8.0),
          name,
          SizedBox(height: 24.0),
          address,
          SizedBox(height: 8.0),
          cost,
          SizedBox(height: 8.0),
          description,
          SizedBox(height: 8.0),
          favIcon,
          orderButton,
          proID,
        ];
      } else {
        return <Widget>[
          img,
          SizedBox(height: 8.0),
          name,
          SizedBox(height: 24.0),
          cost,
          SizedBox(height: 8.0),
          description,
          SizedBox(height: 8.0),
          favIcon,
          orderButton,
          proID,
        ];
      }
    }

    return new Scaffold(
      appBar: AppBar(
        title: Text("Item Details"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: getItemDetails(),
        ),
      ),
    );
  }

  void buyItem(BuildContext context) {
    String chatId = "";
    String myId = getUser().uid;
    String sellerID = widget.itemInfo.sellerID;
    String sellerEmail = widget.itemInfo.sellerEmail;

    if (myId.compareTo(sellerID) < 0) {
      chatId = '$myId-$sellerID';
    } else {
      chatId = '$sellerID-$myId';
    }

    String name = widget.itemInfo.name;
    String pID = widget.itemInfo.productID;
    String price = widget.itemInfo.price;
    String message =
        "I am interested in your item:\n\n[ Name: $name ]\n\n[ Cost: $price ]\n\n[ ProductID: $pID ]";

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NavBar(pageIndex: 3)),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Chat(
              chatId: chatId,
              peerEmail: sellerEmail,
              peerID: sellerID,
              msg: message)),
    );
  }

  Future addToFavourites() async {
    await Firestore.instance
        .collection('users')
        .document(getUser().email)
        .collection("myFavourites")
        .document(widget.itemInfo.productID)
        .setData({
      'address': widget.itemInfo.address,
      'author': widget.itemInfo.author,
      'category': widget.itemInfo.category,
      'date': widget.itemInfo.date,
      'degree': widget.itemInfo.degree,
      'description': widget.itemInfo.description,
      'image': widget.itemInfo.imageUrl,
      'name': widget.itemInfo.name,
      'price': widget.itemInfo.price,
      'productID': widget.itemInfo.productID,
      'sellerID': widget.itemInfo.sellerID,
      'sellerEmail': widget.itemInfo.sellerEmail,
      'status': 'unsold',
    });
  }

  Future deleteFromFavourites() async {
    await Firestore.instance
        .collection('users')
        .document(getUser().email)
        .collection('myFavourites')
        .document(widget.itemInfo.productID)
        .delete();
  }

  Future<DocumentSnapshot> getDocument() async {
    DocumentSnapshot ds;
    try {
      ds = await Firestore.instance
          .collection("users")
          .document(getUser().email)
          .collection('myFavourites')
          .document(widget.itemInfo.productID)
          .get();
    } catch (e) {
      ds = null;
    }
    return ds;
  }
}