enum MaritalStatus { SINGLE, MARRIED, DIVORCED, WIDOWED }

enum BloodGroup { A_POS, A_NEG, B_POS, B_NEG, AB_POS, AB_NEG, O_POS, O_NEG }

class MotherModel {
  

  final String? id;
  final String? userId;
  final String organizationId;
  final String doctorId;


  final String name;
  final int age;
  final MaritalStatus maritalStatus;
  final BloodGroup bloodGroup;

  final DateTime lmp;
  final DateTime? edd;
  final int? gravida;
  final int? para;
  final bool highRisk;

  final Map<String, dynamic>? additionalMedicalInfo;

  const MotherModel({
    this.id,
    this.userId,
    required this.organizationId,
    required this.doctorId,
    required this.name,
    required this.age,
    required this.maritalStatus,
    required this.bloodGroup,
    required this.lmp,
    this.edd,
    this.gravida,
    this.para,
    this.highRisk = false,
    this.additionalMedicalInfo,
  });

  factory MotherModel.fromJson(Map<String, dynamic> json) {
    return MotherModel(
      id: json['id'],
      userId: json['userId'],
      organizationId: json['organizationId'],
      doctorId: json['doctorId'],
      name: json['name'],
      age: json['age'],
      maritalStatus: MaritalStatus.values.firstWhere(
        (e) => e.name == json['maritalStatus'],
      ),
      bloodGroup: BloodGroup.values.firstWhere(
        (e) => e.name == json['bloodGroup'],
      ),
      lmp: DateTime.parse(json['lmp']),
      edd: json['edd'] != null ? DateTime.parse(json['edd']) : null,
      gravida: json['gravida'],
      para: json['para'],
      highRisk: json['highRisk'] ?? false,
      additionalMedicalInfo: json['additionalMedicalInfo'] != null
          ? Map<String, dynamic>.from(json['additionalMedicalInfo'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "organizationId": organizationId,
      "doctorId": doctorId,
      "name": name,
      "age": age,
      "maritalStatus": maritalStatus.name,
      "bloodGroup": bloodGroup.name,
      "lmp": lmp.toIso8601String(),
      "edd": edd?.toIso8601String(),
      "gravida": gravida,
      "para": para,
      "highRisk": highRisk,
      "additionalMedicalInfo": additionalMedicalInfo,
    };
  }
}
