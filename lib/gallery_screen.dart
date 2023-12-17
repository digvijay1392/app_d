// gallery_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GalleryScreen extends StatefulWidget {
  final int albumId;

  GalleryScreen({required this.albumId});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late Future<List<Map<String, dynamic>>> photos;

  @override
  void initState() {
    super.initState();
    // Fetch photos data when the screen is initialized
    photos = fetchPhotos(widget.albumId);
  }

  // Function to fetch photos data from the API
  Future<List<Map<String, dynamic>>> fetchPhotos(int albumId) async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/$albumId/photos'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body) as List<dynamic>);
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery Screen'),
      ),
      body: FutureBuilder(
        future: photos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final photosData = snapshot.data as List<Map<String, dynamic>>;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: photosData.length,
              itemBuilder: (context, index) {
                final photo = photosData[index];

                return GestureDetector(
                  onTap: () {
                    // Show the image in preview mode when clicked
                    _showImagePreview(photo['url']);
                  },
                  child: Card(
                    margin: EdgeInsets.all(8),
                    child: Image.network(photo['thumbnailUrl']),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to show image preview
  void _showImagePreview(String imageUrl) {
    showDialog(
        context: context,
        builder: (context) {
      return Dialog(
          child: Container(
          width: 300,
          height:300,
            child: Image.network(imageUrl),
          ),
      );
        },
    );
  }
}
