import '../service/endpoints.dart';
import 'api_controller.dart';
import 'server_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Pages extends ApiController {

  @override
  EndpointControllerInfo info() {
    return EndpointControllerInfo(label: 'Pages', endpoints: {
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
    String url = '$urlFull/api/pages';
    var response = await http.get(Uri.parse(url), headers: headers);

    return response.body;
  }

  Future<String> create() async{

    String bookID= '1';

    // You could also use Chapter ID

    const url = '$urlFull/api/pages';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String pageName = 'ApiExample';
    String html = '<p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.<p>';


    final body = {'book_id': bookID, 'name': pageName, 'html':html};

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> read() async{

    String pageID= '371';

    String url = '$urlFull/api/pages/$pageID';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> update() async{

    String pageID= '371';

    String url = '$urlFull/api/pages/$pageID';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String pageName = 'ApiExample UPDATED';
    String html = '<p>UPDATED Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>';
    String bookID = '1';

    final body = {'name': pageName, 'html':html, 'book_id': bookID};

    final response = await http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> delete() async{

    String pageID= '371';

    String url = '$urlFull/api/page/$pageID';
    var response = await http.delete(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> exportHtml() async{

    String pageID= '371';

    String url = '$urlFull/api/pages/$pageID/export/html';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> exportPdf() async{

    String pageID= '371';

    String url = '$urlFull/api/pages/$pageID/export/pdf';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> exportPlain() async{

    String pageID= '371';

    String url = '$urlFull/api/pages/$pageID/export/plaintext';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> exportMarkdown() async{

    String pageID= '371';

    String url = '$urlFull/api/pages/$pageID/export/markdown';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

}