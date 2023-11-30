import 'package:capstone/ans/ansEditController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AnsEditPage extends StatefulWidget {
  const AnsEditPage({Key? key, required this.articleId, required this.answerId})
      : super(key: key);

  final String articleId;
  final String answerId; // Added answerId

  @override
  State<AnsEditPage> createState() => _AnsEditPageState();
}

class _AnsEditPageState extends State<AnsEditPage> {
  late AnsEditController controller;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AnsEditController(widget.articleId, widget.answerId));
    textController = TextEditingController(text: controller.content.value);
    ever(controller.content, (_) {
      textController.text = controller.content.value;
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
                  children: [
                    Divider(color: Colors.grey.withOpacity(0.5)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: TextField(
                          controller: textController,
                          onChanged: (val) => controller.content.value = val,
                          cursorColor: const Color.fromARGB(255, 104, 0, 123),
                          cursorHeight: 16,
                          cursorWidth: 1,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isCollapsed: true,
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
                          Container(
                            margin: const EdgeInsets.only(left: 20, bottom: 10),
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
                                  '답변 수정 시 이미지는 수정할 수 없습니다.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(200, 157, 0, 0),
                                  ),
                                ),
                              ],
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
}
