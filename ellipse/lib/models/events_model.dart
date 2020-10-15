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
      reg_link,
      share_link,
      status;
  bool registered;
  final bool o_allowed;
  final List requirements, tags, reg_fields;
  final DateTime start_time, finish_time, reg_last_date, posted_on;

  Events(
      {this.id,
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
      this.o_allowed,
      this.reg_link,
      this.start_time,
      this.finish_time,
      this.reg_fields,
      this.reg_last_date,
      this.registered,
      this.share_link,
      this.status,
      this.posted_on});

  factory Events.fromJson(Map<String, dynamic> json) {
    String s_time = json['start_time'];
    String f_time = json['finish_time'];
    String r_l_time = json['registration_end_time'];
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
        venue: json['venue'],
        requirements: json['requirements'],
        tags: json['tags'],
        registration_fee: json['fee'].toString(),
        platform_link: "",
        o_allowed: json['o_allowed'],
        reg_fields: json['reg_fields'],
        reg_link: json['reg_link'],
        start_time: DateTime.parse(s_time).toLocal(),
        finish_time: DateTime.parse(f_time).toLocal(),
        reg_last_date: DateTime.parse(r_l_time).toLocal(),
        registered: false);
  }
}
