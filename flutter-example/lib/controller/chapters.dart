import '../service/endpoints.dart';
import 'api_controller.dart';
import 'server_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chapters extends ApiController {

  @override
  EndpointControllerInfo info() {
    return EndpointControllerInfo(label: 'Chapters', endpoints: {
      'list': list,
      'create': create,
      'read': read,
      'update': update,
      'delete': delete,
      'export-html': exportHtml,
      'export-pdf': exportPdf,
      'export-plain-text': exportPlain,
      'export-markdown': exportMarkdown,
    });
  }

  Future<String> list() async{
    String url = '$urlFull/api/chapters';
    var response = await http.get(Uri.parse(url), headers: headers);

    return response.body;
  }

  Future<String> create() async{

    String bookID= '1';

    const url = '$urlFull/api/chapters';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String bookName = 'ApiExample';
    String description = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';


    final body = {'book_id': bookID, 'name': bookName, 'description':description};

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> read() async{

    String chapterID= '120';

    String url = '$urlFull/api/chapters/$chapterID';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> update() async{

    String chapterID= '120';

    String url = '$urlFull/api/chapters/$chapterID';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String bookName = 'ApiExample UPDATED';
    String description = 'UPDATED Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';


    final body = {'name': bookName, 'description':description};

    final response = await http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> delete() async{

    String chapterID= '120';

    String url = '$urlFull/api/chapters/$chapterID';
    var response = await http.delete(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> exportHtml() async{

    String chapterID= '120';

    String url = '$urlFull/api/chapters/$chapterID/export/html';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> exportPdf() async{

    String chapterID= '120';

    String url = '$urlFull/api/chapters/$chapterID/export/pdf';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> exportPlain() async{

    String chapterID= '120';

    String url = '$urlFull/api/chapters/$chapterID/export/plaintext';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> exportMarkdown() async{

    String chapterID= '120';

    String url = '$urlFull/api/chapters/$chapterID/export/markdown';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

}
