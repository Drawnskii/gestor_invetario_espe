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

  const GoodForm({super.key, this.scannedCode});

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
      appBar: AppBar(
        title: Text('Formulario de Bien'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo de Código
              _buildTextField(
                controller: codeController,
                labelText: 'Código',
                icon: Icons.code,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese el código' : null,
              ),
              const SizedBox(height: 16),

              // Campo de Descripción
              _buildTextField(
                controller: descriptionController,
                labelText: 'Descripción',
                icon: Icons.description,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor ingrese la descripción' : null,
              ),
              const SizedBox(height: 16),

              // Dropdown de Ubicación
              _buildDropdown<LocationName>(
                value: selectedLocation,
                labelText: 'Ubicación',
                icon: Icons.location_on,
                items: locations,
                displayText: (location) => location.name,
                onChanged: (newValue) {
                  setState(() {
                    selectedLocation = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione una ubicación' : null,
              ),
              const SizedBox(height: 16),

              // Dropdown de Tipo
              _buildDropdown<GoodType>(
                value: selectedType,
                labelText: 'Tipo',
                icon: Icons.category,
                items: types,
                displayText: (type) => type.name,
                onChanged: (newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione un tipo' : null,
              ),
              const SizedBox(height: 24),

              // Botón de Crear Bien
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    createGood();
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Crear Bien',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir un TextField con ícono
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }

  // Método para construir un DropdownButtonFormField con ícono
  Widget _buildDropdown<T>({
    required T? value,
    required String labelText,
    required IconData icon,
    required List<T> items,
    required String Function(T) displayText,
    required void Function(T?) onChanged,
    required String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(displayText(item)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}