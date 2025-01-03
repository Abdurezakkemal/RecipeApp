class MealPlanModel {
  String? id;
  String userId;
  DateTime date;
  List<String> meals;

  MealPlanModel({
    this.id,
    required this.userId,
    required this.date,
    required this.meals,
  });

  // Convert MealPlanModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date.toIso8601String(),
      'meals': meals,
    };
  }

  // Copy the current instance with updated values
  MealPlanModel copyWith({
    String? id,
    String? userId,
    DateTime? date,
    List<String>? meals,
  }) {
    return MealPlanModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      meals: meals ?? this.meals,
    );
  }

  // Create MealPlanModel from Firestore JSON
  factory MealPlanModel.fromJson(Map<String, dynamic> json, String id) {
    return MealPlanModel(
      id: id,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      meals: List<String>.from(json['meals'] as List),
    );
  }
}
