import '../service/endpoints.dart';
import 'api_controller.dart';
import 'server_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Books extends ApiController {

  @override
  EndpointControllerInfo info() {
    return EndpointControllerInfo(label: 'Books', endpoints: {
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
    print('Trying List');
    String url = '$urlFull/api/books';
    var response = await http.get(Uri.parse(url), headers: headers);

    return response.body;
  }

  Future<String> create() async{
    const url = '$urlFull/api/books';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String bookName = 'ApiExample';
    String description = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';


    final body = {'name': bookName, 'description':description};

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> read() async{

    String bookID= '1';

    String url = '$urlFull/api/books/$bookID';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> update() async{

    String bookID= '1';

    String url = '$urlFull/api/books/$bookID';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String bookName = 'ApiExample';
    String description = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';


    final body = {'name': bookName, 'description':description};

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> delete() async{

    String bookID= '1';

    String url = '$urlFull/api/books/$bookID';
    var response = await http.delete(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> exportHtml() async{

    String bookID= '1';

    String url = '$urlFull/api/books/$bookID/export/html';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> exportPdf() async{

    String bookID= '1';

    String url = '$urlFull/api/books/$bookID/export/pdf';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> exportPlain() async{

    String bookID= '1';

    String url = '$urlFull/api/books/$bookID/export/plaintext';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> exportMarkdown() async{

    String bookID= '1';

    String url = '$urlFull/api/books/$bookID/export/markdown';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

}