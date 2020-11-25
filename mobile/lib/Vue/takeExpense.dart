import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Services/ReportClient.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

// A screen that allows users to take a picture using a given camera.
class TakeExpenseScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakeExpenseScreen(
      {Key key, @required this.camera, @required this.token})
      : super(key: key);

  final String token;

  @override
  TakeExpenseScreenState createState() => TakeExpenseScreenState();
}

class TakeExpenseScreenState extends State<TakeExpenseScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      extendBodyBehindAppBar: true,
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            _controller.stopImageStream();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DisplayPictureScreen(imagePath: path, token: widget.token),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String token;

  const DisplayPictureScreen(
      {Key key, @required this.imagePath, @required this.token})
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
                _showDialog(
                    "Votre demande est en cours de traitement", context);
              } else {
                _showDialogError("L'envoie de l'image à échoué");
              }
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  void _showDialog(String message, BuildContext context) {
    showDialog(
        context: context,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 3);
                },
              ),
            ],
          );
        });
  }

  void _showDialogError(String message) {
    showDialog(
        context: context,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
              ),
            ],
          );
        });
  }
}
