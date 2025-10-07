class BmiRecord {
  final String userId;
  final double heightMeters; // height in meters
  final double weightKg; // weight in kg
  final double bmi;
  final DateTime recordedAt;

  const BmiRecord({
    required this.userId,
    required this.heightMeters,
    required this.weightKg,
    required this.bmi,
    required this.recordedAt,
  });

  static double calculateBmi({required double heightMeters, required double weightKg}) {
    if (heightMeters <= 0) return 0;
    return weightKg / (heightMeters * heightMeters);
  }

  static String classify(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obesity';
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'heightMeters': heightMeters,
        'weightKg': weightKg,
        'bmi': bmi,
        'recordedAt': recordedAt.toIso8601String(),
      };

  factory BmiRecord.fromJson(Map<String, dynamic> json) => BmiRecord(
        userId: json['userId'] as String,
        heightMeters: (json['heightMeters'] as num).toDouble(),
        weightKg: (json['weightKg'] as num).toDouble(),
        bmi: (json['bmi'] as num).toDouble(),
        recordedAt: DateTime.parse(json['recordedAt'] as String),
      );
}
