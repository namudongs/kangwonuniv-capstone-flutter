class ChatMessage {
  String senderId;
  String receiverId;
  String senderName;
  String senderProfile;
  String receiverName;
  String receiverProfile;
  String message;
  DateTime timestamp;
  List<String> images;

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.senderProfile,
    required this.receiverName,
    required this.receiverProfile,
    required this.message,
    required this.timestamp,
    this.images = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'senderProfile': senderProfile,
      'receiverName': receiverName,
      'receiverProfile': receiverProfile,
      'text': message,
      'timestamp': timestamp,
      'images': images,
    };
  }

  static ChatMessage fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      senderName: map['senderName'],
      senderProfile: map['senderProfile'],
      receiverName: map['receiverName'],
      receiverProfile: map['receiverProfile'],
      message: map['text'],
      timestamp: map['timestamp'].toDate(),
      images: List<String>.from(map['images'] ?? []),
    );
  }
}
