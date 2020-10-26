class AnnouncementsModel {
  final String id, title, description;
  final bool visible;
  final String time;

  const AnnouncementsModel(
      {this.id, this.title, this.description, this.visible, this.time});

  factory AnnouncementsModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementsModel(
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        visible: json['visible_all'],
        time: json['time'].toString());
  }
}
