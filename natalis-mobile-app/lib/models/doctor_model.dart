class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final String qualification;
  final int experienceYears;
  final String organizationName;
  final String organizationId;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.qualification,
    required this.experienceYears,
    required this.organizationName,
    required this.organizationId,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      qualification: json['qualification'] ?? '',
      experienceYears: json['experienceYears'] ?? 0,
      organizationName: json['organizationName'] ?? '',
      organizationId: json['organizationId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'qualification': qualification,
      'experienceYears': experienceYears,
      'organizationName': organizationName,
      'organizationId': organizationId,
    };
  }
}
