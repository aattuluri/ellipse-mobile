import 'index.dart';

class RoundModel {
  final String title, description, link;
  final DateTime startDate, endDate;
  final List<FormFieldModel> fields;
  const RoundModel(
      {this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.link,
      this.fields});
  factory RoundModel.fromJson(Map<String, dynamic> json) {
    return RoundModel(
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date'].toString()).toLocal(),
      endDate: DateTime.parse(json['end_date'].toString()).toLocal(),
      link: json['link'],
      fields: [
        for (final item in json['fields']) FormFieldModel.fromJson(item)
      ],
    );
  }
}
