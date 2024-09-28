import 'package:app_parcial1/domain/models/machine.dart';
import 'package:app_parcial1/domain/models/user.dart';
import 'package:app_parcial1/presentation/widgets/drawer_machine_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/entities/local_machines_repository.dart';
import '../../theme/providers/general_provider.dart';

class MachinesScreen extends ConsumerStatefulWidget {
  
  final int machineType; 
  
  const MachinesScreen({
    super.key,
    required this.machineType
  });

  //const MachinesScreen({Key? key, this.user}) : super(key: key);


  @override
  _MachinesScreenState createState() => _MachinesScreenState();
}

class _MachinesScreenState extends ConsumerState<MachinesScreen> {

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
    
    //machinesFuture = JsonMachinesRepository().getMachines();  // Base de datos no relacional
    
    machineType = switch(widget.machineType) {
      1 => MachinesEnum.injectionMolding,
      2 => MachinesEnum.crusher,
      _ => MachinesEnum.injectionMolding
    };
    user = ref.read(userDataProvider);
    //machinesFuture = LocalMachinesRepository().getMachines();   // Base de datos relacional
    //machinesFuture = LocalMachinesRepository().getMachineByIdCompAndIdType(user.idComp, widget.machineType);
    
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
         //textAlign: TextAlign.center,
        //),
      ),
      body: Builder(builder: (context) {
        final machinesProvider = ref.watch(machinesDataProvider);

        switch(machinesProvider.requestState) {
          case ProviderState.loading:
            return const Center(
              child: CircularProgressIndicator(),  // Muestra el indicador de progreso mientras se cargan los datos
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
            return const Center(child: Text('Error al cargar los datos')); // Mensaje de error
          case ProviderState.idle:
            return const Center(child: Text('En idle')); // Mensaje de error
          default:
            return const Center(child: Text('Nada que mostrar')); // Estado por defecto
        }
      
      }),
      /*
      FutureBuilder(
        future: switch(machineType) {
          MachinesEnum.injectionMolding => inyectMouldFuture,
          MachinesEnum.crusher => crusherFuture
        }, 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          
          switch(machineType) {
            case MachinesEnum.injectionMolding:
              //final machineList = snapshot.data as List<Machine>;
              machineViewList = (snapshot.data as List<InjectionMolding>).map((elem) {
                return MachineDescriptor(
                  id: elem.id,
                  brand: elem.brand,
                  description: elem.description,
                  posterUrl: elem.posterUrl
                );
              }).toList();
              break;
            case MachinesEnum.crusher:
              //final machineList = snapshot.data as List<Machine>;
              machineViewList = (snapshot.data as List<Crusher>).map((elem) {
                return MachineDescriptor(
                  id: elem.id,
                  brand: elem.brand,
                  description: elem.description,
                  posterUrl: elem.posterUrl
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
        }
      ),
      */
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Volver atrás
        },
        child: const Icon(Icons.arrow_back),
      ),
      /*
      Builder(builder: (BuildContext context) {
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => _getMachinesByIdComp(1, true),
              child: _MachinesView(machines: machines.where((i) => i.idComp == widget.user.idComp).toList())),
            (isLoading) ? (Text("data")) : (Text("No data")),
          ]
        );
      }),
        */
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
      },   //'/machines', extra: user
      child: Card(
        child: ListTile(
          leading: machine.posterUrl != null 
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8) ,
                child: Image.asset(machine.posterUrl!, width: 50,),
              )
            : const Icon(Icons.movie),
          title: Text("Brand: ${machine.brand}"),
                    
          subtitle: Text("Descripcion: ${machine.description}"),
          trailing: const Icon(Icons.arrow_forward_ios),
          //onTap: () {
      
          //  context.push('/movieDetail/${movie.id}');
          //},
          
        ),
      ),
    );
  }
}


class MachineDescriptor {

  final int id;
  final String brand;
  final String description;
  final String? posterUrl;  // Aca va la imagen, es inpresindible

  final int idType;


  MachineDescriptor({
    required this.id,
    required this.brand,
    required this.description,
    required this.posterUrl,
    required this.idType,
  });
}