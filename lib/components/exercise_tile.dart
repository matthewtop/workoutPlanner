import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String series;
  final String reps;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.series,
    required this.reps,
    required this.isCompleted,
    required void Function(dynamic val) onCheckBoxChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: ListTile(
        title: Text(
          exerciseName,
        ),
        subtitle: Row(
          children: [
            //weight
            Chip(
              label: Text("$weight kg"),
            ),

            //series
            Chip(
              label: Text("$series series"),
            ),

            //reps
            Chip(
              label: Text("$reps reps"),
            ),
          ],
        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: (value) => onCheckBoxChanged!(value),
        ),
      ),
    );
  }
}
