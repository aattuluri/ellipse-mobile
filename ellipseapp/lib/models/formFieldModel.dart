class FormFieldModel {
  final String title, field;
  final bool required;
  final List options;

  const FormFieldModel({
    this.required,
    this.title,
    this.field,
    this.options,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
        required: json['req'], title: json['title'], field: json['field'], options: json['options']);
  }
}
