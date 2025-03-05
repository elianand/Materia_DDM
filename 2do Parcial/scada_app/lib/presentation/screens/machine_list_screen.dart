import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scada_app/core/providers/providers.dart';

import '../../data/models/machine_model.dart';
import '../utils/base_screen_state.dart';

class MachineListScreen extends ConsumerStatefulWidget {
  const MachineListScreen({
    super.key,
    required this.machineType
  });
  
  final MachinesTypeE machineType; 

  @override
  MachinesScreenState createState() => MachinesScreenState();
}

class MachinesScreenState extends ConsumerState<MachineListScreen> {

  List<MachineModel> machines = [];
  final scafoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool isRefreshing = false;
  bool hasError = false;

  late List<MachineDescriptor> machineViewList;


  String getAppBarTitle() {
    switch (widget.machineType) {
      case MachinesTypeE.injectionMolding:
        return 'Injection mold';
      case MachinesTypeE.crusher:
        return 'Crusher machines';
      default:
        return 'Unknown';
    }
  }
  

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {

      ref.read(machineListProvider.notifier).getMachinesByType(widget.machineType);
    });
    

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: 
          Text(getAppBarTitle(), textAlign: TextAlign.center),
          
          centerTitle: true
      ),
      body: Builder(builder: (context) {
        final machinesProvider = ref.watch(machineListProvider);

        switch(machinesProvider.screenState) {
          case BaseScreenState.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case BaseScreenState.idle:

            if(machinesProvider.machineList == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            machineViewList = machinesProvider.machineList!.map((elem) {
              return MachineDescriptor(
                id: elem.id,
                name: elem.name,
                brand: elem.brand,
                description: elem.description,
                imageUrl: elem.imageUrl,
              );
            }).toList();
            
            return ListView.builder(
              itemCount: machineViewList.length, 
              itemBuilder: (context, index) {
                return _MachineDescriptorItem(machine: machineViewList[index],);
              }
            );
            
          case BaseScreenState.error:
            return const Center(child: Text('Error al cargar los datos'));
          default:
            return const Center(child: Text('Nada que mostrar'));
        }
      
      }),
      
      
    );
  }
}


class _MachineDescriptorItem extends ConsumerWidget  {
  const _MachineDescriptorItem({
    required this.machine
  });

  

  final MachineDescriptor machine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        context.push('/machineDetail', extra: machine.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Card(
          child: ListTile(
            //tileColor: Colors.grey,
            leading: machine.imageUrl != "" 
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8) ,
                  child: Image.network(
                    machine.imageUrl!,
                    width: 50,
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      // Retorna una imagen de placeholder o un widget alternativo cuando ocurre un error
                      return const Icon(
                        Icons.error, // Mostrar un ícono de error
                        size: 40,
                        color: Colors.red,
                      );
                    },
                  ),
                )
              : const Icon(Icons.precision_manufacturing),
            title: Text("Name: ${machine.name}"),
            subtitle: Text("Brand: ${machine.brand} \nDescription: ${machine.description}"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}


class MachineDescriptor {

  final int id;
  final String name;
  final String brand;
  final String description;
  final String? imageUrl;

  MachineDescriptor({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.imageUrl,
  });
}