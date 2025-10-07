class MedicineSchedule {
  final String id;
  final String userId;
  final String medicineName;
  final String dosage;
  final String instructions;
  final DateTime nextDoseAt;
  final bool enabled;

  const MedicineSchedule({
    required this.id,
    required this.userId,
    required this.medicineName,
    required this.dosage,
    required this.instructions,
    required this.nextDoseAt,
    this.enabled = true,
  });

  MedicineSchedule copyWith({
    String? medicineName,
    String? dosage,
    String? instructions,
    DateTime? nextDoseAt,
    bool? enabled,
  }) {
    return MedicineSchedule(
      id: id,
      userId: userId,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      instructions: instructions ?? this.instructions,
      nextDoseAt: nextDoseAt ?? this.nextDoseAt,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'medicineName': medicineName,
        'dosage': dosage,
        'instructions': instructions,
        'nextDoseAt': nextDoseAt.toIso8601String(),
        'enabled': enabled,
      };

  factory MedicineSchedule.fromJson(Map<String, dynamic> json) => MedicineSchedule(
        id: json['id'] as String,
        userId: json['userId'] as String,
        medicineName: json['medicineName'] as String,
        dosage: json['dosage'] as String,
        instructions: json['instructions'] as String,
        nextDoseAt: DateTime.parse(json['nextDoseAt'] as String),
        enabled: json['enabled'] as bool? ?? true,
      );
}
