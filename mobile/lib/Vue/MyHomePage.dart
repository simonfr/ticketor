import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Modeles/Report.dart';
import 'package:mobile/Services/ReportClient.dart';
import 'package:mobile/Vue/TakeExpenseScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/main.dart';
import 'DetailScreen.dart';
import 'DisplayPictureScreen.dart';

const List<String> STATE_GOOD = ["confirm", "accepted", "done", "paid"];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.token}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String token;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _counterExpenseAvailable = 0;

  @override
  void initState() {
    super.initState();
    _getReports();
  }

  @override
  void dispose() {
    super.dispose();
    _getReports();
  }

  _getReports() async {
    _counterExpenseAvailable = 0;
    _counter = 0;
    // make GET request
    List<Report> reports = await ReportClient.getPosts(widget.token);
    reports.forEach((element) {
      if (STATE_GOOD.contains(element.state)) {
        _counterExpenseAvailable++;
      } else {
        _counter++;
      }
    });
    setState(() {});
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    return image.path;
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('images/logo.png'),
              width: Theme.of(context).iconTheme.size,
            ),
            Text(
              'Note de frais acceptés',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              '$_counterExpenseAvailable',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Note de frais en cours',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            FlatButton(
              onPressed: () async {
                // Ensure that plugin services are initialized so that `availableCameras()`
                // can be called before `runApp()`
                WidgetsFlutterBinding.ensureInitialized();

                // Obtain a list of the available cameras on the device.
                final cameras = await availableCameras();

                // Get a specific camera from the list of available cameras.
                final firstCamera = cameras.first;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakeExpenseScreen(
                      camera: firstCamera,
                      token: widget.token,
                      notifyParent: _getReports,
                    ),
                  ),
                );
              },
              child: Text(
                'Envoyer une note de frais',
                style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.headline6.fontFamily,
                    fontStyle: Theme.of(context).textTheme.headline6.fontStyle,
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                    color: Colors.white),
              ),
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),

              // This trailing comma makes auto-formatting nicer for build methods.
            ),
            FlatButton(
              onPressed: () async {
                String path = await _imgFromGallery();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                        imagePath: path,
                        token: widget.token,
                        notifyParent: _getReports),
                  ),
                );
              },
              child: Text(
                'Selectionner la note',
                style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.headline6.fontFamily,
                    fontStyle: Theme.of(context).textTheme.headline6.fontStyle,
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                    color: Colors.white),
              ),
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            FlatButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(token: widget.token),
                  ),
                );
              },
              child: Text(
                'Voir en details',
                style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.headline6.fontFamily,
                    fontStyle: Theme.of(context).textTheme.headline6.fontStyle,
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                    color: Colors.white),
              ),
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
