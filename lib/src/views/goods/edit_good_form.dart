import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inventario/src/utils/secure_storage.dart';

import '../../models/goods_list/goods.dart';
import '../../services/location_list_service.dart';
import '../../services/good_type_list_service.dart';
import '../../services/keeper_list_service.dart'; // Nuevo servicio para obtener keepers
import '../../models/location_name.dart';
import '../../models/good_type.dart';
import '../../models/keeper_name.dart'; // Modelo de Keeper

class EditGoodForm extends StatefulWidget {
  final Goods good;
  final String? scannedCode;

  const EditGoodForm({super.key, required this.good, this.scannedCode});

  @override
  _EditGoodFormState createState() => _EditGoodFormState();
}

class _EditGoodFormState extends State<EditGoodForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final storage = FlutterSecureStorage();
  final String apiUrl = 'http://192.168.100.11:8000/api/goods/';

  final LocationService locationService = LocationService();
  final GoodTypeService goodTypeService = GoodTypeService();
  final KeeperService keeperService = KeeperService(); // Nuevo servicio para keepers

  List<LocationName> locations = [];
  List<GoodType> types = [];
  List<KeeperName> keepers = []; // Lista de keepers

  LocationName? selectedLocation;
  GoodType? selectedType;
  KeeperName? selectedKeeper; // Keeper seleccionado

  @override
  void initState() {
    super.initState();
    if (widget.scannedCode != null) {
      codeController.text = widget.scannedCode!;
    } else {
      codeController.text = widget.good.code;
    }
    descriptionController.text = widget.good.description;
    _loadDropdownData();
  }

  void _loadDropdownData() async {
    locations = await locationService.fetchLocations();
    types = await goodTypeService.fetchGoodTypes();
    keepers = await keeperService.fetchKeepers();

    setState(() {
      selectedLocation = locations.firstWhere((location) => location.id == widget.good.location.id);
      selectedType = types.firstWhere((type) => type.id == widget.good.type.id);
      selectedKeeper = keepers.firstWhere((keeper) => keeper.id == widget.good.keeper.id);
    });
  }

  Future<void> updateGood() async {
    String? accessToken = await SecureStorage.getToken();
    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: No se encontró el token de acceso')));
      return;
    }

    final Map<String, dynamic> body = {
      'description': descriptionController.text,
      'keeper': selectedKeeper?.id, // Usar el keeper seleccionado
      'location': selectedLocation?.id,
      'type': selectedType?.id,
    };

    try {
      final response = await http.put(
        Uri.parse('$apiUrl${widget.good.code}/edit/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Bien actualizado con éxito')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al actualizar el bien')));
      }
    } catch (e) {
      print("Error en la solicitud: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al actualizar el bien')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Bien'),
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
                enabled: false, // El código no se puede editar
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
              const SizedBox(height: 16),

              // Dropdown de Keeper
              _buildDropdown<KeeperName>(
                value: selectedKeeper,
                labelText: 'Encargado',
                icon: Icons.person,
                items: keepers,
                displayText: (keeper) => '${keeper.firstName} ${keeper.lastName}',
                onChanged: (newValue) {
                  setState(() {
                    selectedKeeper = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione un encargado' : null,
              ),
              const SizedBox(height: 24),

              // Botón de Actualizar Bien
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    updateGood();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Actualizar Bien',
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
    bool enabled = true,
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
      enabled: enabled,
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