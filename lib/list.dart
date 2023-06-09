import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class list extends StatefulWidget {
  @override
  listState createState() => listState();
}

class listState extends State<list> {
  late Future<ListResult> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/files').listAll();
  }
  Future<void> downloadFile(Reference ref) async {
    final link = await ref.getDownloadURL();

    // Create an anchor element
    final anchorElement = html.AnchorElement(href: link);

    // Set the download attribute and file name
    anchorElement.download = ref.name;

    // Simulate a click event to trigger the download
    anchorElement.click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('История Отчетов'),
      ),
      body:FutureBuilder<ListResult>(
        future: futureFiles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final files = snapshot.data!.items;
            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (BuildContext context, int index) {
                final file = files[index];
                return ListTile(
                  title: Text(file.name),
                  onTap: () => downloadFile(file), // Call _launchURL function when tapped
                );
              },
            );
          } else {
            return Center(child: Text("No data available"));
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
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: list(),
    );
  }
}
