import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/config/api_config.dart';

const _kConnectTimeout = Duration(seconds: 5);
const _kReceiveTimeout = Duration(seconds: 5);

class HttpService {
  static final Dio http = Dio();

  static void configure() {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    http.options
      ..baseUrl = ApiConfig.apiBaseUrl
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
