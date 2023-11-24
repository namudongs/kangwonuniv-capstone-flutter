import 'package:get/get.dart';

class CategoryController extends GetxController {
  var selectedCategory = '카테고리'.obs;

  void updateCategory(String newCategory) {
    selectedCategory.value = newCategory;
  }
}
