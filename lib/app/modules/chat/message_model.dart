import 'package:bebes/app/modules/conversations/conversation_model.dart';
import 'package:bebes/app/modules/user/user_model.dart';

class Message {
  String? sId;
  String? content;
  bool? isDeleted;
  String? createdAt;
  String? status;
  String? type;
  int? scale;
  bool? isRecall;
  User? sender;
  Conversation? destination;

  Message(
      {this.sId,
      this.content,
      this.isDeleted,
      this.createdAt,
      this.status,
      this.type,
      this.scale,
      this.isRecall,
      this.sender,
      this.destination});

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
    destination = json["destination"];
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
    data["destination"] = destination;
    return data;
  }
}
