class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String location;
  final String picture;
  final List<dynamic> followers;
  final List<dynamic> follows;

  UserData(
      {this.uid,
      this.location,
      this.picture,
      this.name,
      this.followers,
      this.follows});
}
