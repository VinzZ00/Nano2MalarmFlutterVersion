import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:replicanano2_malarm/core/entities/places.dart';
import 'dart:convert';

class APIService {
  String baseUrl;
  String? apiKey;

  APIService(this.baseUrl);

  Future<Map<String, dynamic>> fetchAndWait(Map<String, String> parameter, String? appendingUrl) async {
    String url = '${[baseUrl, appendingUrl].join("/")}?${parameter.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}';

    print("url : $url with get request");

    var response = await http.get(Uri.parse(url));
    var jsonResponse = jsonDecode(response.body);



    print("Response : ${jsonResponse}");

    print('Response StatCode : ${response.statusCode}');

    if (jsonResponse['status'] == 'OK') {
      print("Fetch Successfully");
      return jsonResponse as Map<String, dynamic>;
    } else {
      throw Exception("Elvin-99 Future<Map<String, dynamic>> return Error fetching API with HTTP Error Code : ${jsonResponse['status']}");
    }
  }
}