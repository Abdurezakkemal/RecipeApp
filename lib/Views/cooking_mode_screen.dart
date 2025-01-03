import 'package:flutter/material.dart';
import 'dart:async';

class CookingModeScreen extends StatefulWidget {
  final List<String> steps;
  final int totalTime; // Total time to complete all steps in seconds

  const CookingModeScreen(
      {Key? key, required this.steps, required this.totalTime})
      : super(key: key);

  @override
  _CookingModeScreenState createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends State<CookingModeScreen> {
  late int timePerStep;
  int currentStepIndex = 0;
  int remainingTime = 0;
  List<bool> stepCompletion = [];
  Timer? timer;
  bool isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    timePerStep = (widget.totalTime / widget.steps.length).ceil();
    remainingTime = timePerStep;
    stepCompletion = List<bool>.filled(widget.steps.length, false);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      isTimerRunning = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime <= 0) {
        timer.cancel();
        setState(() {
          isTimerRunning = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Step ${currentStepIndex + 1} timer completed!')),
        );
      } else {
        setState(() {
          remainingTime--;
        });
      }
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      remainingTime = timePerStep;
      isTimerRunning = false;
    });
  }

  void checkCompletion() {
    if (stepCompletion.every((completed) => completed)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You have completed all the steps!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cooking Mode'),
        backgroundColor: const Color.fromARGB(255, 3, 122, 118),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.steps.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Step ${index + 1}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.steps[index],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade800,
                              decoration: stepCompletion[index]
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (index == currentStepIndex) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: isTimerRunning ? null : startTimer,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isTimerRunning
                                        ? Colors.grey
                                        : const Color.fromARGB(255, 5, 117, 125),
                                  ),
                                  child: Text(isTimerRunning
                                      ? 'Timer Running'
                                      : 'Start Timer'),
                                ),
                                Text(
                                  formatTime(remainingTime),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            CheckboxListTile(
                              value: stepCompletion[index],
                              onChanged: (value) {
                                setState(() {
                                  stepCompletion[index] = value!;
                                });
                                if (value!) {
                                  if (currentStepIndex <
                                      widget.steps.length - 1) {
                                    setState(() {
                                      currentStepIndex++;
                                      resetTimer();
                                    });
                                  }
                                  checkCompletion();
                                }
                              },
                              title: const Text('Mark Step as Completed'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
