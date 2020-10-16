class Registrations {
  final String id,
      user_id,
      event_id,
      status,
      certificateUrl,
      certificateStatus,
      shareId,
      time;
  final Object data;

  const Registrations({
    this.id,
    this.user_id,
    this.event_id,
    this.status,
    this.certificateUrl,
    this.certificateStatus,
    this.data,
    this.shareId,
    this.time,
  });

  factory Registrations.fromJson(Map<String, dynamic> json) {
    return Registrations(
        id: json['_id'],
        user_id: json['user_id'],
        event_id: json['event_id'],
        status: json['status'],
        certificateUrl: json['certificate_url'],
        certificateStatus: json['certificate_status'],
        shareId: json['share_id'],
        data: json['data'],
        time: json['time'].toString());
  }
}
