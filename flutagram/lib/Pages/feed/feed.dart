import 'package:flutagram/Pages/feed/feed_list.dart';
import 'package:flutagram/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<dynamic>>.value(
      value: DatabaseService().feed,
      child: Scaffold(
        backgroundColor: Colors.teal[300],
        body: FeedList(),
      ),
    );
  }
}
