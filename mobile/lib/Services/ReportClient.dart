import 'dart:convert' as convert;
import 'dart:io';
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
