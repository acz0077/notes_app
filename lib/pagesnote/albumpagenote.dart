import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http show get;

// Future<http.Response> fetchAlbum() async {
// final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
// }

Future<List<Album>> fetchAlbums() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((album) => Album.fromJson(album)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load albums');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('userId') &&
        json.containsKey('id') &&
        json.containsKey('title')) {
      return Album(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
      );
    } else {
      throw const FormatException('Failed to load album');
    }
  }
}

class AlbumPageNote extends StatefulWidget {
  const AlbumPageNote({super.key});

  @override
  State<AlbumPageNote> createState() => _AlbumPageNoteState();
}

class _AlbumPageNoteState extends State<AlbumPageNote> {
  late Future<List<Album>> futureAlbums;

  @override
  void initState() {
    super.initState();
    futureAlbums = fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Album Page Note")),
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: FutureBuilder<List<Album>>(
          future: futureAlbums,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Display the titles of all albums in a column
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    snapshot.data!.map((album) => Text(album.title)).toList(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
