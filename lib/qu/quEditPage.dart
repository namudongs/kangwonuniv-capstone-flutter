import 'dart:io';

import 'package:capstone/components/utils.dart';
import 'package:capstone/qu/categoryController.dart';
import 'package:capstone/qu/quEditController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class QuEditPage extends StatefulWidget {
  const QuEditPage({Key? key, required this.articleId}) : super(key: key);

  final String articleId;

  @override
  State<QuEditPage> createState() => _QuEditPageState();
}

class _QuEditPageState extends State<QuEditPage> {
  final CategoryController categoryController = Get.put(CategoryController());
  late TextEditingController titleController;
  late TextEditingController contentController;
  late QuEditController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(QuEditController(widget.articleId));
    titleController = TextEditingController();
    contentController = TextEditingController();
    ever(controller.title, (_) {
      titleController.text = controller.title.value;
    });
    ever(controller.content, (_) {
      contentController.text = controller.content.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '수정하기',
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
          IconButton(
            icon: const Icon(
              Icons.check,
            ),
            onPressed: () {
              controller.saveForm();
            },
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        snackBar('오류', '카테고리는 수정할 수 없습니다.');
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Icon(Icons.arrow_forward_ios_rounded,
                                size: 14, color: Theme.of(context).hintColor),
                            const SizedBox(width: 4),
                            Obx(
                              () => Text(
                                controller.category.value,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.5)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: TextField(
                        controller: titleController,
                        onChanged: (value) => controller.title.value = value,
                        cursorColor: const Color.fromARGB(255, 104, 0, 123),
                        cursorWidth: 1,
                        cursorHeight: 19,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isCollapsed: true,
                          hintText: '제목(선택사항)',
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.5)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: TextField(
                          controller: contentController,
                          onChanged: (value) =>
                              controller.content.value = value,
                          cursorColor: const Color.fromARGB(255, 104, 0, 123),
                          cursorHeight: 16,
                          cursorWidth: 1,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isCollapsed: true,
                            hintText:
                                '궁금한 내용을 질문해보세요!\n\n이용 약관에 위반되거나 부적절한 질문은 삭제될 수 있습니다.\n채택된 답변이 있는 경우 질문을 수정 또는 삭제할 수 없습니다.',
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
                  _buildExistingImages(),
                  Divider(color: Colors.grey.withOpacity(0.5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(150, 157, 0, 0),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add,
                                      size: 13,
                                      color: Color.fromARGB(200, 157, 0, 0)),
                                  Text(
                                    '이미지',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color.fromARGB(200, 157, 0, 0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  Widget _buildExistingImages() {
    return Obx(() => Wrap(
          children: controller.existingImages.map((image) {
            return Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      image['url'],
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
                      onPressed: () => controller.removeExistingImage(image),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ));
  }
}
