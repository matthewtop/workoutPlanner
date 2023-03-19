import 'package:workout_planner/models/exercises.dart';

class Training {
  final String name;
  final List<Exercises> exercises;

  Training({required this.name, required this.exercises});
}
