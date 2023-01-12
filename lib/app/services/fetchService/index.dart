import 'dart:io';

import 'package:bebes/app/config/env.dart';
import 'package:bebes/app/services/fetchService/bebes.interceptor.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class FetchService {
  static final FetchService f = FetchService._privateConstructor();
  Dio dio;
  FetchService._privateConstructor() : dio = Dio();
  Future initial() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    dio.options.baseUrl = "${Env.serverUrl}/api";
    // dio.options.baseUrl = "http://192.168.1.4:3003/api";

    dio.interceptors.add(CookieManager(PersistCookieJar(
        ignoreExpires: false, storage: FileStorage("$appDocPath/./cookies/"))));
    dio.interceptors.add(BebesInterceptor());
  }

  factory FetchService() {
    return f;
  }
}
