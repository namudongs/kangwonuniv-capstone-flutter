class Group {
  String id;
  String name;
  String category;
  String targetTime;
  List<String> members;
  String adminName;
  int recruitment;

  Group({
    required this.id,
    required this.name,
    required this.category,
    required this.targetTime,
    required this.members,
    required this.adminName,
    required this.recruitment,
  });

  factory Group.fromMap(Map<String, dynamic> data) {
    return Group(
      id: data['id'],
      name: data['name'],
      category: data['category'],
      targetTime: data['targetTime'],
      members: List<String>.from(data['members']),
      adminName: data['adminName'],
      recruitment: data['recruitment'],
    );
  }
}