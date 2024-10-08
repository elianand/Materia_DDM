import 'dart:io';
import 'package:app_parcial1/domain/models/machine.dart';
import 'package:app_parcial1/domain/models/user.dart';
import 'package:app_parcial1/presentation/widgets/drawer_machine_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/entities/local_machines_repository.dart';
import '../../providers/general_provider.dart';

class MachinesScreen extends ConsumerStatefulWidget {
  const MachinesScreen({
    super.key,
    required this.machineType
  });
  
  final int machineType; 

  @override
  MachinesScreenState createState() => MachinesScreenState();
}

class MachinesScreenState extends ConsumerState<MachinesScreen> {

  List<Machine> machines = [];
  final scafoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool isRefreshing = false;
  bool hasError = false;

  late final User user;
  late final Future<List<InjectionMolding>> inyectMouldFuture;
  late final Future<List<Crusher>> crusherFuture;
  late final MachinesEnum machineType;
  late final Future<List<Machine>> machinesFuture;
  late List<MachineDescriptor> machineViewList;
  

  @override
  void initState() {
    super.initState();
        
    machineType = switch(widget.machineType) {
      1 => MachinesEnum.injectionMolding,
      2 => MachinesEnum.crusher,
      _ => MachinesEnum.injectionMolding
    };
    user = ref.read(userDataProvider);

    switch(machineType) {
      case MachinesEnum.injectionMolding:
        inyectMouldFuture = LocalMachinesRepository().getInyectMoldMachineByIdComp(user.idComp);
        break;
      case MachinesEnum.crusher:
        crusherFuture = LocalMachinesRepository().getCrusherMachineByIdComp(user.idComp);
        break;
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {

      ref.read(machinesDataProvider.notifier).getMachineByIdCompAndIdType(user.idComp, widget.machineType);
    });
    

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: 
          switch(machineType) {
            MachinesEnum.injectionMolding => const Text("Injection Mold Machines", textAlign: TextAlign.center,),
            MachinesEnum.crusher => const Text("Crusher Machines", textAlign: TextAlign.center,),
          },
          centerTitle: true
      ),
      body: Builder(builder: (context) {
        final machinesProvider = ref.watch(machinesDataProvider);

        switch(machinesProvider.requestState) {
          case ProviderState.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ProviderState.success:
            
            switch(machineType) {
              case MachinesEnum.injectionMolding:
                machineViewList = machinesProvider.getInyectionMoldingMachines()!.map((elem) {
                  return MachineDescriptor(
                    id: elem.id,
                    brand: elem.brand,
                    description: elem.description,
                    posterUrl: elem.posterUrl,
                    idType: 1
                  );
                }).toList();
              break;

              case MachinesEnum.crusher:
                machineViewList = machinesProvider.getCrusherMachines()!.map((elem) {
                  return MachineDescriptor(
                    id: elem.id,
                    brand: elem.brand,
                    description: elem.description,
                    posterUrl: elem.posterUrl,
                    idType: 2,
                  );
                }).toList();
              break;
            }
            
            return ListView.builder(
              itemCount: machineViewList.length, 
              itemBuilder: (context, index) {
                return _MachineDescriptorItem(machine: machineViewList[index],);
              }
            );
            
          case ProviderState.error:
            return const Center(child: Text('Error al cargar los datos'));
          case ProviderState.idle:
            return const Center(child: Text('En idle'));
          default:
            return const Center(child: Text('Nada que mostrar'));
        }
      
      }),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
      
      drawer: DrawerMenu(
        scafoldKey: scafoldKey,
      ),
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
        final machinesProvider = ref.watch(machinesDataProvider);
        machinesProvider.setMachineDetailIdAndType(machine.id, machine.idType);
        context.push('/machineDetail', extra: machine.id);
      },
      child: Card(
        child: ListTile(
          leading: machine.posterUrl != null 
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8) ,
                child: Image.file(
                  File(machine.posterUrl!), 
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
          title: Text("Brand: ${machine.brand}"),
                    
          subtitle: Text("Descripcion: ${machine.description}"),
          trailing: const Icon(Icons.arrow_forward_ios),
          
        ),
      ),
    );
  }
}


class MachineDescriptor {

  final int id;
  final String brand;
  final String description;
  final String? posterUrl;
  final int idType;

  MachineDescriptor({
    required this.id,
    required this.brand,
    required this.description,
    required this.posterUrl,
    required this.idType,
  });
}