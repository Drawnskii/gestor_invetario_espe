import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import '../models/goods_list/goods.dart';
import '../providers/auth_provider.dart';
import 'goods/good_detail.dart';
import 'goods/good_form.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final MobileScannerController cameraController = MobileScannerController();

  String scannedData = '';
  bool hasScanned = false;

  // Función para obtener el bien desde la API
  Future<Goods?> fetchGoodFromAPI(String code) async {
    final response = await http.get(Uri.parse('http://192.168.100.11:8000/api/goods-by-code/$code/'));

    if (response.statusCode == 200) {
      return Goods.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al obtener el bien desde la API');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Acceder a autenticación

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (BarcodeCapture barcodeCapture) {
                if (hasScanned) return;

                final String code = barcodeCapture.barcodes.isNotEmpty
                    ? barcodeCapture.barcodes[0].rawValue ?? 'Desconocido'
                    : 'Desconocido';

                setState(() {
                  scannedData = code;
                  hasScanned = true;
                });

                cameraController.stop();

                fetchGoodFromAPI(scannedData).then((result) {
                  if (result != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GoodDetail(good: result)),
                    ).then((_) {
                      setState(() => hasScanned = false);
                      cameraController.start();
                    });
                  } else {
                    if (authProvider.isAuthenticated) {
                      // Usuario autenticado, ir a GoodForm
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GoodForm(scannedCode: scannedData)),
                      ).then((_) {
                        setState(() => hasScanned = false);
                        cameraController.start();
                      });
                    } else {
                      // Usuario no autenticado, mostrar alerta
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Iniciar Sesión"),
                          content: Text("Debe iniciar sesión para registrar un nuevo bien."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cerrar"),
                            ),
                          ],
                        ),
                      ).then((_) {
                        setState(() => hasScanned = false);
                        cameraController.start();
                      });
                    }
                  }
                }).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al obtener el bien: $e')),
                  );
                  setState(() => hasScanned = false);
                  cameraController.start();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
