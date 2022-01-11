import 'package:alif_todo/Bloc/bloc.dart';
import 'package:alif_todo/Data/model/task.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class FormPage extends StatefulWidget {
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TaskBloc taskBloc = TaskBloc();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final _nameController = TextEditingController();

  final format = DateFormat("yyyy-MM-dd");

  final _dateController = TextEditingController();

  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Добавить задание'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(19.0),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                          labelText: 'Название', fillColor: Colors.green),
                      keyboardType: TextInputType.name,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'введите имя!';
                        }
                        return value.contains('')
                            ? 'не использовать символов'
                            : null;
                      },
                    ),
                    DateTimeField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Срок',
                      ),
                      format: format,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio(
                            activeColor: Colors.green,
                            value: false,
                            groupValue: isDone,
                            onChanged: (bool? value) {
                              setState(() {
                                isDone = value!;
                              });
                            },
                          ),
                          const Text('В процессе'),
                          const SizedBox(
                            width: 20,
                          ),
                          Radio(
                            activeColor: Colors.green,
                            value: true,
                            groupValue: isDone,
                            onChanged: (bool? value) {
                              setState(() {
                                isDone = value!;
                              });
                            },
                          ),
                          const Text('Выполнено'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            primary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          final newTask = Task(
                              name: _nameController.value.text,
                              deadline: _dateController.value.text,
                              isDone: isDone);

                          if (newTask.name.isNotEmpty &&
                              newTask.deadline.isNotEmpty) {
                            taskBloc.addTask(newTask);
                            Navigator.pushNamed(context, '/');
                          }
                        },
                        child: const Text("Создать"),
                      ),
                    ),
                  ],
                ),
              ),
              // this is where
              // the form field
              // are defined
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
