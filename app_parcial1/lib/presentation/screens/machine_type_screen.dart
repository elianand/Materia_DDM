import 'package:app_parcial1/domain/models/machine.dart';
import 'package:app_parcial1/domain/models/user.dart';
import 'package:app_parcial1/presentation/widgets/drawer_machine_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/entities/local_machines_repository.dart';
import '../../providers/general_provider.dart';

class MachineTypeScreen extends ConsumerStatefulWidget {
  const MachineTypeScreen({
    super.key,
  });

  @override
  MachineTypeScreenState createState() => MachineTypeScreenState();
}

class MachineTypeScreenState extends ConsumerState<MachineTypeScreen> {

  final scafoldKey = GlobalKey<ScaffoldState>();
  late final User user;
  late final Future<List<Machine>?> machinesFuture;

  @override
  void initState() {
    super.initState();

    user = ref.read(userDataProvider);
    machinesFuture = LocalMachinesRepository().getMachinesByIdComp(user.idComp);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(machinesDataProvider.notifier).getMachinesByIdComp(user.idComp);
    });
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("Machine Types", textAlign: TextAlign.center,),
        centerTitle: true,
      ),

      body: Builder(builder: (context) {
        final machinesProvider = ref.watch(machinesDataProvider);

        switch(machinesProvider.requestState) {
          case ProviderState.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ProviderState.success:
            return _MachineTypesView(listMachineTypes: machinesProvider.getListTypeOfMachines(), user: user);
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
          context.replace('/createMachine');
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
      onTap: () => context.push('/machines', extra: type),
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
      ),
    );
  }
}

