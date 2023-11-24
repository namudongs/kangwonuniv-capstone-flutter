import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AnsController extends GetxController {
  final Rx<List<DocumentSnapshot>> articleList = Rx<List<DocumentSnapshot>>([]);

  @override
  void onInit() {
    super.onInit();
    FirebaseFirestore.instance
        .collection('articles')
        .orderBy('created_at', descending: true)
        .snapshots()
        .listen((snapshot) {
      articleList.value = snapshot.docs;
    });
  }
}
