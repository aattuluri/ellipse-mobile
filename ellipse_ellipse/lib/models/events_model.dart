import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'index.dart';

class Events {
  final String id,
      user_id,
      college_id,
      college_name,
      name,
      description,
      imageUrl,
      event_type,
      event_mode,
      payment_type,
      venue,
      registration_fee,
      platform_link,
      reg_mode,
      //o_allowed,
      reg_link,
      start_time,
      finish_time,
      reg_last_date;
  final List requirements, tags, reg_fields;

  const Events({
    this.id,
    this.user_id,
    this.college_id,
    this.college_name,
    this.name,
    this.description,
    this.imageUrl,
    this.event_type,
    this.event_mode,
    this.reg_mode,
    this.payment_type,
    this.venue,
    this.requirements,
    this.tags,
    this.registration_fee,
    this.platform_link,
    //this.o_allowed,
    this.reg_link,
    this.start_time,
    this.finish_time,
    this.reg_fields,
    this.reg_last_date,
  });

  factory Events.fromJson(Map<String, dynamic> json) {
    return Events(
        id: json['_id'],
        user_id: json['user_id'],
        college_id: json['college_id'],
        college_name: json['college_name'],
        name: json['name'],
        description: json['description'],
        imageUrl: json['poster_url'],
        event_type: json['event_type'],
        event_mode: json['event_mode'],
        reg_mode: json['reg_mode'],
        payment_type: json['fee_type'],
        venue: json['about'],
        requirements: json['requirements'],
        tags: json['tags'],
        registration_fee: json['fee'].toString(),
        platform_link: json['about'],
        //o_allowed: json['o_allowed'],
        reg_fields: json['reg_fields'],
        reg_link: json['reg_link'],
        start_time: json['start_time'],
        finish_time: json['finish_time'],
        reg_last_date: json['registration_end_time']);
  }
}
