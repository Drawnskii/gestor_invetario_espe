import 'package:flutter/material.dart';

import '../models/todo.dart';

import 'objects/object_detail.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key, required this.todos});

  final List<Todo> todos;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Campo de texto para ingresar el ID del objeto
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Ingrese ID del objeto',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number, // Suponemos que el ID es numérico
              onSubmitted: (String value) async {
                int index = int.parse(value);

                if (index < widget.todos.length) {
                  // Navegar a la vista con el detalle del objeto
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ObjectDetail(todo: widget.todos[index])),
                  );
                }
                else {
                  await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Advertencia!'),
                        content: Text(
                            'No se ha encontrado el Todo $value.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}