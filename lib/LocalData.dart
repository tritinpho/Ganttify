import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

class LocalData extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<LocalData> {
  String data = "initialized"; // will be used to access local data

  // @override
  // Widget build(BuildContext context) {
  //   print('This is the DataState page.'); //TODO: delete
  //   return const Text(
  //       'Hello, DataState!'); //Displays the 'Hello, History' text in the middle of the screen
  // }

  //** Code below is to handle local storage for phone */

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<String> readContent() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      // Returning the contents of the file
      return contents;
    } catch (e) {
      // If encountering an error, return'
      print(e);
      return 'Error!';
    }
  }

  Future<File> writeContent() async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString('Hello Folk');
  }

  //This reads the content and sets the state of data as soon as something is loaded
  @override
  void initState() {
    super.initState();
    writeContent();
    readContent().then((String value) {
      setState(() {
        data = value;
      });
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return const Text('Data read from a file: \n $data!');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading and Writing data')),
      body: Center(
        child: Text(
          'Data read from a file: \n $data',
        ),
      ),
    );
  }
}
