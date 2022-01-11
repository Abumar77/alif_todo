import 'package:alif_todo/Bloc/bloc.dart';
import 'package:alif_todo/Data/model/task.dart';
import 'package:flutter/material.dart';

import 'form_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DismissDirection _dismissDirection = DismissDirection.horizontal;
  TaskBloc taskBloc = TaskBloc();

  // final List<Widget> _pages = <Widget>[
  //   Container(
  //     child: getAllTasksWidget(),
  //   ),
  //   Icon(
  //     Icons.camera,
  //     size: 150,
  //   ),
  //   Icon(
  //     Icons.chat,
  //     size: 150,
  //   ),
  // ];

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
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
        selectedIconTheme: IconThemeData(color: Colors.green, size: 40),
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
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
    );
  }

  Widget getAllTasksWidget() {
    return StreamBuilder(
        stream: taskBloc.tasks,
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          if (_selectedIndex == 0) {
            return getTaskCardWidget(snapshot);
          } else if (_selectedIndex == 1) {
            return getCompletedTasksCardWidget(snapshot);
          } else if (_selectedIndex == 2) {
            return getProcessingTasksCardWidget(snapshot);
          } else {
            return getTaskCardWidget(snapshot);
          }
        });
  }

  Widget getTaskCardWidget(AsyncSnapshot<List<Task>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data!.length != 0
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
                          "Удалить",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    color: Colors.redAccent,
                  ),
                  onDismissed: (direction) {
                    /*The magic
                    delete Todo item by ID whenever
                    the card is dismissed
              //       */
                    // taskBloc.deleteTodoById(task.id);
                  },
                  direction: _dismissDirection,
                  key: ObjectKey(task),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        leading: InkWell(
                          onTap: () {
                            // //Reverse the value
                            // task.isDone = !task.isDone;
                            //
                            // taskBloc.updateTodo(task);
                          },
                          child: Container(
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
                          ),
                        ),
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
                          'Дедлайн до${task.deadline}',
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

  Widget getProcessingTasksCardWidget(AsyncSnapshot<List<Task>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data!.length != 0
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
                          "Удалить",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    color: Colors.redAccent,
                  ),
                  onDismissed: (direction) {
                    /*The magic
                    delete Todo item by ID whenever
                    the card is dismissed
              //       */
                    // taskBloc.deleteTodoById(task.id);
                  },
                  direction: _dismissDirection,
                  key: ObjectKey(task),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        leading: InkWell(
                          onTap: () {
                            // //Reverse the value
                            // task.isDone = !task.isDone;
                            //
                            // taskBloc.updateTodo(task);
                          },
                          child: Container(
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
                          ),
                        ),
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
                          'Дедлайн до${task.deadline}',
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

                if (task.isDone == false) {
                  return dismissibleCard;
                } else {
                  return SizedBox();
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

  Widget getCompletedTasksCardWidget(AsyncSnapshot<List<Task>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data!.length != 0
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
                          "Удалить",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    color: Colors.redAccent,
                  ),
                  onDismissed: (direction) {
                    /*The magic
                    delete Todo item by ID whenever
                    the card is dismissed
              //       */
                    // taskBloc.deleteTodoById(task.id);
                  },
                  direction: _dismissDirection,
                  key: ObjectKey(task),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        leading: InkWell(
                          onTap: () {
                            // //Reverse the value
                            // task.isDone = !task.isDone;
                            //
                            // taskBloc.updateTodo(task);
                          },
                          child: Container(
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
                          ),
                        ),
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
                          'Дедлайн до${task.deadline}',
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

                if (task.isDone == true) {
                  return dismissibleCard;
                } else {
                  return SizedBox();
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
    //pull todos again
    taskBloc.getTasks();
    return Container(
      child: Center(
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
      ),
    );
  }

  Widget noTaskMessageWidget() {
    return Container(
      child: const Text(
        "Нет заданий пока",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }
}
