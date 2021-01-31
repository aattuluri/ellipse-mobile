class Notifications {
  final String notificationId, status, userId, eventId, title, description;
  final DateTime time;

  const Notifications({
    this.notificationId,
    this.status,
    this.userId,
    this.eventId,
    this.title,
    this.description,
    this.time,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    String t = json['time'];
    return Notifications(
        notificationId: json['_id'],
        status: json['status'],
        userId: json['user_id'],
        eventId: json['event_id'],
        title: json['title'],
        description: json['description'],
        time: DateTime.parse(t).toLocal());
  }
}
