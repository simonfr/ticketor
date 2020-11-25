import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Services/ReportClient.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String token;
  final int count;

  const DisplayPictureScreen(
      {Key key, @required this.imagePath, @required this.token, this.count})
      : super(key: key);

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Text(
              'Votre note de frais',
              style: Theme.of(context).textTheme.headline6,
            ),
            Image.file(File(widget.imagePath))
          ],
        )),
        floatingActionButton: FloatingActionButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Icon(Icons.send)],
            ),
            onPressed: () async {
              StreamedResponse res = await ReportClient.PostExpense(
                  widget.token, widget.imagePath);
              if (res.statusCode == 201) {
                _showDialog("Votre demande est en cours de traitement", false);
              } else {
                _showDialog("L'envoie de l'image à échoué", true);
              }
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  void _showDialog(String message, bool error) {
    showDialog(
        context: context,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  int count = 0;
                  debugPrint(widget.count.toString());
                  int countLimit = widget.count == null ? 2 : widget.count;
                  if (error && countLimit >= 3) {
                    countLimit--;
                  }
                  Navigator.of(context).popUntil((_) => count++ >= countLimit);
                },
              ),
            ],
          );
        });
  }
}
