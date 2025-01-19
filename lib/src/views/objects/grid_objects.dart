import 'package:flutter/material.dart';

import '../../models/todo.dart';

class GridObjects extends StatelessWidget {
  const GridObjects({super.key, required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Número de columnas en la cuadrícula
          crossAxisSpacing: 16, // Espaciado horizontal entre las tarjetas
          mainAxisSpacing: 16, // Espaciado vertical entre las tarjetas
          childAspectRatio: 0.8, // Relación de aspecto de cada tarjeta
        ),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];

          return GestureDetector(
            onTap: () {
              // Mostrar el Bottom Sheet al hacer clic
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          todo.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Placeholder para la imagen (icono)
                    const Icon(
                      Icons.inventory_2, // Ícono para simular una imagen
                      size: 48,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 16),
                    // Título del objeto
                    Text(
                      todo.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
