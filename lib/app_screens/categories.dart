import 'package:flutter/material.dart';
import 'add_items.dart';
import 'items_list.dart';

class Categories extends StatefulWidget {
  static String tag = 'categories';

  @override
  _CategoriesState createState() => new _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: new Container(),
          centerTitle: true,
          title: Text(
            'Categories',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.purple,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_box),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new ItemForm()),
                );
              },
            ),
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
                    onPressed: () {
                      // ADD LOGIC
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                new AllItems(value: 'Text Book')),
                      );
                    },
                    color: Colors.green,
                    padding: EdgeInsets.all(45.0),
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
                    onPressed: () {
                      // ADD LOGIC
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                new AllItems(value: 'Stationery')),
                      );
                    },
                    color: Colors.orange,
                    padding: EdgeInsets.all(45.0),
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
                    onPressed: () {
                      // ADD LOGIC
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new AllItems(value: 'Dorm')),
                      );
                    },
                    color: Colors.purple,
                    padding: EdgeInsets.all(45.0),
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
                    onPressed: () {
                      // ADD LOGIC
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                new AllItems(value: 'Electronics')),
                      );
                    },
                    color: Colors.yellow,
                    padding: EdgeInsets.all(45.0),
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
                    onPressed: () {
                      // ADD LOGIC
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                new AllItems(value: 'Special Equipment')),
                      );
                    },
                    color: Colors.blue,
                    padding: EdgeInsets.all(45.0),
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
                    onPressed: () {
                      // ADD LOGIC
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                new AllItems(value: 'Miscellaneous')),
                      );
                    },
                    color: Colors.pink,
                    padding: EdgeInsets.all(45.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(Icons.category),
                        Text(
                          "Misc.\nItems",
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
