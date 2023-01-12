import 'dart:convert';

import 'package:bebes/app/constants/shared_key.dart';
import 'package:bebes/app/modules/login/auth_model.dart';
import 'package:bebes/app/services/Sqflite/database.dart';
import 'package:bebes/app/services/auth/index.dart';
import 'package:bebes/app/services/fetchService/index.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

class BebesInterceptor extends Interceptor {
  final Future<SharedPreferences> _sharedPrefercens;
  final Future<Database> _db;
  final AuthService _authService = AuthService();
  late Auth auth;
  BebesInterceptor()
      : _sharedPrefercens = SharedPreferences.getInstance(),
        _db = BebesDatabase("bebes").db;
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final listNotSecurePath = [
      "/auth/login",
      "/auth/register",
      "/auth/refresh-token"
    ];
    if (listNotSecurePath.contains(options.path.toString())) {
      return handler.next(options);
    }
    final accessToken = (await _sharedPrefercens).getString(SharedKey.authKey);
    final token = accessToken != null ? json.decode(accessToken)["token"] : "";
    final userId =
        accessToken != null ? json.decode(accessToken)["userId"] : "";
    options.headers.addAll({
      "Authorization": "Bearer $token",
    });
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      FetchService fetchService = FetchService();
      await fetchService.initial();
      final response = await fetchService.dio.get("/auth/refresh-token");
      _authService.saveAuth(response.data);
      final newResponse = await fetchService.dio.request(
        err.requestOptions.path,
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
        options: Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
        ),
      );
      return handler.resolve(newResponse);
    }
    // TODO: implement onError
    handler.next(err);
  }
}
