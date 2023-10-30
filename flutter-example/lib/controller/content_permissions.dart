import '../service/endpoints.dart';
import 'api_controller.dart';
import 'server_info.dart';
import 'package:http/http.dart' as http;

class ContentPermissions extends ApiController {

  @override
  EndpointControllerInfo info() {
    return EndpointControllerInfo(label: 'Content Permissions', endpoints: {
      'read': read,
      'update': notImplemented,
    });
  }

  Future<String> read() async{
    String contentType = 'page';
    String contentID = '1';
    String url = '$urlFull/api/content-permissions/$contentType/$contentID';
    var response = await http.get(Uri.parse(url), headers: headers);

    return response.body;
  }

}