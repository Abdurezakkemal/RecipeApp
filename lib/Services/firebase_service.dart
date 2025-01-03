import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipeapp/Models/meal_plan_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MealPlanModel>> getMealPlans(DateTime date) async {
    try {
      final snapshot = await _firestore
          .collection('mealPlans')
          .where('date', isEqualTo: date.toIso8601String())
          .get();

      return snapshot.docs
          .map((doc) => MealPlanModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch meal plans: $e');
    }
  }

  Future<void> addMealPlan(MealPlanModel mealPlan) async {
    try {
      await _firestore.collection('mealPlans').add(mealPlan.toJson());
    } catch (e) {
      throw Exception('Failed to add meal plan: $e');
    }
  }

  Future<void> updateMealPlan(MealPlanModel mealPlan) async {
    try {
      await _firestore
          .collection('mealPlans')
          .doc(mealPlan.id)
          .update(mealPlan.toJson());
    } catch (e) {
      throw Exception('Failed to update meal plan: $e');
    }
  }

  Future<void> deleteMealPlan(String mealPlanId) async {
    try {
      await _firestore.collection('mealPlans').doc(mealPlanId).delete();
    } catch (e) {
      throw Exception('Failed to delete meal plan: $e');
    }
  }
}
