//SOURCE: https://github.com/putraxor/flutter-login-ui/tree/master/lib

import 'package:flutter/material.dart';
import 'signup.dart';
import '../authentication.dart';
import 'add_items.dart';
import 'nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(text:"");
  final passwordController = TextEditingController(text:"");
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 70.0,
        child: Image.asset('images/logo.png'),
      ),
    );
    final email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          // ADD LOGIC - change
          // Navigator.of(context).pushNamed(Categories.tag);

        signIn();

        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        // ADD LOGIC

      }
    );

    final newUserLabel = FlatButton(
    child: Text(
    'New here? Sign Up',
    style: TextStyle(color: Colors.black38),
    ),
    onPressed: () {
       Navigator.of(context).pushNamed(SignUp.tag);
     }
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('UWI MARKETPLACE'), backgroundColor: Colors.lightBlueAccent,),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            Row(
              children: <Widget>[
                Expanded (
                  child: forgotLabel,
                ),
                Expanded (
                  child: newUserLabel,
                ),
              ],

            )


          ],
        ),
      ),
    );

  }

  void signIn() async {
    try{
      FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      setUser(user);
      print('Signed in ${user.email}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NavBar()),
      );
    }
    catch(e){
      print('error: $e');
      setUser(null);
      _showAlert();
    }
  }

  void _showAlert(){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: new Text("Incorrect username / password"),
            content: new Text("The username or password entered is invalid."),
            actions: <Widget>[
              new FlatButton(onPressed: (){Navigator.of(context).pop();}, child: new Text("Try again"))
            ]
          );
        }
    );
  }



}
