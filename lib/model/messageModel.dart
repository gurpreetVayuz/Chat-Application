class MessageModel {
  final int? id;
  final String sender;
  final String content;
  final int timestamp;

  MessageModel({this.id, required this.sender, required this.content, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'content': content,
      'timestamp': timestamp,
    };
  }
}