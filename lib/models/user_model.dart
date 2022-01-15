class UserModel {
  String uid;
  String? email;
  String? pwd;

  UserModel({
    required this.uid,
    this.email,
    this.pwd
  });

  UserModel.fromJson(Map<String, dynamic> json)
    : this(
      uid:json['uid']! as String,
      email:json['email']! as String,
      pwd:json['pwd']! as String
  );

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'pwd': pwd,
    };
  }

  @override
  String toString() {
    return 'uid: $uid, email : $email ,pwd : $pwd';
  }
}