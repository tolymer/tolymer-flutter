import 'package:flutter/material.dart';
import '../domains/user.dart';

class GroupPage extends StatefulWidget {
  GroupPage({ Key key, this.group }) : super(key: key);

  final Group group;

  @override
  _GroupPageState createState() => new _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.group.name)),
      body: new Container(
        margin: const EdgeInsets.all(20.0),
        child: new Text(widget.group.description),
      )
    );
  }
}
