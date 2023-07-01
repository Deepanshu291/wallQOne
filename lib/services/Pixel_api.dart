import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final dio = Dio();
var APIKEY = dotenv.get('APIKEY');

Future getHttps() async {
  Uri uri = Uri.parse('https://api.pexels.com/v1/curated?per_page=30');
  final res = await http.get(uri, headers: {
    'Authorization': APIKEY
  });
  Map data = json.decode(res.body);
  List images = data['photos'];
  // print(images);
  return images;
}

Future getpageHttps(page) async {
  Uri uri = Uri.parse(
      'https://api.pexels.com/v1/curated?per_page=80&&page=' + page.toString());
  final res = await http.get(uri, headers: {
    'Authorization': APIKEY
  });
  Map data = json.decode(res.body);
  List images = data['photos'];
  // print(images);
  return images;
}
