import 'package:flutter/material.dart';
import '../../services/goods_list_service.dart';
import '../../models/goods_list/goods.dart';

class GoodsList extends StatefulWidget {
  @override
  _GoodsListScreenState createState() => _GoodsListScreenState();
}

class _GoodsListScreenState extends State<GoodsList> {
  final GoodsListService goodsService = GoodsListService();
  late Future<List<Goods>> futureGoods;

  // Controladores para los filtros
  late TextEditingController _descriptionController;

  // Variables para los filtros
  int? selectedKeeper;
  int? selectedLocation;
  int? selectedType;
  String descriptionFilter = "";

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    futureGoods = goodsService.fetchGoods(); // Cargar datos iniciales sin filtros
  }

  @override
  void dispose() {
    _descriptionController.dispose(); // Liberar el controlador
    super.dispose();
  }

  // Método para aplicar los filtros
  void applyFilters() {
    setState(() {
      futureGoods = goodsService.fetchGoods(
        keeperId: selectedKeeper,
        locationId: selectedLocation,
        typeId: selectedType,
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
                  _buildFilterDropdown(
                    label: "Filtrar por Keeper",
                    value: selectedKeeper,
                    items: [1, 2], // Aquí puedes cargar dinámicamente los valores de los keepers
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedKeeper = newValue;
                      });
                    },
                  ),
                  _buildFilterDropdown(
                    label: "Filtrar por Ubicación",
                    value: selectedLocation,
                    items: [1, 2], // Aquí puedes cargar dinámicamente las ubicaciones
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedLocation = newValue;
                      });
                    },
                  ),
                  _buildFilterDropdown(
                    label: "Filtrar por Tipo",
                    value: selectedType,
                    items: [1, 3, 4], // Aquí puedes cargar dinámicamente los valores de tipo
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedType = newValue;
                      });
                    },
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
  Widget _buildFilterDropdown({
    required String label,
    required int? value,
    required List<int> items,
    required Function(int?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<int>(
            isExpanded: true,
            value: value,
            hint: Text("Seleccionar"),
            items: items.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value'), // Aquí puedes mostrar el nombre en lugar del ID
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}