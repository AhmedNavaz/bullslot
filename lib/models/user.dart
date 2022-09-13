class UserLocal {
  String? id;
  String? name;
  String? email;
  String? dp;
  String? token;

  UserLocal({this.id, this.name, this.email, this.dp, this.token});

  // from json
  UserLocal.fromJson(Map<String, dynamic> json) {
    id = json['uid'];
    name = json['name'];
    email = json['email'];
    dp = json['dp'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'name': name,
      'email': email,
      'dp': dp,
      'token': token,
    };
  }
}
