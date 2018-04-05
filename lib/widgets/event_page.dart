import 'package:flutter/material.dart';
import '../domains/group.dart';
import '../domains/event.dart';
import '../domains/user.dart';

class EventPage extends StatefulWidget {
  EventPage({ Key key, this.event }) : super(key: key);

  final Event event;

  @override
  _EventPageState createState() => new _EventPageState();
}

class _EventPageState extends State<EventPage> with SingleTickerProviderStateMixin {
  TabController _controller;
  List<User> _members = [];

  _setup() async {
    var members = await widget.event.getMembers();
    setState(() {
      _members = members;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = new TabController(vsync: this, length: 2);
    _setup();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.event.title),
        bottom: new TabBar(
          controller: _controller,
          tabs: [
            new Tab(text: 'Info'),
            new Tab(text: 'Games'),
          ]
        ),
      ),
      body: new TabBarView(
        controller: _controller,
        children: [_infoTab(), _gamesTab()],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _openNewGamePage,
        tooltip: 'New Game',
        child: new Icon(Icons.add),
      ),
    );
  }

  _infoTab() {
    var headingStyle = new TextStyle(fontSize: 16.0, color: Colors.grey);
    var textStyle = new TextStyle(fontSize: 18.0);
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.only(top: 30.0, bottom: 10.0, left: 20.0, right: 20.0),
          child: new Text('Description', style: headingStyle),
        ),
        new Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: new Text(widget.event.description, style: textStyle),
        ),

        new Container(
          padding: const EdgeInsets.only(top: 30.0, bottom: 10.0, left: 20.0, right: 20.0),
          child: new Text('Date', style: headingStyle),
        ),
        new Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: new Text(widget.event.date, style: textStyle),
        ),

        new Container(
          padding: const EdgeInsets.only(top: 30.0, bottom: 0.0, left: 20.0, right: 20.0),
          child: new Text('Members', style: headingStyle),
        ),
      ]..addAll(_members.map((user) {
        return new Container(
          padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          child: new Text(user.name, style: textStyle),
        );
      }).toList()),
    );
  }

  _gamesTab() {
  }

  _openNewGamePage() {
  }
}
