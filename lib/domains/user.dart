import 'dart:async';
import 'api_client.dart';
import 'group.dart';

class User {
  User({ this.id, this.name });

  final int id;
  final String name;

  static Future<User> getCurrentUser() async {
    var user = await APIClient.get('/current_user');
    return new User(id: user['id'], name: user['name']);
  }

  Future<List<Group>> getGroups() async {
    var groups = await APIClient.get('/current_user/groups');
    return groups.map((group) {
      return new Group(
        id: group['id'],
        name: group['name'],
        description: group['description'],
      );
    }).toList();
  }
}
