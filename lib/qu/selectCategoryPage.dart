import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectCategoryPage extends StatefulWidget {
  const SelectCategoryPage({super.key});

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
            onTap: () => selectCategory(categories[index]),
          );
        },
      ),
    );
  }
}
