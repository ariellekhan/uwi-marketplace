import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import "package:image_picker/image_picker.dart";
import 'package:random_string/random_string.dart' as random;
import 'package:firebase_storage/firebase_storage.dart';

class SignUp extends StatefulWidget {
  static String tag = 'signup-page';

  @override
  _SignUpState createState() => new _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _myController = TextEditingController();
  final _myController2 = TextEditingController();
  File _userImage;
  String _imageUrl;

//  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _name;
  String _phone;
  String _major;
  String _password;

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      controller: _myController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Student Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      validator: _validateEmail,
      onSaved: (String val) {
        _email = val;
      },
    );

    final name = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        hintText: "Name",
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
      controller: _myController2,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      validator: _validatePassword,
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

    final uploadBtn = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child:
            Text('Upload Profile Image', style: TextStyle(color: Colors.white)),
        onPressed: getImage,
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
              _userImage == null ? placeholderImage() : uploadedImage(),
              uploadBtn,
              signupButton,
              accountLabel,
            ],
          ),
        ),
      ),
    );
  }

  //validates if email is in the format of a uwi email
  String _validateEmail(String value) {
    if (!value.endsWith("@my.uwi.edu") && !value.endsWith("@sta.uwi.edu")) {
      print('Enter Valid UWI Email');
      return 'Enter Valid UWI Email';
    } else {
      return null;
    }
  } // validateEmail

  //validates that the password isn't too short
  String _validatePassword(String value) {
    if (value.length < 8) {
      return ("Password must be atleast 8 characters");
    } else {
      return null;
    }
  }

  //Validate inputs in sign-up form
  void _validateInputs() async {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      await _createAccount(); //creates a firebase account
    }
  } // _validateInputs

  //Creates a user account through firebase
  Future _createAccount() async {
    try {
      FirebaseUser fbuser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _myController.text, password: _myController2.text);

      fbuser.sendEmailVerification(); //sends verification email
      //Add user info to firebase
      await _uploadToFirestore().then((_) {
        _showAlert("User Created", "Sign up Successful", true);
      }).catchError((e) {});
    } catch (e) {
      if (e.toString().contains("ERROR_EMAIL_ALREADY_IN_USE")) {
        String title = "Email Already In Use";
        String content =
            "This email already belongs to an existing account, please sign up using another email.";
        _showAlert(title, content, false);
      } else {
        String title = "Sign Up Failed";
        String content = "Something went wrong, please try again.";
        _showAlert(title, content, false);
      }
    }
  }

  //uploads data to the firestore
  Future _uploadToFirestore() async {
    if (_userImage != null) {
      addImageToFirebase(random.randomString(10), _userImage).then((_) {
        addToDatabase();
      }).catchError((e) {});
    } else {
      _imageUrl = "";
      addToDatabase();
    }
  }

  //adds user info to firebase
  Future addToDatabase() async {
    await Firestore.instance
        .collection('users')
        .document(_email)
        .collection("userInfo")
        .document(_email)
        .setData({
      'name': _name,
      'email': _email,
      'phone': _phone,
      'major': _major,
      'userImage': _imageUrl
    });
  }

  //adds the image to firebase
  Future addImageToFirebase(String imageName, File file) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("userImages/" + imageName);
    final StorageUploadTask task = firebaseStorageRef.putFile(file);
    var downUrl = await (await task.onComplete).ref.getDownloadURL();
    _imageUrl = downUrl;
  }

  //gets image from device
  Future getImage() async {
    var deviceImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _userImage = deviceImage;
    });
  }

  //displays image
  Widget uploadedImage() {
    return Container(
        child: Column(children: <Widget>[
      Image.file(_userImage, height: 100.0, width: 100.0),
    ]));
  }

  //creates a placeholder image if no image is uploaded
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

  //pop up alert
  void _showAlert(String title, String content, bool isSuccess) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(content),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  if (isSuccess) {
                    _userImage = null;
                    _imageUrl = "";
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(LoginPage.tag);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: new Text("close"),
              )
            ],
          );
        });
  }
}
