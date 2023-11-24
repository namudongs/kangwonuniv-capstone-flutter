import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectCategoryPage extends StatefulWidget {
  const SelectCategoryPage({super.key});

  @override
  State<SelectCategoryPage> createState() => _SelectCategoryPageState();
}

class _SelectCategoryPageState extends State<SelectCategoryPage> {
  final List<String> categories = ['카테고리 1', '카테고리 2', '카테고리 3'];

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
