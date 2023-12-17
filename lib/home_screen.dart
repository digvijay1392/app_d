import 'package:app_d/todos_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';

import 'PostsScreen.dart';
import 'albums_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId; // Add userId as a parameter

  HomeScreen({required this.userId}); // Update the constructor

  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  final String userApiUrl = 'https://jsonplaceholder.typicode.com/users/';
  final String imageUrl = 'https://picsum.photos/200';

  Future<Map<String, dynamic>> fetchUserData() async {
    final response = await http.get(Uri.parse(userApiUrl));

    if (response.statusCode == 200) {
      // Parse the response body and return the first user data
      List<dynamic> users = jsonDecode(response.body);
      if (users.isNotEmpty) {
        return users.first;
      } else {
        throw Exception('No user data available');
      }
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: FutureBuilder(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userData = snapshot.data as Map<String, dynamic>;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(imageUrl),
                SizedBox(height: 16),
                Text('User Name: ${userData['name']}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostsScreen(userId: widget.userId),
                      ),
                    );
                  },
                  child: Text('View Posts'),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodosScreen(userId: widget.userId),
                      ),
                    );
                  },
                  child: Text('View To-Dos'),
                ),

                ElevatedButton(
                onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => AlbumsScreen(userId: widget.userId),
          ),
          );
          },
          child: Text('View Albums'),
          ),


              ],
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(userId: 1,),
    );
  }
}
