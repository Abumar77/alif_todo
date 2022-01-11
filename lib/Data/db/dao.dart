import 'package:alif_todo/Data/db/database.dart';
import 'package:alif_todo/Data/model/task.dart';

class TaskDbAccessProvider {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createTask(Task task) async {
    final db = await dbProvider.database;
    var result = db!.insert(
      taskTable,
      task.toDatabaseJson(),
    );
    return result;
  }

  Future<List<Task>> getTasks({List<String>? columns, String? query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>>? result = [];

    if (query != null) {
      if (query.isNotEmpty) {
        result = await db!.query(
          taskTable,
          columns: columns,
          where: 'name LIKE ?',
          whereArgs: ["%$query%"],
        );
      }
    } else {
      result = await db!.query(taskTable, columns: columns);
    }

    List<Task> tasks = result.isNotEmpty
        ? result.map((item) => Task.fromDatabaseJson(item)).toList()
        : [];
    return tasks;
  }
}