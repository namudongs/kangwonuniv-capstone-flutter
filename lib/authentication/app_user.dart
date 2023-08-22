class AppUser {
  final String uid;
  final String email;
  final String userName;
  final int grade;
  final String major;

  AppUser({
    required this.uid,
    required this.email,
    required this.userName,
    required this.grade,
    required this.major,
  });

  // JSON 형식으로 변환
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'grade': grade,
      'major': major,
    };
  }

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      grade: map['grade'],
      major: map['major'],
    );
  }
}
