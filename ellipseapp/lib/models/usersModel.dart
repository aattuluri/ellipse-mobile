class Users {
  final String id, name, userId, userName, email;
  const Users({
    this.id,
    this.name,
    this.userId,
    this.userName,
    this.email,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        id: json['_id'],
        email: json['email'],
        name: json['name'],
        userId: json['user_id'],
        userName: json['username']);
  }
}
