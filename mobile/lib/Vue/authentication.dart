import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/Vue/homePage.dart';
import 'package:mobile/constante.dart';
part '../Modeles/authentication.g.dart';

void main() {
  runApp(Authentication());
}

@JsonSerializable()
class FormData {
  String login;
  String password;

  FormData({
    this.login,
    this.password,
  });

  factory FormData.fromJson(Map<String, dynamic> json) =>
      _$FormDataFromJson(json);

  Map<String, dynamic> toJson() => _$FormDataToJson(this);
}

class Authentication extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticketor',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthenticationPage(title: 'Ticketor'),
    );
  }
}

class AuthenticationPage extends StatefulWidget {
  AuthenticationPage({Key key, this.title, this.httpClient}) : super(key: key);

  final String title;
  final http.Client httpClient;

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  FormData formData = FormData();
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ...[
                  Image(
                    image: AssetImage('images/logo.png'),
                    width: Theme.of(context).iconTheme.size,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Your email address',
                      labelText: 'Login',
                    ),
                    onChanged: (value) {
                      formData.login = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      formData.password = value;
                    },
                  ),
                  FlatButton(
                    child: Text('Sign in'),
                    onPressed: () async {
                      // Use a JSON encoded string to send
                      debugPrint(
                          "Data " + jsonEncode(formData.toJson()).toString());
                      var result = await http.post(Variable.URL_API + '/signin',
                          body: jsonEncode(formData.toJson()),
                          headers: {'content-type': 'application/json'});
                      if (result.statusCode == 200) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(
                              token: result.body.toString(),
                            ),
                          ),
                        );
                      } else if (result.statusCode == 401) {
                        _showDialog('Unable to sign in.');
                      } else {
                        _showDialog('Something went wrong. Please try again.');
                      }
                    },
                  ),
                ].expand(
                  (widget) => [
                    widget,
                    SizedBox(
                      height: 24,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(message),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
