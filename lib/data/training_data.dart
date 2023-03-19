import 'package:flutter/material.dart';
import 'package:workout_planner/data/hive_training_database.dart';
import 'package:workout_planner/models/exercises.dart';
import 'package:workout_planner/models/training.dart';
import 'package:workout_planner/time/date_time.dart';

class TrainingData extends ChangeNotifier {
  final db = HiveDatabase();
  List<Training> trainingList = [
    Training(
      name: "Klata",
      exercises: [
        Exercises(name: "klata", weight: "70kg", series: "3", reps: "8"),
      ],
    ),
  ];

  void initializeTrainingList() {
    if (db.previousDataExists()) {
      trainingList = db.readFromDatabase();
    } else {
      db.saveDataToDataBase(trainingList);
    }

    //load heatmap
    loadHeatMap();
  }

//get the list
  List<Training> getTrainingList() {
    return trainingList;
  }

  List<Exercises> numberOfExercisesInWorkout(String trainingName) {
    Training relevantTraining = getRelevantTraining(trainingName);

    return relevantTraining.exercises;
  }

  //add your workout
  void addTraining(String name) {
    trainingList.add(Training(name: name, exercises: []));

    notifyListeners();
    //save to database
    db.saveDataToDataBase(trainingList);
  }

  //adding exercises
  void addExercises(String trainingName, String exerciseName, String weight,
      String series, String reps) {
    //Training relevantTraining =
    //  trainingList.firstWhere((training) => training.name == trainingName);
    Training relevantTraining = getRelevantTraining(trainingName);

    relevantTraining.exercises.add(
      Exercises(name: exerciseName, weight: weight, series: series, reps: reps),
    );
    notifyListeners();
    //save tro db
    db.saveDataToDataBase(trainingList);
  }

  //checking
  void checkOffExercises(String trainingName, String exerciseName) {
    Exercises relevantExercise =
        getRelevantExercise(trainingName, exerciseName);

    //showing completeing the workout
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
    db.saveDataToDataBase(trainingList);
    loadHeatMap();
  }

  Training getRelevantTraining(String trainingName) {
    Training relevantTraining =
        trainingList.firstWhere((training) => training.name == trainingName);

    return relevantTraining;
  }

  //return exercise object, given workout name and name of the exercise
  Exercises getRelevantExercise(String trainingName, String exercisesName) {
    //finding training name
    Training relevantTraining = getRelevantTraining(trainingName);

    //finding exercises
    Exercises relevantExercises = relevantTraining.exercises
        .firstWhere((exercises) => exercises.name == exercisesName);
    return relevantExercises;
  }

//get start date
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> HeatMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());
    //how many days to laod
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //go from start to now and add completion status
    for (int i = 0; i < daysInBetween + 1; i++) {
      String ddmmyyyy =
          convertDateTimeToDDMMYYYY(startDate.add(Duration(days: i)));

      //completion 0 or 1
      int completionStatus = db.getCompletionStatus(ddmmyyyy);

      //year
      int year = startDate.add(Duration(days: i)).year;
      //month
      int month = startDate.add(Duration(days: i)).month;
      //day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(day, month, year): completionStatus
      };

      HeatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
