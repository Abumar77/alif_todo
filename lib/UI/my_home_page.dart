import 'package:alif_todo/Bloc/bloc.dart';
import 'package:alif_todo/Data/model/task.dart';
import 'package:flutter/material.dart';

import 'components.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DismissDirection _dismissDirection = DismissDirection.horizontal;
  TaskBloc taskBloc = TaskBloc();
  bool isDoneTask = false;
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        if (index == 1) {
          isDoneTask = true;
        } else if (index == 2) {
          isDoneTask = false;
        }
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Alif todo'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              icon: const Icon(
                Icons.add,
                size: 30,
              ))
        ],
      ),
      body: SafeArea(
        child: Container(child: getAllTasksWidget()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 20,
        selectedIconTheme: const IconThemeData(color: Colors.green, size: 40),
        selectedItemColor: Colors.green,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        iconSize: 30,
        backgroundColor: Colors.white10,
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Все',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Выполнено',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Процессе',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget getAllTasksWidget() {
    return StreamBuilder(
        stream: taskBloc.tasks,
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          if (_selectedIndex == 1 || _selectedIndex == 2) {
            return getProcessingTasksCardWidget(snapshot);
          } else {
            return getTaskCardWidget(snapshot);
          }
        });
  }

  Widget _ticker(Task task) {
    return InkWell(
      onTap: () {
        task.isDone = !task.isDone;

        taskBloc.updateTask(task);
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: task.isDone
            ? const Icon(
                Icons.done,
                size: 26.0,
                color: Colors.green,
              )
            : const Icon(
                Icons.check_box_outline_blank,
                size: 26.0,
                color: Colors.black,
              ),
      ),
    );
  }

  Widget getTaskCardWidget(AsyncSnapshot<List<Task>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data!.isNotEmpty
          ? ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, itemPosition) {
                Task task = snapshot.data![itemPosition];
                final Widget dismissibleCard = Dismissible(
                  background: Container(
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Изменить",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    color: Colors.green,
                  ),
                  secondaryBackground: Container(
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Удалить",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    color: Colors.redAccent,
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      _showModalBottomshetForEditing(context, task);
                      taskBloc.updateTask(task);
                    } else {
                      taskBloc.deleteTaskById(task.id);
                    }
                  },
                  direction: _dismissDirection,
                  key: ObjectKey(task),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        leading: _ticker(task),
                        title: Text(
                          task.name,
                          style: TextStyle(
                              fontSize: 16.5,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w500,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                        trailing: Text(
                          'Дедлайн до ${task.deadline}',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.5,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w500,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                      )),
                );
                return dismissibleCard;
              })
          : Center(
              child: noTaskMessageWidget(),
            );
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  void _showModalBottomshetForEditing(BuildContext context, Task task) {
    final _taskEditController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.transparent,
              child: Container(
                height: 230,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _taskEditController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: InputDecoration(
                                  hintText: task.name,
                                  labelText: 'Изменить задание',
                                  labelStyle: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500)),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Empty description!';
                                }
                                return value.contains('')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.indigoAccent,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.save,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final updatedTask = Task(
                                      name: _taskEditController.value.text,
                                      deadline: task.deadline,
                                      isDone: task.isDone);
                                  taskBloc.updateTask(updatedTask, id: task.id);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget getProcessingTasksCardWidget(AsyncSnapshot<List<Task>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data!.isNotEmpty
          ? ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, itemPosition) {
                Task task = snapshot.data![itemPosition];
                final Widget dismissibleCard = Dismissible(
                  confirmDismiss: (DismissDirection direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Confirmation"),
                          content: const Text(
                              "Are you sure you want to delete this item?"),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("Delete")),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  background: Container(
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Удалить",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    color: Colors.redAccent,
                  ),
                  onDismissed: (direction) {
                    taskBloc.deleteTaskById(task.id);
                  },
                  direction: _dismissDirection,
                  key: ObjectKey(task),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        leading: _ticker(task),
                        title: Text(
                          task.name,
                          style: TextStyle(
                              fontSize: 16.5,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w500,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                        trailing: Text(
                          'Дедлайн до ${task.deadline}',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.5,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w500,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                      )),
                );

                if (task.isDone == isDoneTask) {
                  return dismissibleCard;
                } else {
                  return const SizedBox();
                }
              })
          : Center(
              child: noTaskMessageWidget(),
            );
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    taskBloc.getTasks();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
          Text(
            "Загружается...",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
