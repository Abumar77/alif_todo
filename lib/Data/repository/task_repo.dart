import 'package:alif_todo/Data/db/dao.dart';
import 'package:alif_todo/Data/model/task.dart';

class TaskRepo {
  final taskDao = TaskDbAccessProvider();

  Future getAllTasks({String? query}) => taskDao.getTasks(query: query);
  Future insertTasks(Task task) => taskDao.createTask(task);
  Future updateTask(Task task, {int? id}) {
    if (id == null) {
      return taskDao.updateTask(task);
    } else {
      return taskDao.updateTask(task, id: id);
    }
  }

  Future deleteTaskById(int id) => taskDao.deleteTask(id);
}
