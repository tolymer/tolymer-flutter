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

  Future<Event> createEvent(params) async {
    var res = await APIClient.post('/groups/$id/events', params);
    return new Event(
      id: res['id'],
      title: res['title'],
      description: res['description'],
      date: res['date'],
    );
  }
}
