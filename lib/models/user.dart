class AppUser {
  final String uId;

  final String email;

  final String fullName;

  final String profilePicture;

  final List<String> groups;

  AppUser(
      {required this.uId,
      required this.email,
      required this.fullName,
      required this.profilePicture,
      required this.groups});
}
