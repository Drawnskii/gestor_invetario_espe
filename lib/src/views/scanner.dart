import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart'; // Importa provider

import '../models/good.dart';
import '../models/goods_list.dart';

import 'goods/good_detail.dart';
import 'goods/good_form.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

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

                setState(() {
                  scannedData = code;
                  hasScanned = true; // Marca que ya se escaneó
                });

                final goodsList = Provider.of<GoodsList>(context, listen: false); // Acceso al GoodsList usando Provider

                Good result = Good().query(goodsList.goods, scannedData);

                // Detener la cámara
                cameraController.stop();

                // Navegar a la vista con el detalle del objeto
                if (result.code != null && result.name != null && result.keeper != null && result.brand != null) {
                  // Si el Good ya existe, navegar a la vista de detalle
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoodDetail(good: result)),
                  ).then((_) {
                    // Reiniciar el escaneo y la cámara
                    setState(() {
                      hasScanned = false;
                    });
                    cameraController.start();
                  });
                } else {
                  // Si el Good no existe, navega al formulario para crear uno nuevo
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoodForm(code: scannedData)),
                  ).then((newGood) {
                    if (newGood != null) {
                      // Añadir el nuevo bien a la lista global mediante el provider
                      goodsList.add(newGood);
                    }
                    // Reiniciar el escaneo y la cámara
                    setState(() {
                      hasScanned = false;
                    });
                    cameraController.start();
                  });
                }
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
