import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../data/models/machine_model.dart';
import '../utils/base_screen_state.dart';

class DeviceConfigScreen extends ConsumerStatefulWidget {
  const DeviceConfigScreen({super.key});
 
  @override
  DeviceConfigScreenState createState() => DeviceConfigScreenState();
}

class DeviceConfigScreenState extends ConsumerState<DeviceConfigScreen> {

  final TextEditingController _searchController = TextEditingController();
  
  List<MachineModel>? machineList;
  List<int>? machineIndex;
  List<MachineModel> filterMachines = [];

  @override
  void initState() {
    super.initState();


    // Escuchamos los cambios en el controlador de búsqueda
    _searchController.addListener(_filterMachines);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deviceConfigProvider.notifier).getMachines();
    });
  }

  void _filterMachines() {
    String query = _searchController.text.toLowerCase();
    setState(() {

      if (machineList != null) {
        filterMachines = machineList!.where((order) {
          return order.name.toLowerCase().contains(query) ||
              order.brand.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Device configuration'),
        centerTitle: true,
      ),
      body: Builder(builder: (context) {
        final machinesProvider = ref.watch(deviceConfigProvider);
        machineList = ref.watch(deviceConfigProvider).machineList;
        if(machineList != null && filterMachines.isEmpty) {
          filterMachines = machineList!;
        }
        

        switch(machinesProvider.screenState) {
          case BaseScreenState.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case BaseScreenState.idle:
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by machine id or brand',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filterMachines.length,
                    itemBuilder: (context, index) {
                      final machine = filterMachines[index];
            
                      return _MachineItemWidget(
                        name: machine.name,
                        brand: machine.brand,
                        status: machine.getStatus(),
                        statusColor: switch(machine.getStatus()) {
                          "Detach" => Colors.orange.shade300,
                          "Offline" => Colors.red.shade300,
                          "Online" => Colors.green.shade300,
                          "Active" => Colors.blue.shade300,
                          _ => Colors.red.shade300,
                        },
                        enable: machinesProvider.userAdminLvl,
                        machineId: machine.id,
                      );
                    },
                  ),
                ),
              ],
            );
          case BaseScreenState.error:
            return const Center(child: Text('Error al cargar los datos'));
        }
      }),
      
    );
  }
}


class _MachineItemWidget extends ConsumerWidget {
  final String name;
  final String brand;
  final String status;
  final Color statusColor;
  final bool enable;
  final int machineId;

  const _MachineItemWidget({
    required this.name,
    required this.brand,
    required this.status,
    required this.statusColor,
    required this.enable,
    required this.machineId,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isThemeLight = ref.watch(themeNotifierProvider).isLigthMode();

    final viewModel = ref.watch(deviceConfigProvider.notifier);
    final isSwitched = viewModel.getSwitchState(machineId);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isThemeLight ? Colors.white : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: isThemeLight ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                brand,
                style: TextStyle(
                  color: isThemeLight? Colors.grey[600]: Colors.grey.shade300,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          Expanded(
            child: SwitchListTile(
              value: isSwitched,
              onChanged: enable ? (bool value) {
                viewModel.toggleSwitchState(machineId, value);
              } : null,
            ),
          )
          
        ],
      ),
    );
  }
}
