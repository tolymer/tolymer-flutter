import 'package:flutter/material.dart';
import 'widgets/app.dart';
import 'domains/api_client.dart';

void main() {
  APIClient.endpoint = 'http://localhost:3000';
  runApp(new App());
}
