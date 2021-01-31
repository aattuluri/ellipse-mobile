class AnnouncementsModel {
  final String announcementId, title, description;
  final bool visible;
  final String time;

  const AnnouncementsModel(
      {this.announcementId,
      this.title,
      this.description,
      this.visible,
      this.time});

  factory AnnouncementsModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementsModel(
        announcementId: json['_id'],
        title: json['title'],
        description: json['description'],
        visible: json['visible_all'],
        time: json['time'].toString());
  }
}
