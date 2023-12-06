import 'package:capstone/home/homeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectCategoryPage extends StatefulWidget {
  final String sourcePage;
  const SelectCategoryPage({super.key, required this.sourcePage});

  @override
  State<SelectCategoryPage> createState() => _SelectCategoryPageState();
}

class _SelectCategoryPageState extends State<SelectCategoryPage> {
  final List<String> categories = [
    '인문',
    '언어',
    '사회',
    '이학',
    '의약',
    '공학',
    '예체능',
    '교육',
    '기타',
    '대학생활',
  ];

  void handleCategorySelection(String category) {
    HomeController homeController = Get.put(HomeController());

    if (widget.sourcePage == 'ADD') {
      selectCategory(category);
    } else if (widget.sourcePage == 'INTERESTING') {
      homeController.saveCategory(category);
      Get.back();
    }
  }

  void selectCategory(String category) {
    Get.back(result: category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카테고리 선택'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            onTap: () {
              handleCategorySelection(categories[index]);
            },
          );
        },
      ),
    );
  }
}
