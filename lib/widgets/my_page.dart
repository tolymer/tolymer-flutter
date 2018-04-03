import 'package:flutter/material.dart';
import '../domains/user.dart';

class MyPage extends StatefulWidget {
  MyPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.user.name)),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Text('Hello ${widget.user.name}'),
          ],
        ),
      ),
    );
  }
}
