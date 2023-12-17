// albums_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'gallery_screen.dart';

class AlbumsScreen extends StatefulWidget {
  final int userId;

  AlbumsScreen({required this.userId});

  @override
  _AlbumsScreenState createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  late Future<List<Map<String, dynamic>>> albums;

  @override
  void initState() {
    super.initState();
    // Fetch albums data when the screen is initialized
    albums = fetchAlbums(widget.userId);
  }

  // Function to fetch albums data from the API
  Future<List<Map<String, dynamic>>> fetchAlbums(int userId) async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/$userId/albums'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body) as List<dynamic>);
    } else {
      throw Exception('Failed to load albums');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Albums Screen'),
      ),
      body: FutureBuilder(
        future: albums,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final albumsData = snapshot.data as List<Map<String, dynamic>>;

            return ListView.builder(
              itemCount: albumsData.length,
              itemBuilder: (context, index) {
                final album = albumsData[index];

                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(album['title']),
                    onTap: () {
                      // Navigate to the Gallery Screen when an album is clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GalleryScreen(albumId: album['id']),
                        ),
                      );
                    },
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
