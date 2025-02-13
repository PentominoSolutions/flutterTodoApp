import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoService {
  static const String apiUrl =
      'http://ec2-18-191-144-106.us-east-2.compute.amazonaws.com:8090/api/todos';

  static Future<List<Map<String, dynamic>>> getTodos() async {
    final response = await http.get(Uri.parse("$apiUrl/getAllTodo"));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    }
    return [];
  }

  static Future<bool> addTodo(String title, String description) async {
    final newTodo = {
      'taskName': title,
      'taskDescription': description,
    };
    final response = await http.post(
      Uri.parse("$apiUrl/addNewTodo"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newTodo),
    );
    return response.statusCode == 201;
  }

  static Future<void> updateStatus(String id, bool status) async {
    final response = await http.put(
      Uri.parse("$apiUrl/updateStatusById"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id, 'status': status}),
    );
    return;
  }

  static Future<void> updateTodo(
      String id, String title, String description) async {
    final response = await http.put(
      Uri.parse('$apiUrl/updateTodoById/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'taskName': title, 'taskDescription': description}),
    );
    return;
  }

  static Future<void> deleteTodo(String id) async {
    final response =
        await http.delete(Uri.parse('$apiUrl/deleteTodoById?id=$id'));
    print(response.statusCode);
    print(response.statusCode);
  }
}
