
import 'dart:convert';

import '../controller/api_controller.dart';
import '../controller/attachments.dart';
import '../controller/books.dart';
import '../controller/chapters.dart';
import '../controller/content_permissions.dart';
import '../controller/image_gallery.dart';
import '../controller/pages.dart';
import '../controller/reycle_bin.dart';
import '../controller/roles.dart';
import '../controller/search.dart';
import '../controller/shelves.dart';
import '../controller/users.dart';

/// A function to represent an endpoint calling function
typedef ApiEndpoint = Future<String> Function();

/// Data structure to hold information about an API endpoint controller
class EndpointControllerInfo {
  final String label;
  final Map<String, ApiEndpoint> endpoints;
  const EndpointControllerInfo({
    required this.label,
    required this.endpoints,
  });
}

// High level endpoint manager class
class Endpoints {

  static List<ApiController> controllers = [
    Attachments(),
    Books(),
    Chapters(),
    Pages(),
    ImageGallery(),
    Search(),
    Shelves(),
    Users(),
    Roles(),
    RecycleBin(),
    ContentPermissions(),
  ];

  Map<String, List<String>> all() {
    Map<String, List<String>> methodsByController = <String, List<String>>{};

    for (var controller in controllers) {;
      List<String> endpoints = <String>[];
      for (var method in controller.info().endpoints.entries) {
        endpoints.add(method.key);
      }
      methodsByController[controller.info().label] = endpoints;
    }

    return methodsByController;
  }

  Future<String> call(String controllerLabel, String methodName) async {
    for (var controller in controllers) {;
      if (controller.info().label == controllerLabel) {
        ApiEndpoint? endpoint = controller.info().endpoints[methodName];
        if (endpoint != null) {
          String responseText = await endpoint();
          try {
            // Parse the original JSON data
            var parsedJson = json.decode(responseText);
            // Encode the parsed JSON data with indentation for readability
            responseText = const JsonEncoder.withIndent('  ').convert(parsedJson);
          } on Exception catch (_) {
          }

          return responseText;
        } else {
          return "Method not found in controller";
        }
      }
    }

    return "Controller not found";
  }

}