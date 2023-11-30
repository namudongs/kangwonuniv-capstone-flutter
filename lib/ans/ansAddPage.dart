import 'dart:io';

import 'package:capstone/ans/ansAddController.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AnsAddPage extends StatefulWidget {
  const AnsAddPage({required this.articleId, Key? key}) : super(key: key);

  final String articleId;
  @override
  State<AnsAddPage> createState() => _AnsAddPageState();
}

class _AnsAddPageState extends State<AnsAddPage> {
  late AnsAddController controller =
      Get.put(AnsAddController(widget.articleId));
  late FocusNode contentFocusNode;

  CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  @override
  void initState() {
    super.initState();
    contentFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      contentFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    contentFocusNode.dispose(); // FocusNode 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '답변하기',
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: <Widget>[
          controller.isLoading.value
              ? const CircularProgressIndicator() // 로딩 중 로딩 인디케이터 표시
              : IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => controller.saveForm(widget.articleId),
                ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Divider(color: Colors.grey.withOpacity(0.5)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: TextField(
                          focusNode: contentFocusNode,
                          onChanged: (val) => controller.content.value = val,
                          cursorColor: const Color.fromARGB(255, 104, 0, 123),
                          cursorHeight: 16,
                          cursorWidth: 1,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isCollapsed: true,
                            hintText:
                                '답변 내용을 입력해주세요.\n\n이용 약관에 위반되거나 부적절한 답변은 삭제될 수 있습니다.\n질문과 무관한 답변 작성 시 이용이 제한될 수 있습니다.\n채택된 답변이 있는 경우 작성한 답변을 수정할 수 없습니다.',
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildSelectedImages(),
                  Divider(color: Colors.grey.withOpacity(0.5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.image),
                          ),
                          IconButton(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.video_call),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      controller.addImage(image); // 이미지 추가
    }
  }

  // 화면에 이미지 표시하는 위젯
  Widget _buildSelectedImages() {
    return Obx(() => Wrap(
          children: controller.selectedImages.map((image) {
            return Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(image.path),
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -20,
                    right: -20,
                    child: IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () => controller.removeImage(image), // 이미지 제거
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ));
  }
}
