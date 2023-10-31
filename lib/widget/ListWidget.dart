import 'package:flutter/material.dart';
import 'package:todo_app_sqlite_freezed/databaseHelper.dart';
import 'package:todo_app_sqlite_freezed/models/todo_model.dart';
import '../pages/add_task.dart';

class ListWidget extends StatefulWidget {
  ListWidget({super.key, required this.title});

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
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder<List<Todo>>(
                  future: DatabaseHelper.instance.getAllTodos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Erreur : ${snapshot.error}');
                    }

                    final todos = snapshot.data!;
                    return ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (BuildContext context, int index) {
                        final todo = todos[index];
                        return Row(children: [
                          Text(
                            todo.task,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ]);
                      },
                    );
                  })),
          ElevatedButton(
            child: const Text('Rajouter une tâche'),
            onPressed: () async {
              final String? result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddElement(
                        message: 'Salut de la page principal')),
              );
              if (result != null) {
                await DatabaseHelper.instance.insert(Todo(task: result, isCompleted: 0));
                setState(() {});
                const snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: DefaultTextStyle(
                    style: TextStyle(color: Colors.white), // Votre style ici
                    child: Text('Tâche ajouté !'),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          )
        ],
      ),
    );
  }
}
