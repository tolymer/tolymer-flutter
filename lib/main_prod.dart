import 'package:flutter/material.dart';
import 'widgets/app.dart';
import 'domains/api_client.dart';

void main() {
  APIClient.endpoint = 'https://api.tolymer.com';
  runApp(new App());
}
