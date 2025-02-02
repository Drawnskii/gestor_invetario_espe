import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inventario/src/utils/secure_storage.dart';
import '../../services/location_list_service.dart';
import '../../services/good_type_list_service.dart';
import '../../models/location_name.dart';
import '../../models/good_type.dart';

class GoodForm extends StatefulWidget {
  final String? scannedCode;

  GoodForm({this.scannedCode});

  @override
  _GoodFormState createState() => _GoodFormState();
}

class _GoodFormState extends State<GoodForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final storage = FlutterSecureStorage();
  final String apiUrl = 'http://192.168.100.11:8000/api/goods/';

  final LocationService locationService = LocationService();
  final GoodTypeService goodTypeService = GoodTypeService();

  List<LocationName> locations = [];
  List<GoodType> types = [];

  LocationName? selectedLocation;
  GoodType? selectedType;

  @override
  void initState() {
    super.initState();
    if (widget.scannedCode != null) {
      codeController.text = widget.scannedCode!;
    }
    _loadDropdownData();
  }

  void _loadDropdownData() async {
    locations = await locationService.fetchLocations();
    types = await goodTypeService.fetchGoodTypes();
    setState(() {});
  }

  Future<void> createGood() async {
    String? accessToken = await SecureStorage.getToken();
    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: No se encontró el token de acceso')));
      return;
    }

    final Map<String, dynamic> body = {
      'code': codeController.text,
      'description': descriptionController.text,
      'location': selectedLocation?.id,
      'type': selectedType?.id,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Bien creado con éxito')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al crear el bien')));
      }
    } catch (e) {
      print("Error en la solicitud: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al crear el bien')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulario de Bien')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: codeController,
                decoration: InputDecoration(labelText: 'Código'),
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese el código' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese la descripción' : null,
              ),
              DropdownButtonFormField<LocationName>(
                value: selectedLocation,
                decoration: InputDecoration(labelText: 'Ubicación'),
                items: locations.map((LocationName location) {
                  return DropdownMenuItem<LocationName>(
                    value: location,
                    child: Text(location.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedLocation = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione una ubicación' : null,
              ),
              DropdownButtonFormField<GoodType>(
                value: selectedType,
                decoration: InputDecoration(labelText: 'Tipo'),
                items: types.map((GoodType type) {
                  return DropdownMenuItem<GoodType>(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione un tipo' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    createGood();
                  }
                },
                child: Text('Crear Bien'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
