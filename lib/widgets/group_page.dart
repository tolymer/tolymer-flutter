import 'package:flutter/material.dart';
import '../domains/group.dart';
import 'new_event_page.dart';
import '../domains/event.dart';

class GroupPage extends StatefulWidget {
  GroupPage({ Key key, this.group }) : super(key: key);

  final Group group;

  @override
  _GroupPageState createState() => new _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<Event> _events = [];

  _setup() async {
    var events = await widget.group.getEvents();
    setState(() => _events = events);
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> listTiles = _events.map((event) {
      return new ListTile(
        leading: new Icon(Icons.explicit),
        title: new Text(event.title),
        subtitle: new Text(event.date),
        onTap: () {
          // var route = new MaterialPageRoute(builder: (context) => new EventPage(event: event));
          // Navigator.of(context).push(route);
        },
      );
    });
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles);
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.group.name)),
      body: new ListView(children: listTiles.toList()),
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
