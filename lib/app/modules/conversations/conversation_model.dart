class Conversation {
  String? sId;
  String? name;
  String? type;
  bool? visible;
  String? avatarUrl;
  bool? isBlocked;
  bool? isDeleted;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  dynamic owner;
  dynamic blockBy;
  String? lastMessage;
  String? friendShip;
  List<String>? participants;

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
      this.participants});

  Conversation.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    type = json['type'];
    visible = json['visible'];
    avatarUrl = json['avatarUrl'];
    isBlocked = json['isBlocked'];
    isDeleted = json['isDeleted'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    owner = json['owner'];
    blockBy = json['blockBy'];
    lastMessage = json['lastMessage'];
    friendShip = json['friendShip'];
    participants = json['participants'].cast<String>();
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
    data['participants'] = participants;
    return data;
  }
}
