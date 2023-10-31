import 'package:flutter/material.dart';

class AddElement extends StatefulWidget {
  final String message;
  const AddElement({Key? key, required this.message}) : super(key: key);

  @override
  _AddElementState createState() => _AddElementState();
}

class _AddElementState extends State<AddElement> {
  final TextEditingController  _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateState);
  }

  _updateState() {
    setState(() {}); 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Page de Détails'),
        ),
        body: Column(
          children: [
            Center(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              width: 250,
              margin: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2)),
                  labelText: "Nouvelle tâche",
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                ),
              ),
            )),
            ElevatedButton(
              onPressed: _controller.text.isEmpty
                  ? null
                  : () {
                      Navigator.pop(context, _controller.text);
                    },
              child: const Text('Ajouter une tâche'),
            )
          ],
        ));
  }
}
