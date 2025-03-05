import '../../data/models/machine_model.dart';
import '../../presentation/widgets/drawer_machine_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../utils/base_screen_state.dart';
import '../../core/providers/providers.dart';


class MachineTypeScreen extends ConsumerStatefulWidget {
  const MachineTypeScreen({
    super.key,
  });

  @override
  MachineTypeScreenState createState() => MachineTypeScreenState();
}

class MachineTypeScreenState extends ConsumerState<MachineTypeScreen> {

  final scafoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(machineTypeProvider.notifier).getMachineCount();
    });
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("Machine types", textAlign: TextAlign.center,),
        centerTitle: true,
      ),

      body: Builder(builder: (context) {
        final provider = ref.watch(machineTypeProvider);

        switch(provider.screenState) {
          case BaseScreenState.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case BaseScreenState.idle:
            return _MachineTypesView(listMachineTypes: provider.listMachinesType);
          case BaseScreenState.error:
            return const Center(child: Text('Error al cargar los datos'));
          default:
            return const Center(child: Text('Nada que mostrar'));
        }
      
      }),

      drawer: DrawerMenu(
        scafoldKey: scafoldKey,
      ),
    );
  }


}

class _MachineTypesView extends StatelessWidget {
  const _MachineTypesView({
    required this.listMachineTypes,
  });

  final List<int> listMachineTypes;

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
          type: switch(index) {
            0 => MachinesTypeE.injectionMolding,
            1 => MachinesTypeE.crusher,
            _ => MachinesTypeE.injectionMolding,
          },
          count: listMachineTypes[index]
        );
      }
    );
  }
}




class _MachineTypeItem extends StatelessWidget {
  const _MachineTypeItem({
    required this.type,
    required this.count,
  });

  final MachinesTypeE type;
  final int count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/machineList', extra: type),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [

            Image.asset(
              switch(type) {
                MachinesTypeE.injectionMolding => "assets/images/Type_InjMold.webp",
                MachinesTypeE.crusher => "assets/images/Type_Crusher.png",
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
                  MachinesTypeE.injectionMolding => "Inyection molding: count $count",
                  MachinesTypeE.crusher => "Crusher: count $count",
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

