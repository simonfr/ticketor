import 'dart:convert';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:mobile/Modeles/Report.dart';
import 'package:mobile/constante.dart';

class ReportClient {
  static final String reportsUrl = Variable.URL_API + "/reports";
  static Future<List<Report>> getPosts(String token) async {
    Response res = await get(
      reportsUrl,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    // TODO
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

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

  static Future<Report> getPost(String token, int id) async {
    Response res = await get(
      reportsUrl + "/" + id.toString(),
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    if (res.statusCode == 200) {
      Report report = Report.fromJson(jsonDecode(res.body));

      return report;
    } else {
      throw "Can't get reports";
    }
  }

  static Future<StreamedResponse> PostExpense(
      String token, String imagePath) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    var request = MultipartRequest('POST', Uri.parse(reportsUrl));
    request.files.add(await MultipartFile.fromPath('images', imagePath));
    request.headers.addAll(headers);
    var res = await request.send();
    debugPrint(res.statusCode.toString());
    debugPrint(token);
    return res;
  }
}
