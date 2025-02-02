import 'package:flutter/material.dart';
import '../../services/goods_list_service.dart';
import '../../services/keeper_list_service.dart';
import '../../services/location_list_service.dart';
import '../../services/good_type_list_service.dart';
import '../../models/goods_list/goods.dart';
import '../../models/keeper_name.dart';
import '../../models/location_name.dart';
import '../../models/good_type.dart';

class GoodsList extends StatefulWidget {
  const GoodsList({super.key});

  @override
  _GoodsListScreenState createState() => _GoodsListScreenState();
}

class _GoodsListScreenState extends State<GoodsList> {
  final GoodsListService goodsService = GoodsListService();
  final KeeperService keeperService = KeeperService();
  final LocationService locationService = LocationService();
  final GoodTypeService goodTypeService = GoodTypeService();

  late Future<List<Goods>> futureGoods;
  late TextEditingController _descriptionController;
  late TextEditingController _keeperNameController;

  KeeperName? selectedKeeper;
  LocationName? selectedLocation;
  GoodType? selectedType;
  String descriptionFilter = "";
  String keeperFullNameFilter = "";

  List<KeeperName> keepers = [];
  List<LocationName> locations = [];
  List<GoodType> types = [];
  List<GoodType> selectedTypes = [];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _keeperNameController = TextEditingController();
    futureGoods = goodsService.fetchGoods();
    _loadDropdownData();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _keeperNameController.dispose();
    super.dispose();
  }

  void _loadDropdownData() async {
    keepers = await keeperService.fetchKeepers();
    locations = await locationService.fetchLocations();
    types = await goodTypeService.fetchGoodTypes();
    setState(() {});
  }

  void applyFilters() {
    setState(() {
      futureGoods = goodsService.fetchGoods(
        keeperFullName: keeperFullNameFilter,
        keeperId: selectedKeeper?.id,
        locationId: selectedLocation?.id,
        typeId: selectedType?.id,
        description: descriptionFilter,
      );
    });
  }

  void clearFilters() {
    setState(() {
      selectedKeeper = null;
      selectedLocation = null;
      selectedType = null;
      descriptionFilter = "";
      keeperFullNameFilter = "";
      _descriptionController.clear();
      _keeperNameController.clear();
    });

    futureGoods = goodsService.fetchGoods();
    FocusScope.of(context).unfocus();
  }

  bool get isFilterActive {
    return selectedKeeper != null ||
        selectedLocation != null ||
        selectedType != null ||
        descriptionFilter.isNotEmpty ||
        keeperFullNameFilter.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primera fila - Chips de tipos de bienes
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: types.map((type) {
                        bool isSelected = selectedType == type;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: FilterChip(
                            label: Text(type.name),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedType = selected ? type : null;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Segunda fila - Filtro por Keeper y Ubicación
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _keeperNameController,
                        decoration: InputDecoration(
                          labelText: 'Encargado',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        onChanged: (value) {
                          setState(() {
                            keeperFullNameFilter = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFilterDropdown<LocationName>(
                        label: "Ubicación",
                        value: selectedLocation,
                        items: locations,
                        onChanged: (LocationName? newValue) {
                          setState(() => selectedLocation = newValue);
                        },
                        displayValue: (LocationName item) => item.name,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tercera fila - Filtro por descripción y botones de filtros
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descripción',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        onChanged: (value) {
                          setState(() => descriptionFilter = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.filter_alt_rounded, size: 32),
                      onPressed: isFilterActive ? applyFilters : null,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 32),
                      onPressed: isFilterActive ? clearFilters : null,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Goods>>(
              future: futureGoods,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No hay bienes disponibles",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final good = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Ícono principal
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.inventory_rounded,
                                size: 32,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Información del bien
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Descripción
                                  Text(
                                    good.description,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Keeper
                                  _buildInfoRow(
                                    icon: Icons.person_outline,
                                    text: "${good.keeper.firstName} ${good.keeper.lastName}",
                                  ),
                                  const SizedBox(height: 4),
                                  // Código
                                  _buildInfoRow(
                                    icon: Icons.code,
                                    text: good.code,
                                  ),
                                  const SizedBox(height: 4),
                                  // Ubicación
                                  _buildInfoRow(
                                    icon: Icons.location_on_outlined,
                                    text: good.location.name,
                                  ),
                                  const SizedBox(height: 4),
                                  // Tipo
                                  _buildInfoRow(
                                    icon: Icons.category_outlined,
                                    text: good.type.name,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
    required String Function(T) displayValue,
  }) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      value: value,
      itemHeight: 50,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(displayValue(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }
}