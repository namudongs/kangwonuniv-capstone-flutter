import 'package:capstone/components/imageViewer.dart';
import 'package:capstone/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:capstone/chat/chatController.dart';
import 'package:capstone/components/chatMessage.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomId;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String receiverName;
  final String senderProfile;
  final String receiverProfile;

  const ChatPage({
    Key? key,
    required this.chatRoomId,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.receiverName,
    required this.senderProfile,
    required this.receiverProfile,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatController _chatController = Get.put(ChatController());
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final currentUserUid = appUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅하기'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<ChatMessage>>(
                stream: _chatController.getChatMessages(widget.chatRoomId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var messages = snapshot.data!;
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        bool isOwnMessage =
                            messages[index].senderId == currentUserUid;
                        bool hasImage = messages[index].images.isNotEmpty;

                        return Align(
                          alignment: isOwnMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: isOwnMessage
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (hasImage) ...[
                                // 이미지가 있는 경우 이미지 표시
                                for (var imageInfo in messages[index].images)
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(ImageViewer(
                                          imageUrls: [imageInfo['url']!]));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          imageInfo['url']!,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                              ] else ...[
                                // 이미지가 없는 경우 텍스트 메시지 표시
                                Container(
                                  margin: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                                  padding: const EdgeInsets.all(10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    color: isOwnMessage
                                        ? const Color.fromARGB(40, 157, 0, 0)
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    messages[index].message,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                              // 프로필 이미지 표시
                              Container(
                                margin: EdgeInsets.only(
                                  left: isOwnMessage ? 0 : 16,
                                  right: isOwnMessage ? 16 : 0,
                                ),
                                height: 40,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                    isOwnMessage
                                        ? widget.senderProfile
                                        : widget.receiverProfile,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            _buildMessageInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration.collapsed(
                hintText: '메세지 보내기...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
          IconButton(
            icon: const Icon(Icons.photo_camera),
            onPressed: _pickAndSendImage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      ChatMessage message = ChatMessage(
        message: _messageController.text.trim(),
        senderId: widget.senderId,
        receiverId: widget.receiverId,
        senderName: widget.senderName,
        senderProfile: widget.senderProfile,
        receiverName: widget.receiverName,
        receiverProfile: widget.receiverProfile,
        timestamp: DateTime.now(),
        images: [], // 빈 이미지 리스트 초기화
      );

      _chatController.sendChatMessage(widget.chatRoomId, message);
      _messageController.clear();
    }
  }

  void _pickAndSendImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Map<String, String> fileInfo = await _chatController.uploadFile(image);
      String imageUrl = fileInfo['url'] ?? '';
      String imageFileName = fileInfo['fileName'] ?? '';

      if (imageUrl.isNotEmpty) {
        ChatMessage message = ChatMessage(
          senderId: widget.senderId,
          receiverId: widget.receiverId,
          senderName: widget.senderName,
          senderProfile: widget.senderProfile,
          receiverName: widget.receiverName,
          receiverProfile: widget.receiverProfile,
          timestamp: DateTime.now(),
          message: '',
          images: [
            {'url': imageUrl, 'fileName': imageFileName}
          ], // 이미지 URL과 파일명을 포함
        );

        _chatController.sendChatMessage(widget.chatRoomId, message);
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
