import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GroupAddController extends GetxController {
  // Firestore 인스턴스
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addGroup(
      String category, String groupName, String purpose, int members) async {
    await firestore.collection('groups').add({
      'category': category,
      'groupName': groupName,
      'purpose': purpose,
      'members': members,
    });
  }
}
