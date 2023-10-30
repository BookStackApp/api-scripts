import '../service/endpoints.dart';
import 'api_controller.dart';
import 'server_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Roles extends ApiController {

  @override
  EndpointControllerInfo info() {
    return EndpointControllerInfo(label: 'Roles', endpoints: {
      'list': list,
      'create': create,
      'read': read,
      'update': update,
      'delete': delete,
    });
  }

  Future<String> list() async{
    print('Trying List');
    String url = '$urlFull/api/roles';
    var response = await http.get(Uri.parse(url), headers: headers);

    return response.body;
  }

  Future<String> create() async{
    const url = '$urlFull/api/roles';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String displayName = 'NEW ROLE';
    String description = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam ';
    bool mfa_enforced = false;
    dynamic permissions = ["book-view-all",
      "book-update-all",
      "book-delete-all",
      "restrictions-manage-all"];

    final body = {'display_name': displayName, 'description':description, 'permissions':permissions, "mfa_enforced": mfa_enforced };

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> read() async{

    String rolesID= '12';

    String url = '$urlFull/api/roles/$rolesID';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> update() async{
    String roleID= '12';

    String url = '$urlFull/api/roles/$roleID';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String displayName = 'NEW ROLE UPDATED';
    String description = 'UPDATED Lorem ipsum dolor sit amet, sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam ';
    bool mfa_enforced = false;
    dynamic permissions = ["book-view-all",
      "book-update-all",
      "book-delete-all"];

    final body = {'display_name': displayName, 'description':description, 'permissions':permissions, "mfa_enforced": mfa_enforced };

    final response = await http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> delete() async{

    String shelvesID= '12';

    String url = '$urlFull/api/roles/$shelvesID';
    var response = await http.delete(Uri.parse(url), headers: headers);
    return response.body;
  }
}