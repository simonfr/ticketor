import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mobile/Modeles/Report.dart';

class HttpService {
  static final String reportsUrl = "https://510be684671f.ngrok.io/reports";
  static final String token =
      "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInBhc3N3b3JkIjoiYWRtaW4xMjMiLCJpYXQiOjE2MDYyMjUxMjEsImV4cCI6MTYwNjIzOTUyMX0.PxeuNSJOeJ_8HxXmDZzDbfiQspiuhW5O1ZV2eV5CwJMxFZOxpnokXKiSJaaWGm5lux_X8QP9hGUW6fuTCN1-Uw";

  static Future<List<Report>> getPosts() async {
    Response res = await get(
      reportsUrl,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    if (res.statusCode == 200) {
      List<dynamic> body = convert.jsonDecode(res.body);

      List<Report> reports = body
          .map(
            (dynamic item) => Report.fromJson(item),
          )
          .toList();

      return reports;
    } else {
      throw "Can't get reports";
    }
  }
}
