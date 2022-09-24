class UserLocal {
  String? id;
  String? name;
  String? email;

  UserLocal({this.id, this.name, this.email});

  // from json
  UserLocal.fromJson(Map<String, dynamic> json) {
    id = json['uid'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'name': name,
      'email': email,
    };
  }
}
