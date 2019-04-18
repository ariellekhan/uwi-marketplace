import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:image_picker/image_picker.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart' as random;
import '../authentication.dart';
import 'nav_bar.dart';
import 'package:ntp/ntp.dart';

class ItemForm extends StatefulWidget {
  static String tag = 'item-form';

  @override
  _ItemFormState createState() => new _ItemFormState();
}
class _ItemFormState extends State<ItemForm> {



  var _itemTypes = [
    "Type of Item",
    "Text Book",
    "Stationery",
    "Dorm",
    "Electronics",
    "Special Equipment",
    "Miscellaneous"
  ];

  var _currentItemSelected = "Type of Item";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _description;
  String _category = '';
  String _author = '';
  String _name = '';
  String _price = '';
  String _degree = '';
  String _address = '';
  File _itemImage;
  String _imageUrl;

  DateTime _currentTime;
  DateTime _ntpTime;
  int _ntpOffset;

  @override
  Widget build(BuildContext context) {
    final desc = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Item Description',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val) {
        _description = val;
      },
    );


    final name = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Item Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val) {
        _name = val;
      },
    );

    final degree = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Related Degree',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val) {
        _degree = val;
      },
    );

    final price = TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Item Cost',
        prefixText: '\$',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val) {
        _price = val;
      },
    );

    final author = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Book Author',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val) {
        _author = val;
      },
    );

    final address = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Dorm Address',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val) {
        _address = val;
      },
    );

    final heading = Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        "List an Item",
        style: TextStyle(color: Colors.lightBlueAccent, fontSize: 24),
      ),
    );

    final dropButton = DropdownButton<String>(
      items: _itemTypes.map((String dropDownStringItem) {
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),
      onChanged: (String newValueSelected) {
        _category = newValueSelected;
        // Your code to execute, when a menu item is selected from drop down
        _onDropDownItemSelected(newValueSelected);
      },
      value: _currentItemSelected,
    );

    final uploadBtn = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Select Image', style: TextStyle(color: Colors.white)),
        onPressed: getImage,
      ),
    );

    final submitBtn = Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(12),
        onPressed: () {
          _validateInputs();
          _uploadToFirestore().then((_) {
            _showAlert("Success", "Item was uploaded");
            _itemImage = null;
          }).catchError((e) {
            _showAlert("Failed", "Item was not uploaded");
          });
        },
        color: Colors.lightBlueAccent,
        child: Text('Submit', style: TextStyle(color: Colors.white)),
      ),
    );

    var itemCategoryList;
    if (_currentItemSelected == "Text Book") {
      itemCategoryList = ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          author,
          SizedBox(height: 8.0),
          name,
          SizedBox(height: 8.0),
          desc,
          SizedBox(height: 8.0),
          price,
          SizedBox(height: 8.0),
          degree,
          SizedBox(height: 8.0),
        ],
      );
    } else if (_currentItemSelected == "Stationery" ||
        _currentItemSelected == "Electronics" ||
        _currentItemSelected == "Special Equipment" ||
        _currentItemSelected == "Miscellaneous") {
      itemCategoryList = ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          name,
          SizedBox(height: 8.0),
          desc,
          SizedBox(height: 8.0),
          price,
          SizedBox(height: 8.0),
        ],
      );
    } else if (_currentItemSelected == "Dorm") {
      itemCategoryList = ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          name,
          SizedBox(height: 8.0),
          desc,
          SizedBox(height: 8.0),
          price,
          SizedBox(height: 8.0),
          address,
          SizedBox(height: 8.0),
        ],
      );
    } else {
      itemCategoryList = Container();
    }

    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Add Item'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              heading,
              SizedBox(height: 8.0),
              dropButton,
              itemCategoryList,
              _currentItemSelected != 'Type of Item'
                  ? (_itemImage == null ? placeholderImage() : uploadedImage())
                  : (Container()),
              _currentItemSelected != 'Type of Item'
                  ? (uploadBtn)
                  : (Container()),
              _currentItemSelected != 'Type of Item'
                  ? (submitBtn)
                  : (Container()),
            ],
          ),
        ),
      ),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  //adds items collection to firebase
  void addToDatabase() {
    String dateNow = _ntpTime.toString();

    String documentID = Firestore.instance //get documentID
        .collection("allItems")
        .document().documentID;

    String userID = getUser().uid; //get userID
    String userEmail = getUser().email; //get user email
    //json of the product's information to be stored
    Map<String, dynamic> productData = {
      'address': _address,
      'author': _author,
      'category': _category,
      'date': dateNow,
      'degree': _degree,
      'description': _description,
      'image': _imageUrl,
      'name': _name,
      'price': _price,
      'productID': documentID,
      'sellerID': userID,
      'sellerEmail': userEmail,
      'status': 'unsold',};

    //add to allItems
    Firestore.instance
        .collection("allItems")
        .document(documentID)
        .setData(productData);

    //add to addItems
    Firestore.instance
        .collection("items")
        .document("addItems")
        .collection(_category)
        .document(documentID)
        .setData(productData);

    //adds to userItems
    Firestore.instance
        .collection("users")
        .document(userEmail)
        .collection("myItems")
        .document(documentID)
        .setData(productData);

  }


  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  } // _validateInputs

  //gets image from device
  Future getImage() async {
    var deviceImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _itemImage = deviceImage;
    });
  }

  Widget uploadedImage() {
    return Container(
        child: Column(children: <Widget>[
      Image.file(_itemImage, height: 100.0, width: 100.0),
    ]));
  }

  Widget placeholderImage() {
    return Container(
        child: Column(children: <Widget>[
      Image.asset(
        'images/placeholder.png',
        height: 100.0,
        width: 100.0,
      )
    ]));
  }

//returns the downloaded url
  Future addImageToFirebase(String imageName, File file) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("itemImages/" + imageName);
    final StorageUploadTask task = firebaseStorageRef.putFile(file);
    var downUrl = await (await task.onComplete).ref.getDownloadURL();
    _imageUrl = downUrl;
  }

  void _showAlert(String _t, String _c) {
    _itemImage = null;
    _imageUrl = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(_t),
            content: new Text(_c.toString()),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new NavBar()),
                  );
                },
                child: new Text("close"),
              )
            ],
          );
        });
  }

  Future _uploadToFirestore() async {
    if (_itemImage != null) {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      addImageToFirebase(imageName, _itemImage).then((_) {

        _updateTime().then((_) {
          addToDatabase();
        }).catchError((e) {});



      }).catchError((e) {});
    } else {
      _imageUrl = "";
      _updateTime().then((_) {
        addToDatabase();
      }).catchError((e) {});

    }
  }


  Future _updateTime() async {
    _currentTime = DateTime.now();
   await NTP.getNtpOffset().then((value) {
      setState(() {
        _ntpOffset = value;
        _ntpTime = _currentTime.add(Duration(milliseconds: _ntpOffset));
      });
    });
  }
}



