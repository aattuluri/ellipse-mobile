class Data1 {
  final String id, title, type;

  const Data1({
    this.id,
    this.title,
    this.type,
  });

  factory Data1.fromJson(Map<String, dynamic> json) {
    return Data1(
        id: json['_id'].toString(),
        title: json['title'].toString(),
        type: json['type'].toString());
  }
}
