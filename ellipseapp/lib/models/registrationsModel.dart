class Registrations {
  final String registrationId,
      userId,
      eventId,
      teamId,
      status,
      certificateUrl,
      certificateStatus,
      shareId,
      time;
  final List sentRequests;
  final Object data;
  final bool teamedUp;
  const Registrations({
    this.registrationId,
    this.userId,
    this.eventId,
    this.teamedUp,
    this.teamId,
    this.status,
    this.certificateUrl,
    this.certificateStatus,
    this.data,
    this.shareId,
    this.sentRequests,
    this.time,
  });

  factory Registrations.fromJson(Map<String, dynamic> json) {
    return Registrations(
        registrationId: json['_id'],
        userId: json['user_id'],
        eventId: json['event_id'],
        teamedUp: json['teamed_up'],
        teamId: json['team_id'],
        status: json['status'],
        certificateUrl: json['certificate_url'],
        certificateStatus: json['certificate_status'],
        shareId: json['share_id'],
        sentRequests: json['sent_requests'],
        data: json['data'],
        time: json['time'].toString());
  }
}
