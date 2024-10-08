import 'package:app_parcial1/presentation/screens/appconfig_screen.dart';
import 'package:app_parcial1/presentation/screens/device_config_screen.dart';
import 'package:app_parcial1/presentation/screens/login_screen.dart';
import 'package:app_parcial1/presentation/screens/logout_screen.dart';
import 'package:app_parcial1/presentation/screens/machine_detail_screen.dart';
import 'package:app_parcial1/presentation/screens/machine_type_screen.dart';
import 'package:app_parcial1/presentation/screens/machine_list_screen.dart';

import 'package:go_router/go_router.dart';

import '../../presentation/screens/machine_create_screen.dart';
import '../../presentation/screens/user_detail_screen.dart';

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
            builder: (context, state) => MachineDetailScreen(machineId: state.extra as int),
        ),
        GoRoute(
            path: '/appConfig',
            builder: (context, state) => const AppconfigScreen(),
        ),
        GoRoute(
            path: '/createMachine',
            builder: (context, state) => const CreateMachineScreen(),
        ),
        GoRoute(
            path: '/userDetail',
            builder: (context, state) => const UserDetailsScreen(),
        ),
        GoRoute(
            path: '/logout',
            builder: (context, state) => const LogoutScreen(),
        ),
        GoRoute(
            path: '/deviceConfig',
            builder: (context, state) => const DeviceConfigScreen(),
        ),
    ],
);