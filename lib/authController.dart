import 'package:capstone/authentication/mainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Rxn<User> firebaseUser = Rxn<User>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
  }

  void signOut() async {
    await _auth.signOut();
    Get.offAll(() => const MainPage());
  }

  bool get isUserLoggedIn => firebaseUser.value != null;
}
