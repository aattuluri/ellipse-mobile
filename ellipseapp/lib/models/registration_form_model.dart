class RegistrationFormModel {
  final String title, field;
  final List options;

  const RegistrationFormModel({
    this.title,
    this.field,
    this.options,
  });

  factory RegistrationFormModel.fromJson(Map<String, dynamic> json) {
    return RegistrationFormModel(
        title: json['title'], field: json['field'], options: json['options']);
  }
}
