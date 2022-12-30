class Contact {
  String? sId;
  StatusCode? statusCode;
  String? user;
  dynamic flag;

  Contact({this.sId, this.statusCode, this.user, this.flag});

  Contact.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    statusCode = json['statusCode'] != null
        ? StatusCode?.fromJson(json['statusCode'])
        : null;
    user = json['user'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = sId;
    if (statusCode != null) {
      data['statusCode'] = statusCode?.toJson();
    }
    data['user'] = user;
    data['flag'] = flag;
    return data;
  }
}

class StatusCode {
  String? code;
  String? name;

  StatusCode({this.code, this.name});

  StatusCode.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}
