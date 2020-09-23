import 'package:flutagram/Models/flutagramer.dart';
import 'package:flutter/material.dart';

class FlutagramerTile extends StatelessWidget {
  final Flutagramer flutagramer;
  FlutagramerTile({this.flutagramer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.teal,
            backgroundImage: AssetImage('assets/coffee_icon.png'),
          ),
          title: Text(flutagramer.name),
          subtitle: Text('Situé à ${flutagramer.location}'),
        ),
      ),
    );
  }
}
