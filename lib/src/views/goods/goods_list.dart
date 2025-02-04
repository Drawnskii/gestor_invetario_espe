import 'package:flutter/material.dart';
import '../../services/goods_list_service.dart';
import '../../services/keeper_list_service.dart';
import '../../services/location_list_service.dart';
import '../../services/good_type_list_service.dart';
import '../../models/keeper_name.dart';
import '../../models/location_name.dart';
import '../../models/good_type.dart';
import '../../models/goods_list/goods_response.dart';

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

  late Future<GoodsResponse> futureGoods;
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

  // Variables para manejar la paginación
  String? nextPage;
  String? previousPage;

  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _keeperNameController = TextEditingController();
    futureGoods = goodsService.fetchGoods(page: currentPage);
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
        page: currentPage,  // Keep the current page when applying filters
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

    futureGoods = goodsService.fetchGoods(page: currentPage); // Reset to current page
    FocusScope.of(context).unfocus();
  }

  bool get isFilterActive {
    return selectedKeeper != null ||
        selectedLocation != null ||
        selectedType != null ||
        descriptionFilter.isNotEmpty ||
        keeperFullNameFilter.isNotEmpty;
  }

  // Función para cargar la siguiente página
  void _loadNextPage() {
    if (nextPage != null) {
      currentPage++;
      setState(() {
        futureGoods = goodsService.fetchGoods(page: currentPage);
      });
    }
  }

  // Función para cargar la página anterior
  void _loadPreviousPage() {
    if (previousPage != null) {
      currentPage--;
      setState(() {
        futureGoods = goodsService.fetchGoods(page: currentPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onInverseSurface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.2), // Color de la sombra con opacidad
                  offset: Offset(0, 2), // Desplazamiento más pequeño para una sombra más sutil
                  blurRadius: 8, // Difuminado más suave
                  spreadRadius: 1, // Extensión ligera para que la sombra no sea demasiado corta
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filtro por Tipo de Bienes
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

                // Filtros por Encargado y Ubicación
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

                // Filtros por Descripción y Botones
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
            child: FutureBuilder<GoodsResponse>(
              future: futureGoods,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
                  return const Center(
                    child: Text(
                      "No hay bienes disponibles",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                GoodsResponse response = snapshot.data!;

                // Guardamos los valores de la paginación
                nextPage = response.next;
                previousPage = response.previous;

                return Column(
                  children: [
                    // Lista de bienes
                    Expanded(
                      child: ListView.builder(
                        itemCount: response.results.length,
                        itemBuilder: (context, index) {
                          final good = response.results[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.inventory_rounded,
                                      size: 32,
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          good.description,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        _buildInfoRow(
                                          icon: Icons.person_outline,
                                          text: "${good.keeper.firstName} ${good.keeper.lastName}",
                                        ),
                                        const SizedBox(height: 4),
                                        _buildInfoRow(
                                          icon: Icons.code,
                                          text: good.code,
                                        ),
                                        const SizedBox(height: 4),
                                        _buildInfoRow(
                                          icon: Icons.location_on_outlined,
                                          text: good.location.name,
                                        ),
                                        const SizedBox(height: 4),
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
                      ),
                    ),
                    // Botones de navegación
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: previousPage != null ? _loadPreviousPage : null,
                          style: IconButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            '$currentPage',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: nextPage != null ? _loadNextPage : null,
                          style: IconButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                  ],
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
        return DropdownMenuItem<T>(value: item, child: Text(displayValue(item)));
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
