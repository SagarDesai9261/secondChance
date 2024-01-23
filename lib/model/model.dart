class ChatPerson {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? lastMessage;
  final String? lastMessageTimestamp;

  ChatPerson({
    this.id,
    this.name,
    this.imageUrl,
    this.lastMessage,
    this.lastMessageTimestamp,
  });
}

class Message {
  final String id;
  final String text;
  final String senderId;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.text,
    required this.senderId,
    required this.timestamp,
  });
}
