import 'index.dart';
class Teams {
  final String teamId, name, userId, eventId, description;
  final DateTime time;
  final List members, receivedRequests, sentRequests;
  final List<SubmissionModel> submissions;
  const Teams({
    this.teamId,
    this.name,
    this.userId,
    this.eventId,
    this.description,
    this.members,
    this.receivedRequests,
    this.sentRequests,
    this.submissions,
    this.time,
  });

  factory Teams.fromJson(Map<String, dynamic> json) {
    String t = json['time'];
    return Teams(
        teamId: json['_id'],
        name: json['team_name'],
        userId: json['user_id'],
        eventId: json['event_id'],
        description: json['description'],
        members: json['members'],
        receivedRequests: json['received_requests'],
        sentRequests: json['sent_requests'],
        submissions: [
          for (final item in json['submissions']) SubmissionModel.fromJson(item)
        ],
        time: DateTime.parse(t).toLocal());
  }
}
