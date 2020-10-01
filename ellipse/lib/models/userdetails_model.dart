class UserDetails {
  final String id,
      name,
      email,
      userid,
      username,
      gender,
      profile_pic,
      college_name,
      college_id,
      bio,
      designation;

  const UserDetails({
    this.id,
    this.name,
    this.email,
    this.userid,
    this.username,
    this.gender,
    this.profile_pic,
    this.college_name,
    this.college_id,
    this.bio,
    this.designation,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
        id: json['_id'],
        name: json['name'],
        userid: json['user_id'],
        email: json['email'],
        username: json['username'],
        gender: json['gender'],
        profile_pic: json['profile_pic'],
        bio: json['bio'],
        designation: json['designation'],
        college_id: json['college_id'],
        college_name: json['college_name']);
  }
}
