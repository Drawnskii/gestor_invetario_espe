import 'package:flutter/material.dart';

import '../models/todo.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'objects/object_detail.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key, required this.todos});

  final List<Todo> todos;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final MobileScannerController cameraController = MobileScannerController();

  String scannedData = ''; // Para mostrar los datos escaneados
  bool hasScanned = false; // Para evitar múltiples escaneos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (BarcodeCapture barcodeCapture) {
                // Verifica si ya se ha escaneado un código
                if (hasScanned) return;

                final String code = barcodeCapture.barcodes.isNotEmpty
                    ? barcodeCapture.barcodes[0].rawValue ?? 'Desconocido'
                    : 'Desconocido';

                Todo bar_code = Todo('Código de barras', code);

                setState(() {
                  scannedData = code;
                  hasScanned = true; // Marca que ya se escaneó
                });

                // Detener la cámara
                cameraController.stop();

                // Navegar a la vista con el detalle del objeto
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ObjectDetail(todo: bar_code)),
                ).then((_) {
                  // Cuando se regrese a esta pantalla, reinicia la cámara
                  setState(() {
                    hasScanned = false;
                  });
                  cameraController.start();
                });
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose(); // Liberar recursos al cerrar la pantalla
    super.dispose();
  }
}
