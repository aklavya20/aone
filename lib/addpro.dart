import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AddtheProduct {
  final String baseUrl = 'https://desktop-og46q9s.tail7d5586.ts.net';

  Future<Map<String, dynamic>> addProduct(
      String name, String price, String category, File image) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/api/collections/product/records'));

    request.fields['Name'] = name;
    request.fields['Price'] = price;
    request.fields['Category'] = category;

    request.files.add(await http.MultipartFile.fromPath(
      'Images',
      image.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      return json.decode(responseBody);
    } else {
      throw Exception('Failed to Add Data');
    }
  }
}