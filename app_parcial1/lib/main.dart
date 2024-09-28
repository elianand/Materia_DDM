import 'dart:developer';

import 'package:app_parcial1/core/router/app_router.dart';
import 'package:app_parcial1/data/entities/local_machines_repository.dart';
import 'package:app_parcial1/domain/models/machine.dart';
import 'package:app_parcial1/theme/providers/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/database/database.dart';

late AppDatabase database;

void main() async {

  late final List<Machine> machinesFuture;
  late final List<InjectionMolding> machinesinjMold;
  late final List<Crusher> machinesCrusher;
  
  
  // Ensure that the binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database and measure initialization time
  final stopwatch = Stopwatch()..start();
  database = await AppDatabase.create('app_database8.db');
  stopwatch.stop();
  log('Database initialized in ${stopwatch.elapsed.inMilliseconds}ms');
  
  log("Primero las maquinas");
  machinesFuture = await LocalMachinesRepository().getMachines();
  machinesFuture.forEach((elem) {
    log(elem.id.toString());
  }); 

  log("Segundo la INjection Molding");
  machinesinjMold = await LocalMachinesRepository().getInjMoldMachines();
  machinesinjMold.forEach((elem) {
    log(elem.id.toString());
  }); 

  log("Tercero las crusher machines");
  machinesCrusher = await LocalMachinesRepository().getCrusherMachines();
  machinesCrusher.forEach((elem) {
    log(elem.id.toString());
  }); 
  


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
      //Para sacar la banderita??
      debugShowCheckedModeBanner: false,
      //Pub dev es una pagina para buscar librerias  
      routerConfig: appRouter,
      theme: appTheme.getTheme(),
    );
  }
}
