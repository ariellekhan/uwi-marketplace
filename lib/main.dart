import 'package:flutter/material.dart';
import './app_screens/home.dart';
import './app_screens/login.dart';
import './app_screens/signup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
//  final routes = <String, WidgetBuilder>{
//    LoginPage.tag: (context) => LoginPage(),
//    HomePage.tag: (context) => HomePage(),
//  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UWI Marketplace',
        home: LoginPage()
//        routes: routes,
    );
  }
}
