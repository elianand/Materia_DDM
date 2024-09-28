import 'package:app_parcial1/domain/models/machine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/providers/general_provider.dart';

class MachineDetailScreen extends ConsumerStatefulWidget {
  const MachineDetailScreen({super.key, required this.machineId});
  
  final int machineId;
  

  @override
  _MachineDetailScreenState createState() => _MachineDetailScreenState();

}

class _MachineDetailScreenState extends ConsumerState<MachineDetailScreen> {
  
  //late final Future<Machine> machineFuture;
  //late final Future<InjectionMolding?> injMoldMachineFuture;
  //late final Future<Crusher> crusherMachineFuture;


  @override
  void initState() {
    super.initState();

    ref.read(machinesDataProvider.notifier).cleanMachineDetail();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      ref.read(machinesDataProvider.notifier).getMachineDetail();
    });
  }
  
  
  @override
  Widget build(BuildContext context) {

    //machineFuture = await LocalMachinesRepository().getMachineById(machineId);
    //switch(machineFuture.id) {

    //}
    //injMoldMachineFuture = LocalMachinesRepository().getInyectMoldMachineById(machineId);

    //late final MachinesRepository machineRepo;// = MachinesRepository();
    //late final List<Machine> machineList = [];// = machineRepo.machineList;
    //const MachinesEnum machineType = MachinesEnum.injectionMolding;// = machineList.firstWhere((elemt) => elemt.id == machineId).idType;


    return Scaffold(
      appBar: AppBar(
        title: const Text("Machine detail"),
      ),
      
      body: Builder(builder: (context) {

        final machinesProvider = ref.watch(machinesDataProvider);

        switch(machinesProvider.requestState) {
          case ProviderState.loading:
            return const Center(
              child: CircularProgressIndicator(),  // Muestra el indicador de progreso mientras se cargan los datos
            );
          case ProviderState.success:

            final machineType = machinesProvider.machineDetailType; 
            switch(machineType) {

              case 1:
                return _InjMoldDetail(injMoldMachine: machinesProvider.getMachineDetail() as InjectionMolding?);

              case 2:
                return _CrusherDetail(crusherMachine: machinesProvider.getMachineDetail() as Crusher?);

              default:
                return const Center(child: Text('Nada que mostrar'));
            }
            //_MachineTypesView(listMachineTypes: machinesProvider.getListTypeOfMachines(), user: user);
          case ProviderState.error:
            return const Center(child: Text('Error al cargar los datos')); // Mensaje de error
          case ProviderState.idle:
            return const Center(child: Text('En idle')); // Mensaje de error
          default:
            return const Center(child: Text('Nada que mostrar')); // Estado por defecto
        }
      
      }),
      
      
      /*Builder(builder: (context) {
        switch(machineType) {

          case MachinesEnum.injectionMolding:

            InjectionMolding injMold = machineList.firstWhere((elemt) => elemt.id == machineId) as InjectionMolding;

            return _MachineInyectionMoldingDetailView(injMold: injMold);
        
          case MachinesEnum.crusher:
            return const Text("Hola");//_MachineInyectionMoldingDetailView(injMold: null);
        }
        
      })*/
      
      
      
    );
    
  }
}

class _InjMoldDetail extends ConsumerWidget {
  _InjMoldDetail({
    required this.injMoldMachine,
  });

  final InjectionMolding? injMoldMachine;
  final bool isOn = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen de la máquina
            Center(
              child: Container(
                //color: Color(0xff4c3336),
                decoration: BoxDecoration(
                  //color: Colors.grey[300], // Fondo detrás de la imagen
                  //color: Color(0xff4c3336),
                  borderRadius: BorderRadius.circular(15), // Bordes redondeados
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Sombra
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5), // Posición de la sombra
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Bordes redondeados para la imagen también
                  child: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
                    height: 200,
                    //width: 150,
                    fit: BoxFit.cover, // Para que la imagen cubra el espacio disponible
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
      
            // Texto de la cantidad producida
            Center(
              child: Column(
                children: [
                  const Text(
                    'Quantity produced:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 64),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.7), // Color inicial con opacidad
                        Theme.of(context).colorScheme.primary.withOpacity(0.3), // Color final (transparente)
                      ],
                      begin: Alignment.topLeft, // Inicia desde la parte superior
                      end: Alignment.bottomRight, // Termina en la parte inferior
                    ),
                      shape: BoxShape.rectangle,
                      color: Colors.lightBlueAccent,
                    ),
                    child: Text(
                      '${injMoldMachine?.produced} pieces',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        //color: Colors.white,
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
                      //color: Colors.grey[300], // Color de fondo
                      //color: Colors.black,
                      borderRadius: BorderRadius.circular(8), // Bordes redondeados
                      border: Border.all(
                        color: ((injMoldMachine?.temp ?? 0) < 50) ? Colors.blue : Colors.red,
                        width: 3,
                      ),
                      //color: Colors.black,
                      /*boxShadow: const [
                        BoxShadow(
                          color: Colors.black26, // Sombra ligera
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],*/
                    ),
                    child: Text(
                      injMoldMachine?.temp.toString() ?? "N/A",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ((injMoldMachine?.temp ?? 0) < 50) ? Colors.blue : Colors.red,
                      ),
                    ),
                  ),
                  const Icon(Icons.device_thermostat),
                ]
              ),
            ),
            const SizedBox(height: 20),
      
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
                      //color: Colors.grey[300], // Color de fondo
                      //color: Colors.black,
                      borderRadius: BorderRadius.circular(8), // Bordes redondeados
                      border: Border.all(
                        color: ((injMoldMachine?.temp ?? 0) < 50) ? Colors.blue : Colors.red,
                        width: 3,
                      ),
                      //color: Colors.black,
                      /*boxShadow: const [
                        BoxShadow(
                          color: Colors.black26, // Sombra ligera
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],*/
                    ),
                    child: Text(
                      injMoldMachine?.pressure.toString() ?? "N/A",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ((injMoldMachine?.temp ?? 0) < 100) ? Colors.blue : Colors.red,
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
                //fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
      
            // Marca
            Text(
              'Brand: ${injMoldMachine?.brand}',
              style: const TextStyle(
                fontSize: 18,
                //fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
      
            // Descripción
            Text(
              'Description: ${injMoldMachine?.description}',
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
                    return const CircularProgressIndicator();
                  case ProviderState.error:
                    return const Text('Error al cargar los datos');
                  case ProviderState.idle || ProviderState.success:
                    return ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            bool isDeleting = false; // Estado para saber si estamos eliminando
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text('Delete machine!!'),
                                  content: SizedBox(
                                    height: 100, // Define una altura fija
                                    child: isDeleting
                                        ? const Center(child: CircularProgressIndicator())
                                        : const Text('Are you sure you want to delete this machine?'),
                                  ),
                                  actions: isDeleting
                                      ? []
                                      : [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Cerrar diálogo
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            onPressed: () async {
                                              // Iniciar el estado de eliminación
                                              setState(() {
                                                isDeleting = true;
                                              });

                                              try {
                                                
                                                // Llama a la función para eliminar la máquina
                                                await ref.read(machinesDataProvider.notifier).deleteMachine(injMoldMachine!.id, 1);
                                                
                                                //int idComp = ref.read(userDataProvider).idComp;
                                                //ref.read(machinesDataProvider.notifier).getMachineByIdCompAndIdType(idComp, 1);
                                                
                                                // Eliminar completada, cerrar diálogo
                                                Navigator.of(context).pop();
                                                context.pop(); // Volver a la pantalla anterior
                                              
                                              } catch (e) {
                                                // Manejar errores en la eliminación si es necesario
                                                setState(() {
                                                  isDeleting = false;
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Error deleting machine'),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                );
                              },
                            );
                          }
                         
                          
                          
                          
                          /*=> AlertDialog(
                            title: const Text('Delete machine!!'),
                            content: const Text('Are you sure you want to delete this machine?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Cerrar diálogo
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  //textStyle: const TextStyle(fontSize: 20),
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  
                                  ref.read(machinesDataProvider.notifier).deleteMachine(injMoldMachine!.id, 1);
                                  Navigator.of(context).pop();
                                  context.pop();

                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                          */
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


/*

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('This is a custom SnackBar!'),
    backgroundColor: Colors.blue, // Cambia el color de fondo
    behavior: SnackBarBehavior.floating, // Hace que flote el SnackBar
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Bordes redondeados
  ),
);

*/





class _CrusherDetail extends ConsumerWidget {
  const _CrusherDetail({
    required this.crusherMachine,
  });

  final Crusher? crusherMachine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen de la máquina
            Center(
              child: Container(
                //color: Color(0xff4c3336),
                decoration: BoxDecoration(
                  //color: Colors.grey[300], // Fondo detrás de la imagen
                  //color: Color(0xff4c3336),
                  borderRadius: BorderRadius.circular(15), // Bordes redondeados
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Sombra
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5), // Posición de la sombra
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Bordes redondeados para la imagen también
                  child: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
                    height: 200,
                    //width: 150,
                    fit: BoxFit.cover, // Para que la imagen cubra el espacio disponible
                  ),
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
                      //color: Colors.grey[300], // Color de fondo
                      //color: Colors.black,
                      borderRadius: BorderRadius.circular(8), // Bordes redondeados
                      border: Border.all(
                        color: crusherMachine?.isActive() ?? true ? Colors.green : Colors.red,
                        width: 3,
                      ),
                      //color: Colors.black,
                      /*boxShadow: const [
                        BoxShadow(
                          color: Colors.black26, // Sombra ligera
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],*/
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
                    return const CircularProgressIndicator();
                  case ProviderState.error:
                    return const Text('Error al cargar los datos');
                  case ProviderState.idle || ProviderState.success:
                    return ElevatedButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            bool isDeleting = false; // Estado para saber si estamos eliminando
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text('Delete machine!!'),
                                  content: SizedBox(
                                    height: 100, // Define una altura fija
                                    child: isDeleting
                                        ? const Center(child: CircularProgressIndicator())
                                        : const Text('Are you sure you want to delete this machine?'),
                                  ),
                                  actions: isDeleting
                                      ? []
                                      : [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Cerrar diálogo
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            onPressed: () async {
                                              // Iniciar el estado de eliminación
                                              setState(() {
                                                isDeleting = true;
                                              });

                                              try {
                                                
                                                // Llama a la función para eliminar la máquina
                                                await ref.read(machinesDataProvider.notifier).deleteMachine(crusherMachine!.id, 2);
                                                
                                                //int idComp = ref.read(userDataProvider).idComp;
                                                //ref.read(machinesDataProvider.notifier).getMachineByIdCompAndIdType(idComp, 1);
                                                
                                                // Eliminar completada, cerrar diálogo
                                                Navigator.of(context).pop();
                                                context.pop(); // Volver a la pantalla anterior
                                              
                                              } catch (e) {
                                                // Manejar errores en la eliminación si es necesario
                                                setState(() {
                                                  isDeleting = false;
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Error deleting machine'),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                );
                              },
                            );
                          }
                         
                          
                          
                          
                          /*=> AlertDialog(
                            title: const Text('Delete machine!!'),
                            content: const Text('Are you sure you want to delete this machine?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Cerrar diálogo
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  //textStyle: const TextStyle(fontSize: 20),
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  
                                  ref.read(machinesDataProvider.notifier).deleteMachine(injMoldMachine!.id, 1);
                                  Navigator.of(context).pop();
                                  context.pop();

                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                          */
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
