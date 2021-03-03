import 'index.dart';

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
  final List<SubmissionModel> submissions;
  final Map<String, dynamic> data;
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
    this.submissions,
    this.time,
  });

  factory Registrations.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> dataMap = json['data'];
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
        //submissions: json['submissions'],
        submissions: [
          for (final item in json['submissions']) SubmissionModel.fromJson(item)
        ],
        data: dataMap,
        time: json['time'].toString());
  }
  List<FilledData> parseFilledData(List<FormFieldModel> fFM) {
    Map<String, dynamic> dataMap = data;
    List<String> keys = dataMap.keys.toList();
    List<dynamic> values = dataMap.values.toList();
    List<FilledData> filledData = [];
    for (var i = 0; i < fFM.length; i++) {
      for (var j = 0; j < keys.length; j++) {
        if (fFM[i].title == keys[j]) {
          filledData.add(FilledData(
              field: fFM[i].field,
              key: keys[j].toString(),
              value: values[j].toString()));
        }
      }
    }
    return filledData;
  }
}
