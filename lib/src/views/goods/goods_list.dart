import 'package:flutter/material.dart';
import '../../services/goods_list_service.dart';
import '../../services/keeper_list_service.dart'; // Asegúrate de importar el servicio de Keepers
import '../../services/location_list_service.dart'; // Asegúrate de importar el servicio de Locations
import '../../services/good_type_list_service.dart'; // Asegúrate de importar el servicio de GoodTypes
import '../../models/goods_list/goods.dart';
import '../../models/keeper_name.dart';  // Asegúrate de importar el modelo de Keeper
import '../../models/location_name.dart';  // Asegúrate de importar el modelo de Location
import '../../models/good_type.dart';  // Asegúrate de importar el modelo de GoodType

class GoodsList extends StatefulWidget {
  @override
  _GoodsListScreenState createState() => _GoodsListScreenState();
}

class _GoodsListScreenState extends State<GoodsList> {
  final GoodsListService goodsService = GoodsListService();
  
  // Nuevos servicios para Keepers, Locations y GoodTypes
  final KeeperService keeperService = KeeperService();
  final LocationService locationService = LocationService();
  final GoodTypeService goodTypeService = GoodTypeService();

  late Future<List<Goods>> futureGoods;
  
  // Controladores para los filtros
  late TextEditingController _descriptionController;

  // Variables para los filtros
  KeeperName? selectedKeeper;
  LocationName? selectedLocation;
  GoodType? selectedType;
  String descriptionFilter = "";

  // Listas para los dropdowns (Aquí deberían venir de tu API)
  List<KeeperName> keepers = [];
  List<LocationName> locations = [];
  List<GoodType> types = [];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    futureGoods = goodsService.fetchGoods(); // Cargar datos iniciales sin filtros

    // Llamadas para obtener los keepers, locations y types desde la API
    _loadDropdownData();
  }

  @override
  void dispose() {
    _descriptionController.dispose(); // Liberar el controlador
    super.dispose();
  }

  // Método para cargar los datos para los dropdowns
  void _loadDropdownData() async {
    // Aquí usamos los servicios correspondientes para cargar los datos
    keepers = await keeperService.fetchKeepers();
    locations = await locationService.fetchLocations();
    types = await goodTypeService.fetchGoodTypes();
    setState(() {}); // Actualizamos el estado para que se construyan los dropdowns
  }

  // Método para aplicar los filtros
  void applyFilters() {
    setState(() {
      futureGoods = goodsService.fetchGoods(
        keeperId: selectedKeeper?.id,
        locationId: selectedLocation?.id,
        typeId: selectedType?.id,
        description: descriptionFilter,
      );
    });
  }

  // Método para limpiar los filtros
  void clearFilters() {
    setState(() {
      selectedKeeper = null;
      selectedLocation = null;
      selectedType = null;
      descriptionFilter = "";
      _descriptionController.clear(); // Limpiar el campo de texto
    });
    futureGoods = goodsService.fetchGoods(); // Recargar datos sin filtros
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sección de filtros
            Expanded(
              flex: 2,
              child: ListView(
                children: [
                  _buildFilterDropdown<KeeperName>(
                    label: "Filtrar por Keeper",
                    value: selectedKeeper,
                    items: keepers, // Aquí utilizamos la lista de keepers cargada desde keeperService
                    onChanged: (KeeperName? newValue) {
                      setState(() {
                        selectedKeeper = newValue;
                      });
                    },
                    displayValue: (KeeperName item) => '${item.firstName} ${item.lastName}', // Muestra nombre y apellido
                  ),
                  _buildFilterDropdown<LocationName>(
                    label: "Filtrar por Ubicación",
                    value: selectedLocation,
                    items: locations, // Aquí utilizamos la lista de locations cargada desde locationService
                    onChanged: (LocationName? newValue) {
                      setState(() {
                        selectedLocation = newValue;
                      });
                    },
                    displayValue: (LocationName item) => item.name, // Muestra el nombre de la ubicación
                  ),
                  _buildFilterDropdown<GoodType>(
                    label: "Filtrar por Tipo",
                    value: selectedType,
                    items: types, // Aquí utilizamos la lista de tipos cargada desde goodTypeService
                    onChanged: (GoodType? newValue) {
                      setState(() {
                        selectedType = newValue;
                      });
                    },
                    displayValue: (GoodType item) => item.name, // Muestra el nombre del tipo
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Filtrar por Descripción',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          descriptionFilter = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Botones de aplicar y limpiar filtros
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: applyFilters,
                    child: Text("Aplicar Filtros"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: clearFilters,
                    child: Text("Limpiar Filtros"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                    ),
                  ),
                ],
              ),
            ),

            // Lista de bienes
            Expanded(
              flex: 3,
              child: FutureBuilder<List<Goods>>(
                future: futureGoods,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No hay bienes disponibles"));
                  }

                  List<Goods> goodsList = snapshot.data!;

                  return ListView.builder(
                    itemCount: goodsList.length,
                    itemBuilder: (context, index) {
                      final good = goodsList[index];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            good.description,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Código: ${good.keeper.firstName}"),
                              Text("Código: ${good.code}"),
                              Text("Ubicación: ${good.location.name}"),
                              Text("Tipo: ${good.type.name}"),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir un DropdownButton genérico
  Widget _buildFilterDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
    required String Function(T) displayValue, // Función para mostrar el valor en el Dropdown
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<T>(
            isExpanded: true,
            value: value,  // Usamos el valor directamente sin buscarlo
            hint: Text("Seleccionar"),
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(displayValue(item)), // Usamos la función para mostrar el valor
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
