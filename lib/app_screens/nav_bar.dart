import 'package:flutter/material.dart';
import 'messages.dart';
import 'feed.dart';
import 'profile.dart';
import 'categories.dart';
import 'home.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => new _NavBarState();
}

class _NavBarState extends State<NavBar> {

  //For bottom navigation bar
  int currentTabIndex = 2;
  List<Widget> tabs = [
    Feed(),
    Categories(),
    Home(),
    Messages(),
    Profile(),
  ];

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(

        body: tabs[currentTabIndex],

        bottomNavigationBar: BottomNavigationBar(
          onTap: onTapped,
          currentIndex: currentTabIndex,
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.rss_feed),
              backgroundColor: Colors.black38,
              title: new Text('Feed'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.purple,
              icon: new Icon(Icons.category),
              title: new Text('Categories'),
            ),
            BottomNavigationBarItem(
                backgroundColor: Colors.pink,
                icon: Icon(Icons.home),
                title: Text('Home')
            ),
            BottomNavigationBarItem(
                backgroundColor: Colors.lightBlueAccent,
                icon: Icon(Icons.mail),
                title: Text('Messages')
            ),
            BottomNavigationBarItem(
                backgroundColor: Colors.lightBlueAccent,
                icon: Icon(Icons.person),
                title: Text('Profile')
            ),
          ],
        ),


      );
}