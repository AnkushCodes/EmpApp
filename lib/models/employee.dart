class Employee {
  String name;
  String role;
  DateTime startDate;
  DateTime? endDate;

  Employee({
    required this.name,
    required this.role,
    required this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'role': role,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
  };

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    name: json['name'] as String,
    role: json['role'] as String,
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate'] as String),
  );
}
