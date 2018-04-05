import 'dart:async';
import 'api_client.dart';
import 'user.dart';
import 'event.dart';

class Group {
  Group({ this.id, this.name, this.description });

  final int id;
  final String name;
  final String description;

  Future<List<User>> getMembers() async {
    var users = await APIClient.get('/groups/$id/members');
    return users.map((user) => new User(id: user['id'], name: user['name'])).toList();
  }

  Future<List<Event>> getEvents() async {
    var events = await APIClient.get('/groups/$id/events');
    return events.map((event) => _toEvent(event)).toList();
  }

  Future<Event> createEvent(params) async {
    var res = await APIClient.post('/groups/$id/events', params);
    return _toEvent(res);
  }

  Event _toEvent(hash) {
    return new Event(
      id: hash['id'],
      title: hash['title'],
      description: hash['description'],
      date: hash['date'],
    );
  }
}
