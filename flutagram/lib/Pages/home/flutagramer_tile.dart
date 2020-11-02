import 'package:flutagram/Models/flutagramer.dart';
import 'package:flutagram/Services/database.dart';
import 'package:flutagram/Services/preferences.dart';
import 'package:flutter/material.dart';

class FlutagramerTile extends StatelessWidget {
  const FlutagramerTile({this.flutagramer});
  final Flutagramer flutagramer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.teal,
            backgroundImage: flutagramer.picture != null
                ? NetworkImage(flutagramer.picture)
                : null,
          ),
          title: Text(flutagramer.name),
          subtitle: Text('Situé à ${flutagramer.location}'),
          trailing: FutureBuilder<String>(
            future: PreferencesServices().getUID,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == flutagramer.uid) {
                  return const SizedBox();
                } else {
                  return IconButton(
                    color: Colors.black,
                    icon: Icon(!flutagramer.followers.contains(snapshot.data) ||
                            flutagramer.followers == null
                        ? Icons.add
                        : Icons.remove),
                    onPressed: () {
                      !flutagramer.followers.contains(snapshot.data) ||
                              flutagramer.followers == null
                          ? DatabaseService().followUser(flutagramer.uid, flutagramer.token, context)
                          : DatabaseService().unfollowUser(flutagramer.uid);
                    },
                  );
                }
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
