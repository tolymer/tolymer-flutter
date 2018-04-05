import 'package:flutter/material.dart';
import 'new_event_page.dart';
import 'event_page.dart';
import '../domains/group.dart';
import '../domains/event.dart';
import '../domains/user.dart';

class GroupPage extends StatefulWidget {
  GroupPage({ Key key, this.group }) : super(key: key);

  final Group group;

  @override
  _GroupPageState createState() => new _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with SingleTickerProviderStateMixin {
  List<Event> _events = [];
  List<User> _members = [];
  TabController _controller;

  _setup() async {
    var events = await widget.group.getEvents();
    var members = await widget.group.getMembers();
    setState(() {
      _events = events;
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
        title: new Text(widget.group.name),
        bottom: new TabBar(
          controller: _controller,
          tabs: [
            new Tab(text: 'Events'),
            new Tab(text: 'Members'),
          ]
        ),
      ),
      body: new TabBarView(
        controller: _controller,
        children: [_eventListView(), _membersListView()],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _openNewEventPage,
        tooltip: 'New Event',
        child: new Icon(Icons.add),
      ),
    );
  }

  _eventListView() {
    Iterable<Widget> listTiles = _events.map((event) {
      return new ListTile(
        title: new Text(event.title),
        subtitle: new Text(event.date),
        onTap: () {
          var route = new MaterialPageRoute(builder: (context) => new EventPage(event: event));
          Navigator.of(context).push(route);
        },
      );
    });
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    return new ListView(children: listTiles.toList());
  }

  _membersListView() {
    Iterable<Widget> listTiles = _members.map((user) {
      return new ListTile(
        leading: new Icon(Icons.person),
        title: new Text(user.name),
      );
    });
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    return new ListView(children: listTiles.toList());
  }

  _openNewEventPage() {
    Navigator.push(context, new MaterialPageRoute<DismissDialogAction>(
      builder: (BuildContext context) => new NewEventPage(group: widget.group),
      fullscreenDialog: true,
    ));
  }
}
