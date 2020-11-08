import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PictureTile extends StatelessWidget {
  const PictureTile({this.feedPicture});

  final Map<String, String> feedPicture;

  Widget _displayFeed() {
    final List<Widget> list = <Widget>[];
    if (feedPicture != null) {
      list.add(
        Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              Image(
                image: NetworkImage(feedPicture['image']),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                feedPicture['location'],
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      );
      list.add(
        const SizedBox(
          height: 15,
        ),
      );
    }
    return Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[_displayFeed()],
      ),
    );
  }
}
