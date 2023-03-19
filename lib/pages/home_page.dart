//import 'dart:js';
//import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_planner/components/heat_map.dart';
import 'package:workout_planner/data/training_data.dart';

import 'training_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<TrainingData>(context, listen: false).initializeTrainingList();
  }

  //controller
  final newTrainingController = TextEditingController();

  void createNewTraining() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create new training"),
        content: TextField(
          controller: newTrainingController,
        ),
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

  //go to training page
  void goToTrainingPage(String trainingName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrainingPage(
            trainingName: trainingName,
          ),
        ));
  }

  //save
  void save() {
    var newTrainingNameController;
    String newTrainingName = newTrainingNameController.text;

    Provider.of<TrainingData>(context, listen: false)
        .addTraining(newTrainingName);

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
    newTrainingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingData>(
        builder: (context, value, child) => Scaffold(
              backgroundColor: Colors.grey[600],
              appBar: AppBar(
                title: const Text('Training Tracker'),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: createNewTraining,
                child: const Icon(Icons.add),
              ),
              body: ListView(
                children: [
                  //heatmap
                  MyHeatMap(
                      datasets: value.HeatMapDataSet,
                      startDateDDMMYYYY: value.getStartDate()),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.getTrainingList().length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(value.getTrainingList()[index].name),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () => goToTrainingPage(
                            value.getTrainingList()[index].name),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
