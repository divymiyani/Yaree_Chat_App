class Message {
  Message({
    required this.msg,
    required this.read,
    required this.toId,
    required this.type,
    required this.sent,
    required this.fromId,
  });
  late final String msg;
  late final String read;
  late final String toId;
  late final String sent;
  late final String fromId;
  late final Type type;

  Message.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    read = json['read'].toString();
    toId = json['told'].toString();
    sent = json['sent'].toString();
    fromId = json['fromId'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['read'] = read;
    data['told'] = toId;
    data['type'] = type.name;
    data['sent'] = sent;
    data['fromId'] = fromId;
    return data;
  }
}

enum Type { text, image }
