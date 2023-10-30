import '../service/endpoints.dart';

abstract class ApiController {
  /// Get details of the endpoints within this controller.
  EndpointControllerInfo info();

  /// Placeholder endpoint function for not-yet-supported endpoints
  Future<String> notImplemented() async{
    return "THIS METHOD IS CURRENTLY NOT SUPPORTED";
  }
}