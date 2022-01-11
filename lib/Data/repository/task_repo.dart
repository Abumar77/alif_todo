import 'package:alif_todo/Data/db/dao.dart';
import 'package:alif_todo/Data/model/task.dart';

class TaskRepo {
  final taskDao = TaskDbAccessProvider();

  Future getAllTasks({String? query}) => taskDao.getTasks(query: query);
  Future insertTasks(Task task) => taskDao.createTask(task);
  Future updateTask(Task task) => taskDao.updateTask(task);
  Future deleteTaskById(int id) => taskDao.deleteTask(id);

}
