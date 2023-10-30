import '../service/endpoints.dart';
import 'api_controller.dart';
import 'server_info.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ImageGallery extends ApiController {

  @override
  EndpointControllerInfo info() {
    return EndpointControllerInfo(label: 'Image Gallery', endpoints: {
      'list': list,
      'create': create,
      'read': read,
      'update': update,
      'delete': delete,
    });
  }

  Future<String> list() async{
    String url = '$urlFull/api/image-gallery';
    var response = await http.get(Uri.parse(url), headers: headers);

    return response.body;
  }

  Future<String> create() async {

    // THIS IS NOT FOR THE API----- THIS IS THERE SO AN IMAGE CAN BE UPLOADED

    final imageUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/BookStack_logo.svg/1200px-BookStack_logo.svg.png'; // Replace with the image URL

    // Download the image and save it locally
    final response_img = await http.get(Uri.parse(imageUrl));
    final tempDir = await Directory.systemTemp.createTemp('images');
    final imageFile = File('${tempDir.path}/image.png');
    await imageFile.writeAsBytes(response_img.bodyBytes);

    // NOW API BEGIN

    // Update the following line with your actual API endpoint
    const url = '$urlFull/api/image-gallery';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);

    request.fields['type'] = 'gallery';
    request.fields['uploaded_to'] = '1';
    request.fields['name'] = 'API_IMAGE';

    // Replace 'file' with the actual field name for your file upload
    final file = await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    );

    request.files.add(file);

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    return responseString;
  }

  Future<String> read() async{

    String imgID= '18';

    String url = '$urlFull/api/image-gallery/$imgID';
    var response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<String> update() async {

    String imgID = '705';

    // THIS IS NOT FOR THE API----- THIS IS THERE SO AN IMAGE CAN BE UPLOADED

    final imageUrl = 'https://miro.medium.com/v2/resize:fit:1400/1*5AWIAXNns_PH3XiZULxs6A.png';
    // Download the image and save it locally
    final response_img = await http.get(Uri.parse(imageUrl));
    final tempDir = await Directory.systemTemp.createTemp('images');
    final imageFile = File('${tempDir.path}/image.png');
    await imageFile.writeAsBytes(response_img.bodyBytes);

    // NOW API BEGIN

    // Update the following line with your actual API endpoint
    String url = '$urlFull/api/image-gallery/$imgID';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };

    final request = http.MultipartRequest('PUT', Uri.parse(url));
    request.headers.addAll(headers);

    request.fields['type'] = 'gallery';
    request.fields['uploaded_to'] = '1';
    request.fields['name'] = 'API_IMAGE_NEW';

    // Replace 'file' with the actual field name for your file upload
    final file = await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    );

    request.files.add(file);

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    return responseString;
  }

  Future<String> delete() async{

    String imgID= '705';

    String url = '$urlFull/api/image-gallery/$imgID';
    var response = await http.delete(Uri.parse(url), headers: headers);
    return response.body;
  }
}