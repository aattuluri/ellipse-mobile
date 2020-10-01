class AnnouncementsModel {
  final String title, description;
  final bool visible;
  final String time;

  const AnnouncementsModel(
      {this.title, this.description, this.visible, this.time});

  factory AnnouncementsModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementsModel(
        title: json['title'],
        description: json['description'],
        visible: json['visible_all'],
        time: json['time'].toString());
  }
}
