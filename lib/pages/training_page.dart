import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_planner/components/exercise_tile.dart';
import 'package:workout_planner/data/training_data.dart';

class TrainingPage extends StatefulWidget {
  final String trainingName;
  const TrainingPage({super.key, required this.trainingName});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  get createNewExercise => null;

  void onCheckBoxChanged(String trainingName, String exerciseName) {
    Provider.of<TrainingData>(context, listen: false)
        .checkOffExercises(trainingName, exerciseName);
  }

  //text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final seriesController = TextEditingController();

  void createNewEcercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a new exercise'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          //name
          TextField(
            controller: exerciseNameController,
          ),

          //weight
          TextField(
            controller: weightController,
          ),

          //reps
          TextField(
            controller: repsController,
          ),

          //series
          TextField(
            controller: seriesController,
          ),
        ]),
        actions: [
          //save
          MaterialButton(
            onPressed: save,
            child: const Text("save"),
          ),

          //cancel
          MaterialButton(
            onPressed: cancel,
            child: const Text("cancel"),
          ),
        ],
      ),
    );
  }

  //save
  void save() {
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String series = seriesController.text;
    String reps = repsController.text;
    Provider.of<TrainingData>(context, listen: false).addExercises(
        widget.trainingName, newExerciseName, weight, series, reps);

    //pop dialog
    Navigator.pop(context);
    clear();
  }

  //cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  //clear controller
  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    seriesController.clear();
    repsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.trainingName)),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          //itemCount:
          itemBuilder: (context, index) => ExerciseTile(
            exerciseName: value
                .getRelevantTraining(widget.trainingName)
                .exercises[index]
                .name,
            weight: value
                .getRelevantTraining(widget.trainingName)
                .exercises[index]
                .weight,
            reps: value
                .getRelevantTraining(widget.trainingName)
                .exercises[index]
                .reps,
            series: value
                .getRelevantTraining(widget.trainingName)
                .exercises[index]
                .series,
            isCompleted: value
                .getRelevantTraining(widget.trainingName)
                .exercises[index]
                .isCompleted,
            onCheckBoxChanged: (val) => onCheckBoxChanged(
              widget.trainingName,
              value
                  .getRelevantTraining(widget.trainingName)
                  .exercises[index]
                  .name,
            ),
          ),
        ),
      ),
    );
  }
}
