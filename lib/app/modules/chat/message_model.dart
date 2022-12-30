class Message {
  String? sId;
  String? content;
  bool? isDeleted;
  String? createdAt;
  String? status;
  String? type;
  int? scale;
  bool? isRecall;
  String? sender;

  Message(
      {this.sId,
      this.content,
      this.isDeleted,
      this.createdAt,
      this.status,
      this.type,
      this.scale,
      this.isRecall,
      this.sender});

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    status = json['status'];
    type = json['type'];
    scale = json['scale'];
    isRecall = json['isRecall'];
    sender = json['sender'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = sId;
    data['content'] = content;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['status'] = status;
    data['type'] = type;
    data['scale'] = scale;
    data['isRecall'] = isRecall;
    data['sender'] = sender;
    return data;
  }
}
