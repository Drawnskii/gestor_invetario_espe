import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart'; // Para generar el código de barras

class ObjectRegistry extends StatefulWidget {
  const ObjectRegistry({Key? key}) : super(key: key);

  @override
  _ObjectRegistryState createState() => _ObjectRegistryState();
}

class _ObjectRegistryState extends State<ObjectRegistry> {
  String inputText = ''; // Dirección para asignar al código QR o de barras
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Ingresa una dirección',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  inputText = value;
                });
              },
            ),
            const SizedBox(height: 20),
            if (inputText.isNotEmpty)
              Column(
                children: [
                  // Contenedor para el código de barras
                  Container(
                    padding: const EdgeInsets.all(19.0), // Margen interno
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(254, 247, 255, 1.0), // Fondo con el color especificado
                      borderRadius: BorderRadius.circular(16.0), // Bordes redondeados con un radio de 16.0
                    ),
                    child: BarcodeWidget(
                      data: inputText,
                      barcode: Barcode.code128(), // Tipo de código de barras
                      width: 200,
                      height: 80,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Código Generado')),
                );
              },
              child: const Text('Generar Código'),
            ),
          ],
        ),
      ),
    );
  }
}
