import 'package:flutter/material.dart';
import '../domains/group.dart';
import 'new_event_page.dart';

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
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _openNewEventPage,
        tooltip: 'New Event',
        child: new Icon(Icons.add),
      ),
    );
}

  _openNewEventPage() {
    Navigator.push(context, new MaterialPageRoute<DismissDialogAction>(
      builder: (BuildContext context) => new NewEventPage(group: widget.group),
      fullscreenDialog: true,
    ));
  }
}
