class ChatMessage {
  String senderId;
  String receiverId;
  String senderName;
  String senderProfile;
  String receiverName;
  String receiverProfile;
  String message;
  DateTime timestamp;
  List<Map<String, String>> images; // 변경된 부분

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.senderProfile,
    required this.receiverName,
    required this.receiverProfile,
    required this.message,
    required this.timestamp,
    List<Map<String, String>>? images, // 변경된 부분
  }) : images = images ?? [];

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
      'images': images.map((imageInfo) => imageInfo).toList(), // 변경된 부분
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
      images: (map['images'] as List)
          .map((imageInfo) => Map<String, String>.from(imageInfo))
          .toList(), // 변경된 부분
    );
  }

  ChatMessage copyWith({List<Map<String, String>>? images}) {
    // 변경된 부분
    return ChatMessage(
      senderId: senderId,
      receiverId: receiverId,
      senderName: senderName,
      senderProfile: senderProfile,
      receiverName: receiverName,
      receiverProfile: receiverProfile,
      message: message,
      timestamp: timestamp,
      images: images ?? this.images,
    );
  }
}
