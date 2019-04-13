import 'package:flutter/material.dart';
import '../item_information.dart';
import 'chat.dart';
import '../authentication.dart';
import '../user.dart';


class ItemDetails extends StatefulWidget{
  final ItemInfo itemInfo;
  ItemDetails({Key key, @required this.itemInfo}) : super(key: key);

  @override
  _ItemDetailsState createState() => new _ItemDetailsState();

}

class _ItemDetailsState extends State<ItemDetails> {
  @override
  Widget build(BuildContext context) {
    String _imageUrl = widget.itemInfo.imageUrl;
    final img = Container(
        padding: EdgeInsets.only(right: 12.0),

        child:_imageUrl == "" ? Image.asset('images/placeholder.png', height: 200.0,width: 200.0,)
            :Image.network(_imageUrl,height: 200.0, width: 200.0,),
      );

    final name = Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          '${widget.itemInfo.name}',
          style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 24),
        ),
      ),
    );

    final cost = Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
            r'$''${widget.itemInfo.price}',
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


    final orderButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          buyItem();
        },
        padding: EdgeInsets.all(12),
        color: Colors.orangeAccent,
        child: Text('Buy', style: TextStyle(color: Colors.white)),
      ),
    );

List<Widget> getItemDetails(){
  if(widget.itemInfo.category == "Text Book" ){
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

      orderButton,
    ];
  }
  else  if(widget.itemInfo.category == "Dorm" ){
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

      orderButton,
    ];
}
  else {
    return <Widget>[
      img,
      SizedBox(height: 8.0),
      name,
      SizedBox(height: 24.0),
      cost,
      SizedBox(height: 8.0),
      description,
      SizedBox(height: 8.0),

      orderButton,
    ];
  }
}
    return Scaffold(
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


  void buyItem(){
    String chatId ="";
    String myId = getUser().uid;
    String sellerID = widget.itemInfo.sellerID;
    String sellerEmail = widget.itemInfo.sellerEmail;


    if(myId.compareTo(sellerID) < 0){
      chatId = '$myId-$sellerID';
    }else{
      chatId = '$sellerID-$myId';
    }
    //User peer = new User();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new Chat(chatId: chatId, peerEmail: sellerEmail, peerID: sellerID)),
    );

  }
}
