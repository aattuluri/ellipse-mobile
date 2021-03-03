import 'dart:convert';

import 'package:EllipseApp/providers/index.dart';

import 'index.dart';

class Events {
  final String eventId,
      userId,
      collegeId,
      collegeName,
      name,
      about,
      description,
      imageUrl,
      eventType,
      eventMode,
      paymentType,
      venue,
      venueType,
      registrationFee,
      platformDetails,
      regMode,
      regLink,
      shareLink,
      rules,
  themes,
      status;
  final Object certificate, teamSize;
  final List filters;
  final bool oAllowed, registered, isTeamed, admin, moderator, user;
  final List requirements, tags, regFields, moderators, prizes;
  final List<RoundModel> rounds;
  final DateTime startTime, finishTime, regLastDate, postedOn;

  Events(
      {this.eventId,
      this.userId,
      this.collegeId,
      this.collegeName,
      this.name,
      this.about,
      this.description,
      this.imageUrl,
      this.eventType,
      this.eventMode,
      this.regMode,
      this.paymentType,
      this.venue,
      this.venueType,
      this.requirements,
      this.tags,
        this.themes,
      this.registrationFee,
      this.platformDetails,
      this.oAllowed,
      this.regLink,
      this.startTime,
      this.finishTime,
      this.regFields,
      this.regLastDate,
      this.registered,
      this.certificate,
      this.isTeamed,
      this.teamSize,
      this.shareLink,
      this.status,
      this.admin,
      this.user,
      this.rounds,
      this.rules,
      this.prizes,
      this.moderator,
      this.moderators,
      this.filters,
      this.postedOn});

  factory Events.fromJson(Map<String, dynamic> json) {
    String sTime = json['start_time'];
    String fTime = json['finish_time'];
    String rLTime = json['registration_end_time'];
    return Events(
        eventId: json['_id'],
        userId: json['user_id'],
        collegeId: json['college_id'],
        collegeName: json['college_name'],
        name: json['name'],
        about: json['about'],
        description: json['description'],
        imageUrl: json['poster_url'],
        moderators: json['moderators'],
        eventType: json['event_type'],
        eventMode: json['event_mode'],
        regMode: json['reg_mode'],
        paymentType: json['fee_type'],
        venue: json['venue'],
        venueType: json['venue_type'],
        requirements: json['requirements'],
        tags: json['tags'],
        registrationFee: json['fee'].toString(),
        platformDetails: json['platform_details'].toString(),
        oAllowed: json['o_allowed'],
        regFields: json['reg_fields'],
        regLink: json['reg_link'],
        status: json['status'],
        rounds: [for (final item in json['rounds']) RoundModel.fromJson(item)],
        certificate: json['certificate'],
        isTeamed: json['isTeamed'],
        teamSize: json['team_size'],
        shareLink: json['share_link'],
        registered: json['registered'],
        rules: json['rules'],
        themes: json['themes'],
        prizes: json['prizes'],
        startTime: DateTime.parse(sTime).toLocal(),
        finishTime: DateTime.parse(fTime).toLocal(),
        regLastDate: DateTime.parse(rLTime).toLocal(),
        filters: [
          json['college_id'].toString(),
          json['reg_mode'].toString(),
          json['fee_type'].toString()
        ],
        user:
            (json['user_id'] != prefId && !json['moderators'].contains(prefId)),
        admin: json['user_id'] == prefId,
        moderator: json['moderators'].contains(prefId));
  }
  List<FormFieldModel> parseRoundFields(String title) {
    List<FormFieldModel> formFields = [];
    for (var i = 0; i < rounds.length; i++) {
      if (rounds[i].title == title) {
        formFields = rounds[i].fields;
      }
    }
    return formFields;
  }

  List<FormFieldModel> parseRegFields() {
    List<FormFieldModel> formFields = [];
    formFields = [for (final item in regFields) FormFieldModel.fromJson(item)];
    return formFields;
  }

  TeamSize parseTeamSize() {
    Map<String, dynamic> tS = teamSize;
    TeamSize eventTeamSize = TeamSize(
        minSize: tS['min_team_size'].toString(),
        maxSize: tS['max_team_size'].toString());
    return eventTeamSize;
  }
}
