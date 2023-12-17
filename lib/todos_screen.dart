// todos_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodosScreen extends StatefulWidget {
  final int userId;

  TodosScreen({required this.userId});

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  late Future<List<Map<String, dynamic>>> todos;

  @override
  void initState() {
    super.initState();
    // Fetch todos data when the screen is initialized
    todos = fetchTodos(widget.userId);
  }

  // Function to fetch todos data from the API
  Future<List<Map<String, dynamic>>> fetchTodos(int userId) async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/$userId/todos'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body) as List<dynamic>);
    } else {
      throw Exception('Failed to load todos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Dos Screen'),
      ),
      body: FutureBuilder(
        future: todos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final todosData = snapshot.data as List<Map<String, dynamic>>;

            return ListView.builder(
              itemCount: todosData.length,
              itemBuilder: (context, index) {
                final todo = todosData[index];

                return ListTile(
                  leading: Checkbox(
                    value: todo['completed'],
                    onChanged: (bool? value) {
                      // Handle checkbox state change if needed
                    },
                  ),
                  title: Text(todo['title']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
