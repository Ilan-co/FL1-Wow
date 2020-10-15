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
  final _geo = GeoService();
  final _imagePicker = ImagePicker();
  PickedFile feedPicture;

  void _openGal() async {
    var picture = await _imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      feedPicture = picture;
    });
  }

  void _openCamera() async {
    var picture = await _imagePicker.getImage(source: ImageSource.camera);
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

  void _upload() async {
    if (feedPicture != null) {
      String location = await _geo.getPos();
      _database.uploadPublication(context, feedPicture, location);
    } else {
      final _snack = SnackBar(content : Text("Aucune image n\'a été ajouté"));
      Scaffold.of(context).showSnackBar(_snack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[300],
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: [
            _displayImage(),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                    child: Text("Camera"),
                    onPressed: () {
                      _openCamera();
                    }),
                RaisedButton(
                    child: Text("Galerie"),
                    onPressed: () {
                      _openGal();
                    }),
              ],
            ),
            RaisedButton(
                child: Text("Poster"),
                onPressed: () {
                  _upload();
                }),
          ],
        ),
      ),
    );
  }
}
