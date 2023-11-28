import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AnsController extends GetxController {
  final Rx<List<DocumentSnapshot>> articleList = Rx<List<DocumentSnapshot>>([]);
  final Rx<Map<String, DocumentSnapshot?>> acceptedAnswers =
      Rx<Map<String, DocumentSnapshot?>>({});

  @override
  void onInit() {
    super.onInit();
    streamQuestions();
  }

  void streamQuestions() {
    FirebaseFirestore.instance
        .collection('articles')
        .orderBy('created_at', descending: true)
        .snapshots()
        .listen((snapshot) {
      articleList.value = snapshot.docs;
      // 각 질문에 대한 채택된 답변 또는 대체 답변을 가져옵니다.
      for (var doc in snapshot.docs) {
        getAcceptedOrBestAnswer(doc.id).then((bestAnswer) {
          acceptedAnswers.value[doc.id] = bestAnswer;
          acceptedAnswers.refresh(); // 상태를 업데이트합니다.
        });
      }
    });
  }

  Future<DocumentSnapshot?> getAcceptedOrBestAnswer(String articleId) async {
    try {
      // 먼저 질문 문서를 조회하여 'is_adopted' 필드 확인
      var articleSnapshot = await FirebaseFirestore.instance
          .collection('articles')
          .doc(articleId)
          .get();

      bool isAdopted = articleSnapshot.data()?['is_adopted'] ?? false;

      if (isAdopted) {
        // 채택된 답변 찾기
        var acceptedAnswerSnapshot = await FirebaseFirestore.instance
            .collection('articles')
            .doc(articleId)
            .collection('answer')
            .where('is_adopted', isEqualTo: true)
            .limit(1)
            .get();

        if (acceptedAnswerSnapshot.docs.isNotEmpty) {
          return acceptedAnswerSnapshot.docs.first;
        }
      }

      // 채택된 답변이 없다면
      var bestAnswerSnapshot = await FirebaseFirestore.instance
          .collection('articles')
          .doc(articleId)
          .collection('answer')
          .orderBy('created_at', descending: true)
          .get();

      for (var answer in bestAnswerSnapshot.docs) {
        if (articleSnapshot.data()?['user']['uid'] !=
            answer.data()['user']['uid']) {
          return answer;
        } else {
          continue;
        }
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }
}
