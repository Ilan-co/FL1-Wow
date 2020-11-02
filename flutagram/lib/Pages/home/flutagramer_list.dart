import 'package:flutagram/Models/flutagramer.dart';
import 'package:flutagram/Pages/home/flutagramer_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlutagramerList extends StatefulWidget {
  @override
  _FlutagramerListState createState() => _FlutagramerListState();
}

class _FlutagramerListState extends State<FlutagramerList> {
  @override
  Widget build(BuildContext context) {
    final List<Flutagramer> flutagramers =
        Provider.of<List<Flutagramer>>(context) ?? <Flutagramer>[];

    return ListView.builder(
      itemCount: flutagramers.length,
      itemBuilder: (BuildContext context, int index) {
        return FlutagramerTile(flutagramer: flutagramers[index]);
      },
    );
  }
}
