import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'index.dart';

class Events {
  final String id,
      user_id,
      college_id,
      name,
      description,
      imageUrl,
      event_type,
      event_mode,
      payment_type,
      venue,
      registration_fee,
      platform_link,
      o_allowed,
      reg_link,
      start_time,
      finish_time,
      reg_last_date;

  const Events({
    this.id,
    this.user_id,
    this.college_id,
    this.name,
    this.description,
    this.imageUrl,
    this.event_type,
    this.event_mode,
    this.payment_type,
    this.venue,
    this.registration_fee,
    this.platform_link,
    this.o_allowed,
    this.reg_link,
    this.start_time,
    this.finish_time,
    this.reg_last_date,
  });

  factory Events.fromJson(Map<String, dynamic> json) {
    return Events(
        id: json['_id'],
        user_id: json['user_id'],
        college_id: json['college'],
        name: json['name'],
        description: json['description'],
        imageUrl: json['posterUrl'],
        event_type: json['eventType'],
        event_mode: json['eventMode'],
        payment_type: json['feesType'],
        venue: json['about'],
        registration_fee: json['fees'],
        platform_link: json['about'],
        o_allowed: json['o_allowed'],
        reg_link: json['regLink'],
        start_time: json['start_time'],
        finish_time: json['finish_time'],
        reg_last_date: json['registrationEndTime']);
  }
}
