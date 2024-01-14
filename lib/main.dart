import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'song.dart'; 



void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<List<Song>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://freesound.org/apiv2/search/text/?query=beat&token=ZO8Ny9tMBLKCQw3DOAIhYD8glC9IUTkh8gnDGuQW'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['results'];
      final List<Song> dataList =
          jsonList.map((json) => Song.fromJson(json)).toList();

      return dataList;
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Assignment',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Assignment'),
        ),
        body: FutureBuilder<List<Song>>(
          future: fetchData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return buildErrorWidget(snapshot.error.toString());
                }
                return buildContentWidget(context, snapshot.data!);
              default:
                return const Center(
                    child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text('Unexpected Connection State')));
            }
          },
        ),
      ),
    );
  }

 Widget buildContentWidget(BuildContext context, List<Song> dataList) {
    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final song = dataList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongDetailScreen(song: song),
                ),
              );
            },
            child: Card(
              color: const Color(0xFF596275),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ID: ${song.id}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Name: ${song.name}",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}




class Song {
  final String id;
  final String name;
  late final String url;
  late List<String> previews;


  Song({required this.id, required this.name}) {
    url = 'https://freesound.org/apiv2/sounds/$id/?token=ZO8Ny9tMBLKCQw3DOAIhYD8glC9IUTkh8gnDGuQW';
    previews = [];
    _fetchPreviews();
  }

   Future<void> _fetchPreviews() async {
    final apiUrl = 'https://freesound.org/apiv2/sounds/$id/?token=ZO8Ny9tMBLKCQw3DOAIhYD8glC9IUTkh8gnDGuQW';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final Map<String, dynamic> previewsData = responseData['previews'];
        previews = previewsData.keys.map((key) => previewsData[key].toString()).toList();
        
        

      } else {
        // Handle error
        print('Failed to fetch previews: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      print('Error fetching previews: $e');
    }
  }


  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}


Widget buildErrorWidget(String error) {
  return Center(
    child: Text("Error: $error"),
  );
}



