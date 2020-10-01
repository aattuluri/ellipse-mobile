class Notifications {
  final String id, user_id, event_id, title, description;
  final DateTime time;

  const Notifications({
    this.id,
    this.user_id,
    this.event_id,
    this.title,
    this.description,
    this.time,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    String t = json['time'];
    return Notifications(
        id: json['_id'],
        user_id: json['user_id'],
        event_id: json['event_id'],
        title: json['title'],
        description: json['description'],
        time: DateTime.parse(t).toLocal());
  }
}
