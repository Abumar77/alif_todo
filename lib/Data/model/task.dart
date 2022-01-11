class Task {
  final int? id;
  String name;
  String deadline;
  bool isDone;

  Task({
    this.id,
    required this.name,
    required this.deadline,
    required this.isDone,
  });

  factory Task.fromDatabaseJson(Map<String, dynamic> data) => Task(
        id: data['id'],
        name: data['name'],
        deadline: data['deadline'],
        isDone: data['is_done'] == 0 ? false : true,
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": id,
        "name": name,
        "deadline": deadline,
        "is_done": isDone == false ? 0 : 1,
      };
}
