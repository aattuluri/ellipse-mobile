import 'index.dart';

class SubmissionModel {
  final String title;
  final bool isSubmitted, submissionAccess;
  final Map<String, dynamic> submissionForm;
  const SubmissionModel(
      {this.title,
      this.isSubmitted,
      this.submissionAccess,
      this.submissionForm});

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> submissionFormMap = json['submission_form'];
    return SubmissionModel(
        title: json['title'],
        isSubmitted: json['is_submitted'],
        submissionAccess: json['submission_access'],
        submissionForm: submissionFormMap);
  }
  List<FilledData> parseFilledData(List<FormFieldModel> fFM) {
    Map<String, dynamic> dataMap = submissionForm;
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
