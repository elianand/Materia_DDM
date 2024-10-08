import 'dart:io';
import 'package:app_parcial1/domain/models/machine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data_generation/data_generator.dart';
import '../../providers/general_provider.dart';

class MachineDetailScreen extends ConsumerStatefulWidget {
  const MachineDetailScreen({super.key, required this.machineId});
  
  final int machineId;

  @override
  MachineDetailScreenState createState() => MachineDetailScreenState();
}

class MachineDetailScreenState extends ConsumerState<MachineDetailScreen> {
  
  bool onRefresh = false;
  late DataGenerator dataGen;

  @override
  void initState() {
    super.initState();

    ref.read(machinesDataProvider.notifier).cleanMachineDetail();

    // Creamos el objeto generador
    dataGen = DataGenerator(
      intervalo: const Duration(seconds: 1), 
      id: ref.read(machinesDataProvider.notifier).getMachineDetailId()!, 
      idType: ref.read(machinesDataProvider.notifier).getMachineDetailType()!, 
    );

    // Lo iniciamos
    dataGen.start();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(machinesDataProvider.notifier).getMachineDetail();
    });
  }

  @override
  void dispose() {
    // Al cerrar la pantalla detenemos el generador
    dataGen.stop();
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Machine Detail"),
        centerTitle: true,
      ),
      
      body: RefreshIndicator(
        onRefresh: () async {

          setState(() {
            onRefresh = true;
          });

          await ref.read(machinesDataProvider.notifier).getMachineDetail();

          setState(() {
            onRefresh = false;
          });
        },

        child: Builder(builder: (context) {
        
          final machinesProvider = ref.watch(machinesDataProvider);
        
          switch(machinesProvider.requestState) {
            case ProviderState.loading:
            
              if(onRefresh) {
                final machineType = machinesProvider.machineDetailType; 
                switch(machineType) {
        
                  case 1:
                    return _InjMoldDetail(injMoldMachine: machinesProvider.getMachineDetail() as InjectionMolding?);
        
                  case 2:
                    return _CrusherDetail(crusherMachine: machinesProvider.getMachineDetail() as Crusher?);
        
                  default:
                    return const Center(child: Text('Nada que mostrar'));
                }
              }else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            case ProviderState.success:
              onRefresh = false;
              final machineType = machinesProvider.machineDetailType; 
              switch(machineType) {
        
                case 1:
                  return _InjMoldDetail(injMoldMachine: machinesProvider.getMachineDetail() as InjectionMolding?);
        
                case 2:
                  return _CrusherDetail(crusherMachine: machinesProvider.getMachineDetail() as Crusher?);
        
                default:
                  return const Center(child: Text('Nada que mostrar'));
              }
            case ProviderState.error:
              return const Center(child: Text('Error al cargar los datos'));
            case ProviderState.idle:
              return const Center(child: Text('En idle'));
            default:
              return const Center(child: Text('Nada que mostrar'));
          }
        
        }),
      ),
    );
  }
}

class _InjMoldDetail extends ConsumerWidget {
  const _InjMoldDetail({
    required this.injMoldMachine
  });

  final InjectionMolding? injMoldMachine;
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    if(injMoldMachine == null) {
      return const Center(
        child: Text('No machine data available'),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Imagen de la máquina
            Center(
              child: Container(
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(15),
                  // Le vamos a generar una sombra a la imagen
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Builder(builder: (context) {

                    // Si no le cargamos una posterURL al crearla nos muestra la
                    // siguiente imagen

                    if(injMoldMachine!.posterUrl == null) {
                      return Image.asset(
                        "assets/images/Type_NoImage.png",
                        height: 200,
                      );
                    }else {
                      return Image.file(
                        File(injMoldMachine!.posterUrl ?? ""), 
                        height: 200,
                        fit: BoxFit.cover,

                        // Si lo cargamos pero no lo encuentra entre los datos

                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {  
                          return Image.asset(
                            "assets/images/Type_NotFound.webp",
                            height: 200,
                          );
                        },
                      );
                    }

                  }) 
                ),
              ),
            ),
            const SizedBox(height: 20),
      
            // Texto de la cantidad producida
            Center(
              child: Column(
                children: [

                  // Cantidad producida
                  const Text(
                    'Quantity produced:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Cantidad de piezas
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 64),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                      shape: BoxShape.rectangle,
                      color: Colors.lightBlueAccent,
                    ),
                    child: Text(
                      '${injMoldMachine?.produced} pieces',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]
              ),
            ),
            
            
            const SizedBox(height: 10),
      
            // Estado de la máquina (encendido/apagado)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Temperature[°C]: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ((injMoldMachine?.temp ?? 0) < 80) ? Colors.blue : Colors.red,
                        width: 3,
                      ),
                    ),
                    child: Text(
                      injMoldMachine?.temp.toString() ?? "N/A",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ((injMoldMachine?.temp ?? 0) < 80) ? Colors.blue : Colors.red,
                      ),
                    ),
                  ),
                  const Icon(Icons.device_thermostat),
                ]
              ),
            ),


            const SizedBox(height: 20),
      
            // Datos de la presion 
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Pressure[bar]: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ((injMoldMachine?.pressure ?? 0) < 40) ? Colors.blue : Colors.red,
                        width: 3,
                      ),
                    ),
                    child: Text(
                      injMoldMachine?.pressure.toString() ?? "N/A",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ((injMoldMachine?.pressure ?? 0) < 40) ? Colors.blue : Colors.red,
                      ),
                    ),
                  ),
                  const Icon(Icons.shutter_speed),
                ]
              ),
            ),

            const SizedBox(height: 20),
      
            // Separador
            const Divider(thickness: 2),

            const SizedBox(height: 20),
      
            // Tipo de máquina
            const Text(
              'Machine type: Inyection Molding',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
      
            // Marca
            Text(
              'Brand: ${injMoldMachine?.brand}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
      
            // Descripcion
            Text(
              'Description: ${injMoldMachine?.description}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 60),
      
            // Botón de borrar
            Center(
              child: Builder(builder: (context) {

                final machinesProvider = ref.watch(machinesDataProvider);

                switch(machinesProvider.requestState) {
                  case ProviderState.loading:
                    return ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    );
                  case ProviderState.error:
                    return const Text('Error al cargar los datos');
                  case ProviderState.idle || ProviderState.success:
                    return DeleteButtonWidget(injMoldMachine: injMoldMachine);
                }
                
              }),              
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteButtonWidget extends ConsumerStatefulWidget {
  const DeleteButtonWidget({
    super.key,
    required this.injMoldMachine,
  });

  final InjectionMolding? injMoldMachine;

  @override
  DeleteButtonWidgetState createState() => DeleteButtonWidgetState();
}


class DeleteButtonWidgetState extends ConsumerState<DeleteButtonWidget>  {  

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            bool isDeleting = false;
            bool isDeleted = false;

            return StatefulBuilder(
              builder: (context, setState) {

                if(isDeleted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pop();
                  context.pop();
                  });
                }
                return AlertDialog(
                  title: const Text('Delete machine!!'),
                  content: SizedBox(
                    height: 100,
                    child: isDeleting
                        ? const Center(child: CircularProgressIndicator())
                        : const Text('Are you sure you want to delete this machine?'),
                  ),
                  actions: isDeleting
                      ? []
                      : [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async {

                              setState(() {
                                isDeleting = true;
                              });
    
                              try {
                                
                                // Llama a la función para eliminar la máquina
                                await ref.read(machinesDataProvider.notifier).deleteMachine(widget.injMoldMachine!.id, 1);
                                
                                setState(() {
                                  isDeleted = true;
                                });
                                
                              } catch(e) {
                                setState(() {
                                  isDeleting = false;
                                });
                              }
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                );
              },
            );
          }
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: const Text(
        'Delete',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}






class _CrusherDetail extends ConsumerWidget {
  const _CrusherDetail({
    required this.crusherMachine,
  });

  final Crusher? crusherMachine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    if(crusherMachine == null) {
      return const Center(
        child: Text('No machine data available'),
      );
    }


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Imagen de la máquina
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5), 
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Builder(builder: (context) {

                    if(crusherMachine!.posterUrl == null) {
                      return Image.asset(
                        "assets/images/Type_NoImage.png",
                        height: 200,
                      );
                    }else {
                      return Image.file(
                        File(crusherMachine!.posterUrl ?? ""), 
                        height: 200,
                        fit: BoxFit.cover,

                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Image.asset(
                            "assets/images/Type_NotFound.webp",
                            height: 200,
                          );
                        },
                      );
                    }

                  }) 
                ),
              ),
            ),


            const SizedBox(height: 20),
      
            // Estado de la máquina (encendido/apagado)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "State: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: crusherMachine?.isActive() ?? true ? Colors.green : Colors.red,
                        width: 3,
                      ),
                    ),
                    child: Text(
                      crusherMachine?.isActive() ?? true ? 'ON' : 'OFF',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: crusherMachine?.isActive() ?? true ? Colors.green : Colors.red,
                      ),
                    ),
                  )
                ]
              ),
            ),

            const SizedBox(height: 20),

            // Separador
            const Divider(thickness: 2),

            const SizedBox(height: 20),
      
            // Tipo de máquina
            const Text(
              'Machine type: Crusher',
              style: TextStyle(
                fontSize: 18,
                //fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
      
            // Marca
            Text(
              'Brand: ${crusherMachine?.brand}',
              style: const TextStyle(
                fontSize: 18,
                //fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Tipo de máquina
            Text(
              'Capacity: ${crusherMachine?.capacity} kg',
              style: const TextStyle(
                fontSize: 18,
                //fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Tipo de máquina
            Text(
              'Speed: ${crusherMachine?.speed} rpm',
              style: const TextStyle(
                fontSize: 18,
                //fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
      
            // Descripción
            Text(
              'Description: ${crusherMachine?.description}',
              style: const TextStyle(
                fontSize: 18,
                //fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 60),
      
            // Botón de borrar
            Center(
              child: Builder(builder: (context) {

                final machinesProvider = ref.watch(machinesDataProvider);

                switch(machinesProvider.requestState) {
                  case ProviderState.loading:
                    return ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    );
                  case ProviderState.error:
                    return const Text('Error al cargar los datos');
                  case ProviderState.idle || ProviderState.success:
                    return ElevatedButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {

                            bool isDeleting = false;
                            bool isDeleted = false;

                            return StatefulBuilder(
                              builder: (context, setState) {

                                if(isDeleted) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Navigator.of(context).pop();
                                  context.pop();
                                  });
                                }

                                return AlertDialog(
                                  title: const Text('Delete machine!!'),
                                  content: SizedBox(
                                    height: 100,
                                    child: isDeleting
                                        ? const Center(child: CircularProgressIndicator())
                                        : const Text('Are you sure you want to delete this machine?'),
                                  ),
                                  actions: isDeleting
                                      ? []
                                      : [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                isDeleting = true;
                                              });

                                              try {
                                                
                                                await ref.read(machinesDataProvider.notifier).deleteMachine(crusherMachine!.id, 2);
                                                
                                                setState(() {
                                                  isDeleted = true;
                                                });
                                              
                                              } catch (e) {
                                                setState(() {
                                                  isDeleting = false;
                                                });
                                              }
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                );
                              },
                            );
                          }
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Color del botón
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    );
                }
              }),              
            ),
          ],
        ),
      ),
    );
  }
}
