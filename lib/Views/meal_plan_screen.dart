import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/Models/meal_plan_model.dart';
import 'package:recipeapp/Provider/meal_plan_provider.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mealPlanProvider = Provider.of<MealPlanProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
        backgroundColor: const Color.fromARGB(255, 2, 124, 109),
      ),
      body: Column(
        children: [
          // Calendar view
          CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            onDateChanged: (date) {
              mealPlanProvider.setSelectedDate(date);
            },
          ),
          Expanded(
            child: FutureBuilder<List<MealPlanModel>>(
              future: mealPlanProvider.fetchMealPlans(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final mealPlans = snapshot.data ?? [];
                if (mealPlans.isEmpty) {
                  return const Center(
                    child: Text('No meal plans for this day.'),
                  );
                }

                return ListView.builder(
                  itemCount: mealPlans.length,
                  itemBuilder: (context, index) {
                    final mealPlan = mealPlans[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          mealPlan.date.toLocal().toString().split(' ')[0],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              mealPlan.meals.map((meal) => Text(meal)).toList(),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Color.fromARGB(255, 11, 165, 153)),
                              onPressed: () {
                                _showEditMealPlanDialog(
                                    context, mealPlanProvider, mealPlan);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 5, 147, 123)),
                              onPressed: () {
                                mealPlanProvider.deleteMealPlan(mealPlan.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMealPlanDialog(context, mealPlanProvider);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 9, 177, 166),
      ),
    );
  }

  void _showAddMealPlanDialog(
      BuildContext context, MealPlanProvider mealPlanProvider) {
    final TextEditingController mealController = TextEditingController();
    final List<String> meals = [];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Meal Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: mealController,
                decoration: const InputDecoration(hintText: 'Enter meal'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  meals.add(mealController.text);
                  mealController.clear();
                },
                child: const Text('Add Meal'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                mealPlanProvider.addMealPlan(MealPlanModel(
                  userId: 'unique_user_id', // Replace with actual user ID
                  date: mealPlanProvider.selectedDate,
                  meals: meals,
                ));
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditMealPlanDialog(BuildContext context,
      MealPlanProvider mealPlanProvider, MealPlanModel mealPlan) {
    final TextEditingController mealController = TextEditingController();
    final List<String> meals = List.from(mealPlan.meals);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Meal Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: mealController,
                decoration: const InputDecoration(hintText: 'Enter meal'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  meals.add(mealController.text);
                  mealController.clear();
                },
                child: const Text('Add Meal'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                mealPlanProvider
                    .updateMealPlan(mealPlan.copyWith(meals: meals));
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
