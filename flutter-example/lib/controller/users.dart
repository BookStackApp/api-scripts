import '../service/endpoints.dart';
import 'api_controller.dart';
import 'server_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Users extends ApiController {

  @override
  EndpointControllerInfo info() {
    return EndpointControllerInfo(label: 'Users', endpoints: {
      'list': list,
      'create': create,
      'read': read,
      'update': update,
      'delete': delete,
    });
  }

  Future<String> list() async{
    print('Trying List');
    String url = '$urlFull/api/users';
    var response = await http.get(Uri.parse(url), headers: headers);

    return response.body;
  }

  Future<String> create() async{
    const url = '$urlFull/api/users';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String userName = 'USERNAME';
    String email = 'admin@example.com';
    String password = 'nEEUf!|5KS;,';
    dynamic roles = [1];
    String language = 'fr';

    final body = {'name': userName, 'email':email, 'roles':roles, 'language':language, "send_invite": false, "password": password };

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> read() async{

    String userID= '27';

    String url = '$urlFull/api/users/$userID';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> update() async{
    String userID= '27';

    String url = '$urlFull/api/users/$userID';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String userName = 'USERNAME NEW';
    String email = 'admin@example.com';
    String password = 'nEEUf!|5KS;,';
    dynamic roles = [1];
    String language = 'fr';

    final body = {'name': userName, 'email':email, 'roles':roles, 'language':language, "send_invite": false, "password": password };

    final response = await http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> delete() async{

    String shelvesID= '27';

    String url = '$urlFull/api/users/$shelvesID';
    var response = await http.delete(Uri.parse(url), headers: headers);
    return response.body;
  }
}