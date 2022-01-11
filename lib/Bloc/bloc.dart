import 'dart:async';

import 'package:alif_todo/Data/model/task.dart';
import 'package:alif_todo/Data/repository/task_repo.dart';

class TaskBloc {
  final _taskRepository = TaskRepo();

  //Streamcontroller  data potokini boshqarish uchun va subscriberlarga
  // info bilan tamilluvchi

  final _taskController = StreamController<List<Task>>.broadcast();

  get tasks => _taskController.stream;

  TaskBloc() {
    getTasks();
  }

  //sink is a way of adding data reactively to the stream
  // by registering a new event
  getTasks({String? query}) async {
    _taskController.sink.add(await _taskRepository.getAllTasks(query: query));
  }

  addTask(Task task) async {
    await _taskRepository.insertTasks(task);
    getTasks();
  }

  updateTask(Task task, {int? id}) async {
    if (id == null) {
      await _taskRepository.updateTask(task);
    } else {
      await _taskRepository.updateTask(task, id: id);
    }
    getTasks();
  }

  deleteTaskById(int? id) async {
    await _taskRepository.deleteTaskById(id!);
    getTasks();
  }

  dispose() {
    _taskController.close();
  }
}
