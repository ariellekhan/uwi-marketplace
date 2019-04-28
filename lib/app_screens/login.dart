import 'package:flutter/material.dart';
import 'signup.dart';
import '../authentication.dart';
import 'nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");

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
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: _passwordController,
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
          _resetPassword();
        });

    final newUserLabel = FlatButton(
        child: Text(
          'New here? Sign Up',
          style: TextStyle(color: Colors.black38),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(SignUp.tag);
        });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('UWI MARKETPLACE'),
        backgroundColor: Colors.lightBlueAccent,
      ),
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
                Expanded(
                  child: forgotLabel,
                ),
                Expanded(
                  child: newUserLabel,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  //attempts to log in user
  void signIn() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (user.isEmailVerified) {
        setUser(user);
        print('Signed in ${user.email}');
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new NavBar()));
      } else {
        _showEmailVerificationAlert(user);
      }
    } catch (e) {
      print('error: $e');
      setUser(null);
      _showIncorrectAlert();
    }
  }



  //resets the user password
  void _resetPassword() {
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text)
        .then((doc) {
      String title = "Password Reset Email Sent";
      String myEmail = _emailController.text;
      String content =
          "Please check your email: $myEmail and follow the steps to reset your password";
      _showResetAlert(title, content);
    }).catchError((err) {
      String title = "Error Sending Email";
      String content =
          "Either no email or an invalid email was entered, please try again.";
      _showResetAlert(title, content);
    });
  }

  //Alert for when the user enters wrong information to log in with
  void _showIncorrectAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Incorrect username / password"),
              content: new Text("The username or password entered is invalid."),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("Try again"))
              ]);
        });
  }

  //alert for if the user isn't verified
  void _showEmailVerificationAlert(FirebaseUser fbuser) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Account Isn't Verified"),
              content: new Text(
                  "Please verify your account using the link that was previously sent to your email. Or you can request a new link from the option below."),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("Close")),
                new FlatButton(
                    onPressed: () {
                      fbuser.sendEmailVerification();
                      Navigator.of(context).pop();
                    },
                    child: new Text("Request Link"))
              ]);
        });
  }

  //alert for when the user request a password reset
  void _showResetAlert(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text(title),
              content: new Text(content),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("Close"))
              ]);
        });
  }
}
