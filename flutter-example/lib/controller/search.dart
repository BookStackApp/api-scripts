import '../service/endpoints.dart';
import 'api_controller.dart';
import 'server_info.dart';
import 'package:http/http.dart' as http;

class Search extends ApiController {

  @override
  EndpointControllerInfo info() {
    return EndpointControllerInfo(label: 'Search', endpoints: {
      'all': all,
    });
  }

  Future<String> all() async{
    String page = '1';
    String count = '2';

    String url = '$urlFull/api/search?query=pages+{created_by:me}&page=$page&count=$count';
    var response = await http.get(Uri.parse(url), headers: headers);

    return response.body;
  }
}