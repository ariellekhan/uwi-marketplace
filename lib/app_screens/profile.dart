import 'package:flutter/material.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 70.0,
        child: Image.asset('images/profile.png'),
      ),
    );

    final name = Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          "Jane Doe",
          style: TextStyle(color: Colors.green, fontSize: 24),
        ),
      ),
    );

    final email = Center(
      child: Text("Email: jane.doe@my.uwi.edu"),
    );

    final phone = Center(
      child: Text("Phone: 868-234-5678"),
    );

    final degree = Center(
      child: Text("Degree: B.Sc. Environmental Science"),
    );

    final logoutButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          // ADD LOGIC - change
          // Navigator.of(context).pushNamed(Categories.tag);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        padding: EdgeInsets.all(12),
        color: Colors.green,
        child: Text('Log Out', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.green,
      ),
      body: Center(
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
      ),
    );
  }
}
