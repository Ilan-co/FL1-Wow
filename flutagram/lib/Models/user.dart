class User {
  User({this.uid});

  final String uid;
}

class UserData {
  UserData(
      {this.uid,
      this.location,
      this.picture,
      this.name,
      this.followers,
      this.follows});

  final String uid;
  final String name;
  final String location;
  final String picture;
  final List<dynamic> followers;
  final List<dynamic> follows;
}
