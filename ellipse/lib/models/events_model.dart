class Events {
  final String id, name;

  Events({
    this.id,
    this.name,
  });

  factory Events.fromJson(Map<String, dynamic> json) {
    return Events(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
