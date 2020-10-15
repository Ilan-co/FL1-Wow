import 'package:flutagram/Pages/feed/feed_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedList extends StatefulWidget {
  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  @override
  Widget build(BuildContext context) {
    final feedPictures = Provider.of<List<dynamic>>(context) ?? [];

    return ListView.builder(
      itemCount: feedPictures.length,
      itemBuilder: (context, index) {
        return PictureTile(feedPicture: feedPictures[index]);
      },
    );
  }
}
