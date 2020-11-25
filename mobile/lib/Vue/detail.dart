import 'package:flutter/material.dart';
import 'package:mobile/Modeles/Report.dart';
import 'package:mobile/Services/ReportClient.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({Key key, this.token}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String token;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<String> _lines = <String>[];
  @override
  void initState() {
    super.initState();
    _getReports();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getReports() async {
    _lines = <String>[];
    String _line = "";
    // make GET request
    List<Report> reports = await ReportClient.getPosts(widget.token);
    reports.forEach((element) {
      _line = element.name +
          " " +
          element.date +
          " " +
          element.totalAmount.toString() +
          "€ " +
          element.state;
      _lines.add(_line);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<String> entries = _lines;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(title: Text('Liste des notes de frais')),
      body: new ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.orange,
            child: Center(
                child: Text(
              entries[index],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  fontStyle: Theme.of(context).textTheme.headline6.fontStyle,
                  fontFamily: Theme.of(context).textTheme.headline6.fontFamily),
            )),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
