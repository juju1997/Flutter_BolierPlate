class UserModel {
  String id;
  String? pwd;
  String? email;

  UserModel({
    required this.id,
    this.pwd,
    this.email
  });

  UserModel.fromJson(Map<String, dynamic> json)
    : this(
      id:json['id']! as String,
      pwd:json['pwd']! as String,
      email:json['email']! as String
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pwd': pwd,
      'email': email
    };
  }

  @override
  String toString() {
    return 'id : $id , pwd : $pwd , email : $email';
  }
}