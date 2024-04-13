import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const _kConnectTimeout = Duration(seconds: 5);
const _kReceiveTimeout = Duration(seconds: 5);

class HttpService {
  static final Dio http = Dio();

  static void configure() {
    print("Setup Succesfully");
    final apiKey = dotenv.env['TMDB_API_KEY'];
    http.options
      ..baseUrl = 'https://api.themoviedb.org/3'
      ..contentType = Headers.jsonContentType
      ..connectTimeout = _kConnectTimeout
      ..receiveTimeout = _kReceiveTimeout
      ..headers = {
        HttpHeaders.authorizationHeader: 'Bearer $apiKey',
        HttpHeaders.acceptHeader: 'application/js',
      };
    http.interceptors.add(
      LogInterceptor(
        logPrint: (o) => debugPrint(o.toString()),
      ),
    );
    http.transformer = BackgroundTransformer();
  }
}
