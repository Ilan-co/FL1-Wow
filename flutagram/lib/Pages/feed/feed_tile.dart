import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PictureTile extends StatelessWidget {
  final List<dynamic> feedPicture;

  PictureTile({this.feedPicture});

  Widget _displayFeed() {
    List<Widget> list = new List<Widget>();
    if (feedPicture != null) {
      for (var i = 0; i < feedPicture.length; i++) {
        list.add(
          Card(
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Image(
                  image: NetworkImage(feedPicture[i]['image']),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  feedPicture[i]['location'],
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        );
        list.add(
          SizedBox(
            height: 15,
          ),
        );
      }
    }
    return new Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [_displayFeed()],
      ),
    );
  }
}
