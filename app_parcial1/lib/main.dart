import 'package:app_parcial1/core/router/app_router.dart';
import 'package:app_parcial1/data/entities/local_machines_repository.dart';
import 'package:app_parcial1/domain/models/machine.dart';
import 'package:app_parcial1/providers/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/database/database.dart';
import 'data/entities/local_users_repository.dart';
import 'domain/models/user.dart';

late AppDatabase database;

void main() async {

  late final List<User> usersFuture;
  late final List<Machine> machinesFuture;
  late final List<InjectionMolding> machinesinjMold;
  late final List<Crusher> machinesCrusher;
  
  
  // Ensure that the binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Calculamos el tiempo que tarda la base de datos en iniciarse
  final stopwatch = Stopwatch()..start();
  database = await AppDatabase.create('app_database10.db');
  stopwatch.stop();
  //             -------------

  debugPrint('Database initialized in ${stopwatch.elapsed.inMilliseconds}ms');
  
  debugPrint("Primero los usuarios");
  usersFuture = await LocalUsersRepository().getUsers();
  for(var elem in usersFuture) {
    debugPrint(elem.idUser.toString());
  }

  debugPrint("Primero las maquinas");
  machinesFuture = await LocalMachinesRepository().getMachines();
  for(var elem in machinesFuture) {
    debugPrint(elem.id.toString());
  }

  debugPrint("Segundo la INjection Molding");
  machinesinjMold = await LocalMachinesRepository().getInjMoldMachines();
  for(var elem in machinesinjMold) {
    debugPrint(elem.id.toString());
  }

  debugPrint("Tercero las crusher machines");
  machinesCrusher = await LocalMachinesRepository().getCrusherMachines();
  for(var elem in machinesCrusher) {
    debugPrint(elem.id.toString());
  }
  


  // Le informo a la App que voy a usar riverpod
  runApp(const ProviderScope(
    child: MainApp(),
  ));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appTheme = ref.watch(themeNotifierProvider);
    
    return MaterialApp.router(
      // Sacamos la bandera de debug
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: appTheme.getTheme(),
    );
  }
}
