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
    final flutagramers = Provider.of<List<Flutagramer>>(context) ?? [];

    return ListView.builder(
      itemCount: flutagramers.length,
      itemBuilder: (context, index) {
        return FlutagramerTile(flutagramer: flutagramers[index]);
      },
    );
  }
}
