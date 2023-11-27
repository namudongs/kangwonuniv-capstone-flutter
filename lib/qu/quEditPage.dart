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
                children: [
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
                            onPressed: _pickVideo,
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
    if (image != null) {}
  }

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {}
  }
}
