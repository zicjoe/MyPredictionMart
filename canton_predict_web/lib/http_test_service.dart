// lib/http_test_service.dart
//
// Tiny demo to prove Flutter can call an HTTP API.

import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpTestService {
  Future<String> fetchDemoText() async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/todos/1');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed with status ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    // This API returns a "title" field.
    final title = data['title'] as String;
    return 'Demo API title: $title';
  }
}

final httpTestService = HttpTestService();