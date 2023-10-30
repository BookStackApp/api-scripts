import '../service/endpoints.dart';
import 'api_controller.dart';
import 'server_info.dart';
import 'package:http/http.dart' as http;

class RecycleBin extends ApiController {

  @override
  EndpointControllerInfo info() {
    return EndpointControllerInfo(label: 'Recycle Bin', endpoints: {
      'list': list,
      'restore': notImplemented,
      'destroy': destroy,
    });
  }

  Future<String> list() async{
    print('Trying List');
    String url = '$urlFull/api/recycle-bin';
    var response = await http.get(Uri.parse(url), headers: headers);

    return response.body;
  }


  Future<String> destroy() async{

    String deletionID= '121';

    String url = '$urlFull/api/recycle-bin/$deletionID';
    var response = await http.delete(Uri.parse(url), headers: headers);
    return response.body;
  }
}