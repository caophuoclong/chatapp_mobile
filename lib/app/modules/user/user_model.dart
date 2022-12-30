class User {
  String? sId;
  String? name;
  String? username;
  String? email;
  String? phone;
  String? avatarUrl;
  String? birthday;
  int? lastOnline;
  String? gender;
  String? active;

  User(
      {this.sId,
      this.name,
      this.username,
      this.email,
      this.phone,
      this.avatarUrl,
      this.birthday,
      this.lastOnline,
      this.gender,
      this.active});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    avatarUrl = json['avatarUrl'];
    birthday = json['birthday'];
    lastOnline = json['lastOnline'];
    gender = json['gender'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['phone'] = phone;
    data['avatarUrl'] = avatarUrl;
    data['birthday'] = birthday;
    data['lastOnline'] = lastOnline;
    data['gender'] = gender;
    data['active'] = active;
    return data;
  }
}
