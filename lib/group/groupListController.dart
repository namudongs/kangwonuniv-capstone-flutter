import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupListController extends GetxController {
  // groups 컬렉션의 스트림을 관찰하는 Rx<Stream<QuerySnapshot>>
  Rx<Stream<QuerySnapshot>> groupsStream =
      FirebaseFirestore.instance.collection('groups').snapshots().obs;
}
