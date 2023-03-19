import 'package:hive/hive.dart';
import 'package:workout_planner/models/exercises.dart';
import 'package:workout_planner/models/training.dart';
import 'package:workout_planner/time/date_time.dart';

class HiveDatabase {
  final _myBox = Hive.box("Training database");
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("previous database doesnt exist");
      _myBox.put("START DATE", todaysDate());
      return false;
    } else {
      print("previous data does exist");
      return true;
    }
  }

  String getStartDate() {
    return _myBox.get("START_DATE");
  }

//save
  void saveDataToDataBase(List<Training> trainings) {
    final trainingList = convertObjectsToTrainingList(trainings);
    final exercisesList = convertObjectsToExercisesList(trainings);

    if (exerciseCompleted(trainings)) {
      _myBox.put("COMPLETION_STATUS_${todaysDate()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todaysDate()}", 0);
    }

    //save into hive
    _myBox.put("TRAININGS", trainingList);
    _myBox.put("EXERCISES", exercisesList);
  }

  List<Training> readFromDatabase() {
    List<Training> mySavedTrainings = [];
    List<String> trainingNames = _myBox.get("TRAININGS");
    final exerciseDetails = _myBox.get("EXERCISES");

    //CREATE TRAINING OBJECTS
    for (int i = 0; i < trainingNames.length; i++) {
      List<Exercises> exercisesInTraining = [];
      for (int j = 0; j < exerciseDetails[i].length; j++) {
        exercisesInTraining.add(
          Exercises(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            series: exerciseDetails[i][j][2],
            reps: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
          ),
        );
      }
      //create individual training
      Training training =
          Training(name: trainingNames[i], exercises: exercisesInTraining);

      mySavedTrainings.add(training);
    }

    return mySavedTrainings;
  }

  bool exerciseCompleted(List<Training> trainings) {
    for (var trainings in trainings) {
      for (var exercise in trainings.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  int getCompletionStatus(String ddmmyyyy) {
    int completionStatus = _myBox.get("COMPLETION_STATUS$ddmmyyyy") ?? 0;
    return completionStatus;
  }
}
//check if data is already stored

//converting objects into a list
List<String> convertObjectsToTrainingList(List<Training> trainings) {
  List<String> trainingList = [
    //sadasd
  ];

  for (int i = 0; i < trainings.length; i++) {
    trainingList.add(
      trainings[i].name,
    );
  }
  return trainingList;
}

List<List<List<String>>> convertObjectsToExercisesList(
    List<Training> trainings) {
  List<List<List<String>>> exercisesList = [];

  for (int i = 0; i < trainings.length; i++) {
    List<Exercises> exercisesInTraining = trainings[i].exercises;

    /*List<List<String> individualTraining = [

      ];*/

    for (int j = 0; j < exercisesInTraining.length; j++) {
      List<String> individualExercise = [];
      individualExercise.addAll(
        [
          exercisesInTraining[j].name,
          exercisesInTraining[j].weight,
          exercisesInTraining[j].series,
          exercisesInTraining[j].reps,
          exercisesInTraining[j].isCompleted.toString(),
        ],
      );
      var individualTraining;
      individualTraining.add(individualExercise);
    }
    //exercisesList.add(individualTraining);
  }
  return exercisesList;
}
