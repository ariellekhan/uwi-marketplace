import 'package:flutter/material.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  static String tag = 'signup-page';
  @override
  _SignUpState createState() => new _SignUpState();
}

class _SignUpState extends State<SignUp> {

  // dropdown menu lists
  List _degreeLevels = ["B.A.", "B.Sc.", "M.A.", "M.Sc.", "MBA", "M.Phil.", "Ph.D.", "M.D", "DDS"];
  List _faculties = [
    "Science and Technology",
    "Food and Agriculture",
    "Humanities and Education",
    "Medical Sciences",
    "Engineering",
    "Social Sciences",
    "Law",
  ];

  @override
  Widget build(BuildContext context) {

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Student Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
//      validator: (value) {
//        if (value.isEmpty) {
//          return 'Please enter some text';
//        }
//      },
    );

    final name = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final phone = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Phone Number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final major = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Degree Major',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );


    final signupButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(LoginPage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Sign Up!', style: TextStyle(color: Colors.white)),
      ),
    );

    final heading = Padding (
      padding: EdgeInsets.all(10.0),
      child: Text("Create an Account",
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
        }
    );


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('UWI MARKETPLACE'), backgroundColor: Colors.lightBlueAccent,),
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
                Expanded (
                  child: name,
                ),
                Expanded (
                  child: Padding(
                    padding: const EdgeInsets.only(left:8),
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
    );

  }
}