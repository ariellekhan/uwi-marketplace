import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../authentication.dart';

class SignUp extends StatefulWidget {
  static String tag = 'signup-page';

  @override
  _SignUpState createState() => new _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth mAuth;
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  // dropdown menu lists
  List _degreeLevels = [
    "B.A.",
    "B.Sc.",
    "M.A.",
    "M.Sc.",
    "MBA",
    "M.Phil.",
    "Ph.D.",
    "M.D",
    "DDS"
  ];
  List _faculties = [
    "Science and Technology",
    "Food and Agriculture",
    "Humanities and Education",
    "Medical Sciences",
    "Engineering",
    "Social Sciences",
    "Law",
  ];

//  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _email;
  String _name;
  String _phone;
  String _major;
  String _password;

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      controller: myController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Student Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      validator: validateEmail,
      onSaved: (String val) {
        _email = val;
      },
    );

    final name = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val) {
        _name = val;
      },
    );

    final phone = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Phone Number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val) {
        _phone = val;
      },
    );

    final major = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Degree Major',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val) {
        _major = val;
      },
    );

    final password = TextFormField(
      controller: myController2,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (String val) {
        _password = val;
      },
    );

    final signupButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
//        onPressed: () {
//          Navigator.of(context).pushNamed(LoginPage.tag);
//        },
        onPressed: _validateInputs,
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Sign Up!', style: TextStyle(color: Colors.white)),
      ),

    );

    final heading = Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        "Create an Account",
        style: TextStyle(color: Colors.lightBlueAccent, fontSize: 24),
      ),
    );

    final accountLabel = FlatButton(
        child: Text(
          'Have an account? Login',
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(LoginPage.tag);
        });

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
              SizedBox(height: 24.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: name,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: phone,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              email,
              SizedBox(height: 8.0),
              major,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              signupButton,
              accountLabel,
            ],
          ),
        ),
      ),
    );
  }

  String validateEmail(String value) {
//    Pattern pattern =
//        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//    RegExp regex = new RegExp(pattern);
//    if (!regex.hasMatch(value))
//      return 'Enter Valid Email';
    if(!value.endsWith("@my.uwi.edu") && !value.endsWith("@sta.uwi.edu")) {
      print('Enter Valid UWI Email');
      return 'Enter Valid UWI Email';
    }
    else{
      return null;
    }
  } // validateEmail

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      handleCreateUser(myController.text, myController2.text);

      //Add user info to firebase
      Firestore.instance.collection('users').document(_email).setData(
          { 'name': _name,
            'email': _email,
            'phone': _phone,
            'major': _major
          });
      Navigator.of(context).pushNamed(LoginPage.tag);
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  } // _validateInputs

}

