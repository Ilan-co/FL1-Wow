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
    final List<dynamic> feedPicturesSrc =
        Provider.of<List<dynamic>>(context) ?? <dynamic>[];
    final List<Map<String, String>> feedPictures = <Map<String, String>>[];
    for (int i = 0; i < feedPicturesSrc.length; i++) {
      if (feedPicturesSrc[i] != null) {
        final String str = feedPicturesSrc[i].toString();
        feedPictures.add(<String, String>{
          'image': str.split(',')[0].split(' ')[1],
          'location': str.split(',')[1].split(': ')[1] + '\n' + str.split(',')[2]
        });
      }
    }

    return ListView.builder(
      itemCount: feedPictures.length,
      itemBuilder: (BuildContext context, int index) {
        return PictureTile(feedPicture: feedPictures[index]);
      },
    );
  }
}
