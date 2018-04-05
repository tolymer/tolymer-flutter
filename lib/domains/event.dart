import 'dart:async';
import 'api_client.dart';
import 'user.dart';

class Event {
  Event({ this.id, this.title, this.description, this.date });

  final int id;
  final String title;
  final String description;
  final String date;

  Future<List<User>> getMembers() async {
    var members = await APIClient.get('/events/$id/members');
    return members.map((user) {
      return new User(id: user['id'], name: user['name']);
    }).toList();
  }

  Future<void> addMembers(List<int> ids) async {
    await APIClient.post('/events/$id/members', { 'user_ids': ids });
  }
}
