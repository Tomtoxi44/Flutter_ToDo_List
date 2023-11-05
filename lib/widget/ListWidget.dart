import 'package:flutter/material.dart';
import 'package:todo_app_sqlite_freezed/databaseHelper.dart';
import 'package:todo_app_sqlite_freezed/models/todo_model.dart';
import '../pages/add_task.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key, required this.title});

  final String title;

  @override
  State<ListWidget> createState() => _ListWidget();
}

class _ListWidget extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                width: 250.0,
                height: 300.0,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: FutureBuilder<List<Todo>>(
                    future: DatabaseHelper.instance.getAllTodos(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Erreur : ${snapshot.error}');
                      }

                      final todos = snapshot.data!;
                      return ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (BuildContext context, int index) {
                          final todo = todos[index];
                          bool checkBoxValue = todo.isCompleted == 1;

                          return Row(
                            children: [
                              
                              Text(
                                style : const TextStyle(color : Colors.white),
                                todo.task,
                              ),
                              Checkbox(
                                checkColor: Colors.green,
                                fillColor: MaterialStateProperty.all( Colors.white),
                                value: checkBoxValue,
                                onChanged: (bool? value) async {
                                  var newTodo = todo.copyWith(
                                    isCompleted: value == true ? 1 : 0,
                                  );

                                  await DatabaseHelper.instance.update(newTodo);

                                  setState(() {
                                    checkBoxValue = value ?? false;
                                  });
                                },
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (todo.id != null) {
                                    await DatabaseHelper.instance
                                        .delete(todo.id!);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text('Tâche Supprimé !'),
                                      ),
                                    );

                                    setState(() {});
                                  }
                                },
                                icon: const Icon(Icons.delete, color : Colors.white),
                                
                              )
                            ],
                          );
                        },
                      );
                    })),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final String? result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const AddElement(message: 'Salut de la page principal')),
            );
            if (result != null) {
              await DatabaseHelper.instance
                  .insert(Todo(task: result, isCompleted: 0));
              setState(() {});
              const snackBar = SnackBar(
                backgroundColor: Colors.green,
                content: DefaultTextStyle(
                  style: TextStyle(color: Colors.white),
                  child: Text('Tâche ajouté !'),
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          label: const Text('add'),
          icon: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
