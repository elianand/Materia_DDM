import 'package:app_parcial1/presentation/screens/appconfig_screen.dart';
import 'package:app_parcial1/presentation/screens/login.dart';
import 'package:app_parcial1/presentation/screens/machine_detail_screen.dart';
import 'package:app_parcial1/presentation/screens/machine_type_screen.dart';
import 'package:app_parcial1/presentation/screens/machines_screen.dart';

import 'package:go_router/go_router.dart';

import '../../presentation/screens/machine_create_screen.dart';

final GoRouter appRouter  = GoRouter(
    // Ruta principal, la primera
    initialLocation: '/login',
    routes: [
        GoRoute(
            path: '/login',
            builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
            path: '/machineTypes',
            builder: (context, state) => MachineTypeScreen(),
        ),
        GoRoute(
            path: '/machines',
            builder: (context, state) => MachinesScreen(machineType: state.extra as int),
        ),
        GoRoute(
            path: '/machineDetail',
            //builder: (context, state) => MachineDetailScreen(machineId: state.pathParameters['machineId'] as int),
            builder: (context, state) => MachineDetailScreen(machineId: state.extra as int),
        ),
        GoRoute(
            path: '/appConfig',
            //builder: (context, state) => MachineDetailScreen(machineId: state.pathParameters['machineId'] as int),
            builder: (context, state) => const AppconfigScreen(),
        ),
        GoRoute(
            path: '/createMachine',
            //builder: (context, state) => MachineDetailScreen(machineId: state.pathParameters['machineId'] as int),
            builder: (context, state) => const CreateMachineScreen(),
        ),
        

        
        /*
        // Esta es una opcion un poco mas humilde
        GoRoute(
            path: '/home/:parameter',
            builder: (context, state) => HomeScreen(
                nombre: state.pathParameters['parameter'] ?? 'Ale',
                ),
        ),
        */


    ],
);