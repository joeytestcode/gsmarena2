import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class WebFetcher {
  static const maxFailure = 10;
  static int nFailure = 0;

  static Future<http.Response> _getPage(String webPage) async {
    return await http.get(Uri.parse(webPage));
  }

  static Future<Document> fetchData(String webPage) async {
    http.Response response;
    response = await _getPage(webPage);
    if (response.statusCode != 200) {
      nFailure++;
      print('''
*******************************************************************
*** Failed to get webpage (statusCode = ${response.statusCode}) ***
*******************************************************************
      ''');
    }

    Document document = parser.parse(response.body);
    return document;
  }
}
