class AppGroup {
  late  String admin;

  final String groupIcon;

  final String groupId;

  final String groupName;

  final List<String> members;

  final String recentMessage;

  final String recentMessageSender;
  late String adminId;

  AppGroup(
      {required this.admin,
      required this.groupIcon,
      required this.groupId,
      required this.groupName,
      required this.members,
      required this.recentMessage,
      required this.recentMessageSender}) {
    setAdmin(admin);
  }

  void setAdmin(String admin) {
    List tmp = admin.split("_");
    (tmp != null && tmp.isNotEmpty)? this.admin = tmp[1]:this.admin =  "admin";
    (tmp != null && tmp.isNotEmpty)? adminId = tmp[0]:adminId =  "id";
  }
}
