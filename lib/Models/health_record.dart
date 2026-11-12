class HealthRecord {
  final int id;
  final DateTime date;
  final int steps;
  final int calories;
  final int water;

  const HealthRecord({
    required this.id,
    required this.date,
    required this.steps,
    required this.calories,
    required this.water,
  });

  HealthRecord copyWith({
    int? id,
    DateTime? date,
    int? steps,
    int? calories,
    int? water,
  }) {
    return HealthRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      water: water ?? this.water,
    );
  }
}
