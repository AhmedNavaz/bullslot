class UserLocal {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;

  UserLocal({this.id, this.name, this.email, this.phone, this.address});

  // from json
  UserLocal.fromJson(Map<String, dynamic> json) {
    id = json['uid'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }
}
