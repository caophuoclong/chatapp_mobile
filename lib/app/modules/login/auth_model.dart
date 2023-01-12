import 'dart:ffi';

class Auth {
  String? _token;
  String? userId;
  int? expired;

  Auth(String token, {this.userId}) {
    _token = token;
  }
  String? get token => _token;
  Auth.fromJson(Map<String, dynamic> json) {
    _token = json['token'];
    userId = json['userId'];
    expired = json["expired_time"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = _token;
    data['userId'] = userId;
    data['expired_time'] = expired;
    return data;
  }
}
