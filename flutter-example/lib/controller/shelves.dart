import '../service/endpoints.dart';
import 'api_controller.dart';
import 'server_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Shelves extends ApiController {

  @override
  EndpointControllerInfo info() {
    return EndpointControllerInfo(label: 'Shelves', endpoints: {
      'list': list,
      'create': create,
      'read': read,
      'update': update,
      'delete': delete,
    });
  }

  Future<String> list() async{
    print('Trying List');
    String url = '$urlFull/api/shelves';
    var response = await http.get(Uri.parse(url), headers: headers);

    return response.body;
  }

  Future<String> create() async{
    const url = '$urlFull/api/shelves';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String shelveName = 'ApiShelve';
    String description = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';


    final body = {'name': shelveName, 'description':description};

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> read() async{

    String shelveID= '15';

    String url = '$urlFull/api/shelves/$shelveID';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> update() async{

    String shelvesID= '15';

    String url = '$urlFull/api/shelves/$shelvesID';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    String shelveName = 'ApiShelveUPDATED';
    String description = 'UPDATEDLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';


    final body = {'name': shelveName, 'description':description};

    final response = await http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));

    return response.body;
  }

  Future<String> delete() async{

    String shelvesID= '15';

    String url = '$urlFull/api/shelves/$shelvesID';
    var response = await http.delete(Uri.parse(url), headers: headers);
    return response.body;
  }
}