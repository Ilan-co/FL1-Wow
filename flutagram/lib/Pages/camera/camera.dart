import 'dart:io';

import 'package:flutagram/Services/database.dart';
import 'package:flutagram/Services/geo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final DatabaseService _database = DatabaseService();
  final GeoService _geo = GeoService();
  final ImagePicker _imagePicker = ImagePicker();
  PickedFile feedPicture;

  Future<void> _openGal() async {
    final PickedFile picture = await _imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      feedPicture = picture;
    });
  }

  Future<void> _openCamera() async {
    final PickedFile picture = await _imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      feedPicture = picture;
    });
  }

  Widget _displayImage() {
    if (feedPicture != null) {
      return Image(
        height: 300,
        width: 300,
        image: FileImage(File(feedPicture.path)),
        fit: BoxFit.scaleDown,
      );
    }
    return Container();
  }

  Future<void> _upload() async {
    if (feedPicture != null) {
      final String location = await _geo.getPos();
      _database.uploadPublication(context, feedPicture, location);
    } else {
      const SnackBar _snack = SnackBar(content : Text("Aucune image n\'a été ajouté"));
      Scaffold.of(context).showSnackBar(_snack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[300],
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: <Widget>[
            _displayImage(),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                    child: const Text('Camera'),
                    onPressed: () {
                      _openCamera();
                    }),
                RaisedButton(
                    child: const Text('Galerie'),
                    onPressed: () {
                      _openGal();
                    }),
              ],
            ),
            RaisedButton(
                child: const Text('Poster'),
                onPressed: () {
                  _upload();
                }),
          ],
        ),
      ),
    );
  }
}
