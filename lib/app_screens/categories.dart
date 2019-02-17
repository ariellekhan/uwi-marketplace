import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _CategoriesState createState() => new _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Categories"),
      backgroundColor: Colors.lightBlueAccent,
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: 0, // this will be set when a new tab is tapped
      fixedColor: Colors.deepPurple,
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.mail),
          title: new Text('Messages'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile')
        ),
//            BottomNavigationBarItem(
//                icon: Icon(Icons.person),
//                title: Text('Profile')
//            ),
//            BottomNavigationBarItem(
//                icon: Icon(Icons.person),
//                title: Text('Profile')
//            ),
      ],
    ),

    body: ListView(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Row 1
        Row(children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () => {},
                color: Colors.green,
                padding: EdgeInsets.all(60.0),
                child: Column(
                  // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                    Icon(Icons.chrome_reader_mode),
                    Text(
                      "Textbooks",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () => {},
                color: Colors.orange,
                padding: EdgeInsets.all(60.0),
                child: Column(
                  // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                    Icon(Icons.create),
                    Text(
                      "Stationery",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),

        //Row 2
        Row(children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () => {},
                color: Colors.purple,
                padding: EdgeInsets.all(60.0),
                child: Column(
                  // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                    Icon(Icons.hotel),
                    Text(
                      "Dorm Essentials",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () => {},
                color: Colors.yellow,
                padding: EdgeInsets.all(60.0),
                child: Column(
                  // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                    Icon(Icons.laptop_chromebook),
                    Text(
                      "Electronic Devices",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),

        //Row 3
        Row(children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () => {},
                color: Colors.blue,
                padding: EdgeInsets.all(60.0),
                child: Column(
                  // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                    Icon(Icons.school),
                    Text(
                      "Special Equipment",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () => {},
                color: Colors.pink,
                padding: EdgeInsets.all(60.0),
                child: Column(
                  // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                    Icon(Icons.category),
                    Text(
                      "Misc. Items",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ],
    ),
  );
}
