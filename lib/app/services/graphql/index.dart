import 'dart:convert';
import 'dart:io';

import 'package:bebes/app/config/env.dart';
import 'package:bebes/app/constants/shared_key.dart';
import 'package:bebes/app/modules/login/auth_model.dart';
import 'package:bebes/app/modules/login/controllers/auth_controller_controller.dart';
import 'package:bebes/app/services/auth/index.dart';
import 'package:bebes/app/services/graphql/queries/index.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphAPIClient {
  static GraphAPIClient client = GraphAPIClient._internal();
  final AuthService _authService = AuthService();
  final AuthController ac = AuthController();
  late final _;
  GraphAPIClient._internal() {
    try {
      final HttpLink httpLink = HttpLink("${Env.serverUrl}/graphql");
      final AuthLink authLink = AuthLink(getToken: () async {
        final SharedPreferences _ = await SharedPreferences.getInstance();
        final auth = await _authService.getAuth();
        print("auth $auth");
        final token = auth!.toJson()["token"];
        return "Bearer $token";
      });
      final Link link = authLink.concat(httpLink);
      // print("link ${link.toString()}");
      _ = GraphQLClient(
          link: link, cache: GraphQLCache(store: InMemoryStore()));
    } catch (error) {
      print("36 error $error");
    }
  }
  Future refreshToken() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      final cj =
          PersistCookieJar(storage: FileStorage("$appDocPath/./cookies/"));
      final cookies = await cj.loadForRequest(Uri.parse(Env.serverUrl));
      // dio.options.baseUrl = "${Env.serverUrl}/api";
      final response = await _.query(QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(refreshTokenQuery),
          variables: {"refreshToken": cookies[0].toString()}));
      final objectToken = response.data!["refreshtoken"];
      objectToken.removeWhere((key, value) => key == "__typename");
      await _authService.saveAuth(objectToken);
    } catch (error) {
      print("50 error $error");
      ac.logOut();
    }
  }

  Future muation() async {
    final response = await _.query(
        QueryOptions(document: gql(""), fetchPolicy: FetchPolicy.networkOnly));
    return Future(() {});
  }

  Future query(String query, [Map<String, dynamic>? variables]) async {
    dynamic response;
    if (variables != null) {
      response = await _
          .query(QueryOptions(document: gql(query), variables: variables));
    } else {
      response = await _.query(QueryOptions(document: gql(query)));
    }
    if (response.hasException) {
      switch (response.exception!.graphqlErrors[0].message) {
        case "Unauthorized":
          await refreshToken();
          GraphAPIClient.client = GraphAPIClient._internal();
          return GraphAPIClient.client.query(query, variables);
        default:
          print(response.exception!.graphqlErrors[0].message);
      }
    }
    return response.data;
  }
}
