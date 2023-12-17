import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_screen.dart';

class PostsScreen extends StatefulWidget {
  final int userId;

  PostsScreen({required this.userId});

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<List<Map<String, dynamic>>> posts;

  @override
  void initState() {
    super.initState();
    // Fetch posts data when the screen is initialized
    posts = fetchPosts(widget.userId);
  }

  // Function to fetch posts data from the API
  Future<List<Map<String, dynamic>>> fetchPosts(int userId) async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/$userId/posts'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body) as List<dynamic>);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Function to fetch comments data from the API
  Future<List<Map<String, dynamic>>> fetchComments(int postId) async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId/comments'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body) as List<dynamic>);
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts Screen'),
      ),
      body: FutureBuilder(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final postsData = snapshot.data as List<Map<String, dynamic>>;

            return ListView.builder(
              itemCount: postsData.length,
              itemBuilder: (context, index) {
                final post = postsData[index];

                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(post['title']),
                    subtitle: Text(post['body']),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // When the "Comments" button is pressed, navigate to the Comments screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(postId: post['id']),
                          ),
                        );
                      },
                      child: Text('Comments'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CommentsScreen extends StatefulWidget {
  final int postId;

  CommentsScreen({required this.postId});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late Future<List<Map<String, dynamic>>> comments;

  @override
  void initState() {
    super.initState();
    // Fetch comments data when the screen is initialized
    comments = fetchComments(widget.postId);
  }

  // Function to fetch comments data from the API
  Future<List<Map<String, dynamic>>> fetchComments(int postId) async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId/comments'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body) as List<dynamic>);
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments Screen'),
      ),
      body: FutureBuilder(
        future: comments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final commentsData = snapshot.data as List<Map<String, dynamic>>;

            return ListView.builder(
              itemCount: commentsData.length,
              itemBuilder: (context, index) {
                final comment = commentsData[index];

                return ListTile(
                  title: Text(comment['name']),
                  subtitle: Text(comment['body']),
                );
              },
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
      home: HomeScreen(userId: 1,), // Pass the user ID to the HomeScreen
    );
  }
}
