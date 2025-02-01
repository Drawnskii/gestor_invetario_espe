import 'package:flutter/material.dart';
import '../../models/good.dart';  // Asegúrate de importar tu modelo Good

class GoodForm extends StatefulWidget {
  final String? code;

  const GoodForm({super.key, required this.code});

  @override
  _GoodFormState createState() => _GoodFormState();
}

class _GoodFormState extends State<GoodForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos del formulario
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _keeperController;
  late TextEditingController _brandController;

  @override
  void initState() {
    super.initState();

    // Si hay un "Good" pasado al formulario, inicializa los controladores con esos valores
    _codeController = TextEditingController(text: widget.code);
    _nameController = TextEditingController(text: '');
    _keeperController = TextEditingController(text: '');
    _brandController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    // Limpia los controladores al destruir el widget
    _codeController.dispose();
    _nameController.dispose();
    _keeperController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  // Función para guardar los datos y devolver el nuevo Good
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Crear el objeto Good con los datos del formulario
      final updatedGood = Good(
        code: _codeController.text,
        name: _nameController.text,
        keeper: int.tryParse(_keeperController.text),  // Convierte el texto a int
        brand: _brandController.text,
      );

      // Volver a la pantalla anterior con el objeto Good actualizado
      Navigator.pop(context, updatedGood);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.code == null ? 'Nuevo Bien' : 'Editar Bien'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo para el código
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Código'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El código es obligatorio';
                  }
                  return null;
                },
              ),
              // Campo para el nombre
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              // Campo para el guardián
              TextFormField(
                controller: _keeperController,
                decoration: InputDecoration(labelText: 'Guardián'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El guardián es obligatorio';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Debe ser un número válido';
                  }
                  return null;
                },
              ),
              // Campo para la marca
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(labelText: 'Marca'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La marca es obligatoria';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
