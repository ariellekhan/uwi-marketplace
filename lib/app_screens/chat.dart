import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../authentication.dart';
import '../user.dart';
import 'package:ntp/ntp.dart';

class Chat extends StatefulWidget {
  final String chatId;
  final String peerEmail;
  final String peerID;
  final String msg;
  Chat(
      {Key key,
      @required this.chatId,
      @required this.peerEmail,
      @required this.peerID,
      @required this.msg})
      : super(key: key);

  @override
  _ChatState createState() => new _ChatState();
}

class _ChatState extends State<Chat> {
  String _title = "CHAT";
  @override
  void didUpdateWidget(Widget oldWidget) {}

  @override
  Widget build(BuildContext context) {
    final myAppBar = new AppBar(
      title: new Text(
        _title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );

    return new Scaffold(
      appBar: myAppBar,
      backgroundColor: Color.fromRGBO(237, 237, 237, 1.0),
      body: new StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.peerEmail)
            .collection("userInfo")
            .document(widget.peerEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)));
          } else {
            var doc = snapshot.data; //userData
            User peerInfo = new User(doc['email'], doc['major'], doc['name'],
                doc['phone'], doc['userImage'], widget.peerID);
            _title = peerInfo.name;

            didUpdateWidget(myAppBar);
            return new ChatScreen(
              chatId: widget.chatId,
              peerInfo: peerInfo,
              msg: widget.msg,
            );
          }
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String chatId;
  final User peerInfo;
  final String msg;

  ChatScreen(
      {Key key,
      @required this.chatId,
      @required this.peerInfo,
      @required this.msg})
      : super(key: key);

  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  DateTime _currentTime;
  DateTime _ntpTime;
  int _ntpOffset;

  String id;
  var listMessage;
  String chatId;

  bool isLoading;
  String _myImageUrl;
  String _myName;
  String _peerUuid;
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();

    chatId = widget.chatId;
    _myImageUrl = "";

    isLoading = false;
    id = getUser().uid;
    if (widget.msg != "" && widget.msg != null) {
      onSendMessage(widget.msg, 0);
    }
  }

  void sendMessage(String content, int type) async {
    if (content.trim() != '') {
      textEditingController.clear();

      //allChats

      await _updateTime().then((_) async {
        var documentReference = Firestore.instance
            .collection('messages')
            .document(chatId)
            .collection("chat")
            .document(_ntpTime.millisecondsSinceEpoch.toString());

        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference,
            {
              'idFrom': id,
              'idTo': widget.peerInfo.uuid,
              'peerEmail': widget.peerInfo.email,
              'timestamp': _ntpTime.millisecondsSinceEpoch.toString(),
              'content': content,
              'type': type
            },
          );
        });

        //myChat
        var documentReference2 = Firestore.instance
            .collection('users')
            .document(getUser().email)
            .collection("myChats")
            .document(chatId);

        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference2,
            {
              'content': content,
              'idFrom': id,
              'idTo': widget.peerInfo.uuid,
              'peerEmail': widget.peerInfo.email,
              'peerName': widget.peerInfo.name,
              'peerImageUrl': widget.peerInfo.userImage,
              'timestamp': _ntpTime.millisecondsSinceEpoch.toString(),
              'chatId': chatId
            },
          );
        });

        //peerChat
        var documentReference3 = Firestore.instance
            .collection('users')
            .document(widget.peerInfo.email)
            .collection("myChats")
            .document(chatId);

        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference3,
            {
              'content': content,
              'idFrom': id,
              'idTo': widget.peerInfo.uuid,
              'peerEmail': getUser().email,
              'peerName': _myName,
              'peerImageUrl': _myImageUrl,
              'timestamp': _ntpTime.millisecondsSinceEpoch.toString(),
              'chatId': chatId
            },
          );
        });
        listScrollController.animateTo(0.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }).catchError((e) {});
    } else {
      //do nothing
    }
  }

  //gets current user info from database
  Future _getMyInfo() async {
    String myEmail = getUser().email;
    await Firestore.instance
        .collection('users')
        .document(myEmail)
        .collection('userInfo')
        .document(myEmail)
        .get()
        .then((document) {
      setState(() {
        var url = document["userImage"];
        var name = document["name"];

        if (url != null) {
          _myImageUrl = url;
          _myName = name;
        }
      });
    });
  }

  void onSendMessage(String content, int type) {
    if (_myImageUrl == "") {
      _getMyInfo().then((_) {
        sendMessage(content, type);
      }).catchError((e) {});
    } else {
      sendMessage(content, type);
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == 0
              // Text
              ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.black),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(75, 186, 204, 5.0),
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              : Container(),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                                child: Image.asset(
                                  'images/profile.png',
                                ),
                                width: 35.0,
                                height: 35.0,
                                padding: EdgeInsets.all(10.0),
                              ),
                          imageUrl: widget.peerInfo.userImage,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                document['type'] == 0
                    ? Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(color: Colors.black),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document['type'] == 1
                        ? Container(
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      ),
                                      width: 200.0,
                                      height: 200.0,
                                      padding: EdgeInsets.all(70.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Material(
                                      child: Image.asset(
                                        'images/profile.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                imageUrl: document['content'],
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : Container(
                            child: new Image.asset(
                              'images/profile.png',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Sticker

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.message),
              ),
            ),
            color: Colors.white,
          ),

          // type text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.green, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.red,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: chatId == 'null'
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(chatId)
                  .collection("chat")
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.red)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  Future _updateTime() async {
    _currentTime = DateTime.now();
    await NTP.getNtpOffset().then((value) {
      setState(() {
        _ntpOffset = value;
        _ntpTime = _currentTime.add(Duration(milliseconds: _ntpOffset));
      });
    });
  }
}
