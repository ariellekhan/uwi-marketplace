import 'package:flutter/material.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  DocumentSnapshot myProfile;

  @override
  initState() {
    super.initState();

    getDocument().then((doc) {
      setState(() {
        myProfile = doc;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new Container(),
        title: Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: myProfile == null
          ? Container(
              child: Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red))),
            )
          : buildProfile(myProfile),
    );
  }

  Future<DocumentSnapshot> getDocument() async {
    DocumentSnapshot ds = null;
    try {
      ds = await Firestore.instance
          .collection("users")
          .document(getUser().email)
          .collection('userInfo')
          .document(getUser().email)
          .get();
    } catch (e) {
      ds = null;
    }
    return ds;
  }

  Widget buildProfile(DocumentSnapshot document) {
    try {
      document['email'];
    } catch (e) {
      return Container(child: Text("No user data found "));
    }

    String _imageUrl = '${document['userImage']}';

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 70.0,
        child: _imageUrl == ""
            ? Image.asset(
                'images/profile.png',
              )
            : Image.network(_imageUrl),
      ),
    );

    final name = Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          '${document['name']}',
          style: TextStyle(color: Colors.green, fontSize: 24),
        ),
      ),
    );

    final email = Center(
      child: Text('Email: ${document['email']}'),
    );

    final phone = Center(
      child: Text('Phone: ${document['phone']}'),
    );

    final degree = Center(
      child: Text('Degree: ${document['major']}'),
    );

    final logoutButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          _signOut();
        },
        padding: EdgeInsets.all(12),
        color: Colors.green,
        child: Text('Log Out', style: TextStyle(color: Colors.white)),
      ),
    );

    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          logo,
          SizedBox(height: 8.0),
          name,
          SizedBox(height: 24.0),
          email,
          SizedBox(height: 8.0),
          phone,
          SizedBox(height: 8.0),
          degree,
          SizedBox(height: 24.0),
          logoutButton,
        ],
      ),
    );
  }

  Future<LoginPage> _signOut() async {
    await FirebaseAuth.instance.signOut();
    setUser(null);
    runApp(new MaterialApp(
      home: new LoginPage(),
    ));
  }
}
