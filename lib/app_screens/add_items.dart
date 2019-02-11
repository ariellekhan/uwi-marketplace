import 'package:flutter/material.dart';

class ItemForm extends StatefulWidget {
  static String tag = 'item-form';

  @override
  _ItemFormState createState() => new _ItemFormState();
}

class _ItemFormState extends State<ItemForm>{
  var _itemTypes = [
    "Type of Item",
    "Text Book",
    "Stationery",
    "Dorm",
    "Electronics",
    "Special Equipment",
    "Miscellaneous"
  ];



  bool _visible = false;
  bool _visible2 = false;

  // Visibility visible;

  var _currentItemSelected = "Type of Item";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _desc = '';
  String _items = '';
  String _author = '';
  String _name = '';
  String _price = '';
  String _degree = '';
  String _address = '';

  @override
  Widget build(BuildContext context) {
    final desc = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Item Description',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val)
      {
        _desc = val;
      },

    );

    final items = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Item Description',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val)
      {
        _items = val;
      },

    );

    final name = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Item Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val)
      {
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
      onSaved: (String val)
      {
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


      onSaved: (String val)
      {
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
      onSaved: (String val)
      {
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
      onSaved: (String val)
      {
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
        // Your code to execute, when a menu item is selected from drop down
        _onDropDownItemSelected(newValueSelected);
      },

      value: _currentItemSelected,



    );

    final uploadBtn = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Upload Image', style: TextStyle(color: Colors.white)),
      ),
    );

    final submitBtn = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0,),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Submit', style: TextStyle(color: Colors.white)),
      ),
    );


    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('UWI MARKETPLACE'),
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

              AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                //SizedBox(height: 8.0),
                child:
                author,

              ),


              SizedBox(height: 8.0),
              name,
              SizedBox(height: 8.0),
              desc,
              SizedBox(height: 8.0),
              price,
              SizedBox(height: 8.0),
              AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                //SizedBox(height: 8.0),
                child:
                degree,

              ),
              SizedBox(height: 8.0),
              AnimatedOpacity(
                opacity: _visible2 ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                //SizedBox(height: 8.0),
                child:
                address,

              ),
              uploadBtn,
              submitBtn,



            ],
          ),
        ),
      ),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
      if (_currentItemSelected == "Text Book"){
        _visible = true; } else

        _visible = false;

      if (_currentItemSelected == "Dorm"){
        _visible2 = true; } else

        _visible2 = false;

    });
  }
}