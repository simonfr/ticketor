import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Services/ReportClient.dart';
import 'package:mobile/Vue/MyHomePage.dart';
import 'package:mobile/main.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String token;
  final int count;
  final Function() notifyParent;

  const DisplayPictureScreen(
      {Key key,
      @required this.imagePath,
      @required this.token,
      this.count,
      this.notifyParent})
      : super(key: key);

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          widget.notifyParent();
          return true;
        },
        child: Scaffold(
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
                    _showDialog(
                        "Votre demande est en cours de traitement", false);
                  } else {
                    final message = await res.stream.bytesToString();
                    _showDialog(message, true);
                  }
                }),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat));
  }

  void _showDialog(String message, bool error) async {
    await showDialog(
        context: context,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }).then((value) {
      int count = 0;
      int countLimit = widget.count == null ? 1 : widget.count;
      widget.notifyParent();
      Navigator.of(context).popUntil((_) => count++ >= countLimit);
    });
  }
}
