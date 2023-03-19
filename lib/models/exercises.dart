class Exercises {
  final String name;
  final String weight;
  final String series;
  final String reps;

  bool isCompleted;

  Exercises({
    required this.name,
    required this.weight,
    required this.series,
    required this.reps,
    this.isCompleted = false,
  });
}
