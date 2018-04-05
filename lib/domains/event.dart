import 'dart:async';
import 'api_client.dart';

class Event {
  Event({ this.id, this.title, this.description, this.date });

  final int id;
  final String title;
  final String description;
  final String date;

  Future<void> addMembers(List<int> ids) async {
    await APIClient.post('/events/$id/members', { 'user_ids': ids });
  }
}
