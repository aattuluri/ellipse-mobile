class UserDetails {
  final String name,
      email,
      userId,
      username,
      gender,
      profilePic,
      collegeName,
      collegeId,
      bio,
      designation;

  const UserDetails({
    this.name,
    this.email,
    this.userId,
    this.username,
    this.gender,
    this.profilePic,
    this.collegeName,
    this.collegeId,
    this.bio,
    this.designation,
  });

  factory UserDetails.fromMap(Map<String, dynamic> json) {
    return new UserDetails(
        name: json['name'],
        userId: json['user_id'],
        email: json['email'],
        username: json['username'],
        gender: json['gender'],
        profilePic: json['profile_pic'],
        bio: json['bio'],
        designation: json['designation'],
        collegeId: json['college_id'],
        collegeName: json['college_name']);
  }

  Map<String, dynamic> toMap() => {
        "name": name,
        "userId": userId,
        "email": email,
        "username": username,
        "gender": gender,
        "profilePic": profilePic,
        "bio": bio,
        "designation": designation,
        "collegeId": collegeId,
        "collegeName": collegeName,
      };

  fromMap(Map<String, dynamic> json) {
    return new UserDetails(
        name: json['name'],
        userId: json['user_id'],
        email: json['email'],
        username: json['username'],
        gender: json['gender'],
        profilePic: json['profile_pic'],
        bio: json['bio'],
        designation: json['designation'],
        collegeId: json['college_id'],
        collegeName: json['college_name']);
  }
}
