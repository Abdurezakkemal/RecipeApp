import 'package:flutter/material.dart';
import 'package:recipeapp/Models/meal_plan_model.dart';
import 'package:recipeapp/Services/firebase_service.dart';

class MealPlanProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<List<MealPlanModel>> fetchMealPlans() async {
    try {
      final mealPlans = await _firebaseService.getMealPlans(_selectedDate);
      return mealPlans;
    } catch (e) {
      throw Exception('Failed to fetch meal plans: $e');
    }
  }

  Future<void> addMealPlan(MealPlanModel mealPlan) async {
    try {
      await _firebaseService.addMealPlan(mealPlan);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add meal plan: $e');
    }
  }

  Future<void> updateMealPlan(MealPlanModel updatedMealPlan) async {
    try {
      await _firebaseService.updateMealPlan(updatedMealPlan);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update meal plan: $e');
    }
  }

  Future<void> deleteMealPlan(String mealPlanId) async {
    try {
      await _firebaseService.deleteMealPlan(mealPlanId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete meal plan: $e');
    }
  }
}
