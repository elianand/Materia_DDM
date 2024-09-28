import 'package:app_parcial1/domain/models/machine.dart';
import 'package:app_parcial1/domain/models/user.dart';
import 'package:app_parcial1/presentation/widgets/drawer_machine_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/entities/local_machines_repository.dart';
import '../../theme/providers/general_provider.dart';

class MachineTypeScreen extends ConsumerStatefulWidget {
  
  
  MachineTypeScreen({
    super.key,
  });


  @override
  _MachineTypeScreenState createState() => _MachineTypeScreenState();
}

class _MachineTypeScreenState extends ConsumerState<MachineTypeScreen> {

  final scafoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool isRefreshing = false;
  bool hasError = false;

  late final User user;
  late final Future<List<Machine>?> machinesFuture;

  @override
  void initState() {
    super.initState();

    //user = widget.user;
    user = ref.read(userDataProvider);

    
      //machinesFuture = LocalMachinesRepository().getMachines();   // Base de datos relacional
    machinesFuture = LocalMachinesRepository().getMachinesByIdComp(user.idComp);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      ref.read(machinesDataProvider.notifier).getMachinesByIdComp(user.idComp);
      //user = widget.user;
      //machinesFuture = LocalMachinesRepository().getMachines();   // Base de datos relacional
      //machinesFuture = LocalMachinesRepository().getMachinesByIdComp(user.idComp);
    });
  }


  @override
  Widget build(BuildContext context) {

    //final machinesProvider = ref.watch(machinesDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Machine Types", textAlign: TextAlign.center,),
      ),
      body: Builder(builder: (context) {
        final machinesProvider = ref.watch(machinesDataProvider);

        switch(machinesProvider.requestState) {
          case ProviderState.loading:
            return const Center(
              child: CircularProgressIndicator(),  // Muestra el indicador de progreso mientras se cargan los datos
            );
          case ProviderState.success:
            return _MachineTypesView(listMachineTypes: machinesProvider.getListTypeOfMachines(), user: user);
          case ProviderState.error:
            return const Center(child: Text('Error al cargar los datos')); // Mensaje de error
          case ProviderState.idle:
            return const Center(child: Text('En idle')); // Mensaje de error
          default:
            return const Center(child: Text('Nada que mostrar')); // Estado por defecto
        }
      
      }),
      /*body: FutureBuilder(
        future: machinesFuture, 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // Aca vamos a procesar la info
          final machineList = snapshot.data as List<Machine>;
          // A partir de las lista vamos a buscar la cantidad de crushers 
          // y de inyection molding 
          List<int> listMachineTypes = List<int>.filled(2, 0);    // Dos elementos
          machineList.forEach((elem) => listMachineTypes[elem.idType-1]++);
          return _MachineTypesView(listMachineTypes: listMachineTypes, user: user);
        }
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.replace('/createMachine');
          
           // No hace nada por ahora
           // Aca vamso a agregar las maquinas
           // Aca estaria bueno copiar el simil tutorial 
        },
        child: const Icon(Icons.add),
      ),
        
      drawer: DrawerMenu(
        scafoldKey: scafoldKey,
      ),
    );
  }


}

class _MachineTypesView extends StatelessWidget {
  const _MachineTypesView({
    required this.listMachineTypes,
    required this.user
  });

  final List<int> listMachineTypes;
  final User user;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 0.6
      ),
      itemCount: listMachineTypes.length,
      itemBuilder: (context, index) {
        
        return _MachineTypeItem(
          type: index+1,
          count: listMachineTypes[index],
          user: user
        );
      }
    );
  }
}




class _MachineTypeItem extends StatelessWidget {
  const _MachineTypeItem({
    required this.type,
    required this.count,
    required this.user
  });

  final int type;
  final int count;
  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/machines', extra: type),   //'/machines', extra: user
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Image.asset(
              switch(type) {
                1 => "assets/images/Type_InjMold.webp",
                2 => "assets/images/Type_Crusher.png",
                _ => "assets/images/Type_NotFound.webp"
              },
            
              height: 200,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.red,
                  ],
                ),
              ),
              child: Text(
                switch(type) {
                  1 => "Inyection Molding: Count $count",
                  2 => "Crusher: Count $count",
                  _ => "Unknown"
                },
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        /*
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8) ,
            child: Image.asset(
              switch(type) {
                1 => "assets/images/Type_InjMold.webp",
                2 => "assets/images/Type_Crusher.webp",
                _ => "assets/images/Type_NotFound.webp"
              },
            
              width: 50,
            ),
          ),
          title: Text(
            switch(type) {
                1 => "Inyection Molding",
                2 => "Crusher",
                _ => "Unknown"
              },
          ),
          
          /*Builder(builder: (context) {
            
            switch(machine.idType) {
              //case MachinesEnum.injectionMolding:
              case 1:
                return Text("Inyection Molding");

              //case MachinesEnum.crusher:
              case 2:
                return Text("Crusher");

              default:
                return Text("Null");
            }
          }),*/
                    
          subtitle: Text("Count: $count"),
          trailing: const Icon(Icons.arrow_forward_ios),
          //onTap: () {
      
          //  context.push('/movieDetail/${movie.id}');
          //},
          
        ),*/
      ),
    );
  }
}

