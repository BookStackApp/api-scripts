import '../service/endpoints.dart';
import 'api_controller.dart';
import 'server_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Attachments extends ApiController {

  @override
  EndpointControllerInfo info() {
    return EndpointControllerInfo(label: 'Attachments', endpoints: {
      'list': list,
      'create': create,
      'read': read,
      'update': update,
      'delete': delete,
    });
  }

  Future<String> list() async{
    print('Trying List');
    String url = '$urlFull/api/attachments';
    var response = await http.get(Uri.parse(url), headers: headers);

    return response.body;
  }

  Future<String> create() async{
    const url = '$urlFull/api/attachments';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String attachmentName = 'AttachmentName';
    int uploadedTo = 8;
    String link = 'https://bookstackapp.com/api/docs';

    final body = {'name': attachmentName, 'uploaded_to':uploadedTo, "link":link};

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> read() async{

    String attachmentsID= '1';

    String url = '$urlFull/api/attachments/$attachmentsID';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> update() async{

    String attachmentsID= '1';

    String url = '$urlFull/api/attachments/$attachmentsID';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String attachmentName = 'AttachmentName';
    int uploadedTo = 8;
    String link = 'https://bookstackapp.com/';

    final body = {'name': attachmentName, 'uploaded_to':uploadedTo, "link":link};

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> delete() async{

    String attachmentsID= '1';

    String url = '$urlFull/api/attachments/$attachmentsID';
    var response = await http.delete(Uri.parse(url), headers: headers);
    return response.body;
  }
}