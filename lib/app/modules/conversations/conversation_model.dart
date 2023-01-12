import 'package:bebes/app/modules/user/user_model.dart';

class Conversation {
  String? sId;
  String? name;
  String? type;
  String? visible;
  String? avatarUrl;
  bool? isBlocked;
  bool? isDeleted;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Map<String, dynamic>? owner;
  dynamic blockBy;
  Map<String, dynamic>? lastMessage;
  Map<String, dynamic>? friendShip;
  List<User>? members;

  Conversation(
      {this.sId,
      this.name,
      this.type,
      this.visible,
      this.avatarUrl,
      this.isBlocked,
      this.isDeleted,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.owner,
      this.blockBy,
      this.lastMessage,
      this.friendShip,
      this.members});

  Conversation.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? "null";
    name = json['name'] ?? "null";
    type = json['type'] ?? "null";
    visible = json['visible'] ?? "null";
    avatarUrl = json['avatarUrl'] ?? "null";
    isBlocked = json['isBlocked'] ?? false;
    isDeleted = json['isDeleted'] ?? false;
    deletedAt = json['deletedAt'] ?? "null";
    createdAt = json['createdAt'] ?? "null";
    updatedAt = json['updatedAt'] ?? "null";
    owner = json['owner'].runtimeType != Map ? {} : json['owner'];
    blockBy = json['blockBy'];
    lastMessage =
        json['lastMessage'].runtimeType != Map ? {} : json['lastMessage'];
    friendShip =
        json['friendShip'].runtimeType != Map ? {} : json['friendShip'];
    members =
        json['members'].runtimeType != (List<User>) ? [] : json['members'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['type'] = type;
    data['visible'] = visible;
    data['avatarUrl'] = avatarUrl;
    data['isBlocked'] = isBlocked;
    data['isDeleted'] = isDeleted;
    data['deletedAt'] = deletedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['owner'] = owner;
    data['blockBy'] = blockBy;
    data['lastMessage'] = lastMessage;
    data['friendShip'] = friendShip;
    data['members'] = members;
    return data;
  }
}
