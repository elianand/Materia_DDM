import 'package:go_router/go_router.dart';

import '../../data/models/machine_model.dart';
import '../../presentation/screens/appconfig_screen.dart';
import '../../presentation/screens/company_detail_screen.dart';
import '../../presentation/screens/create_account_screen.dart';
import '../../presentation/screens/device_config_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/logout_screen.dart';
import '../../presentation/screens/machine_detail_screen.dart';
import '../../presentation/screens/machine_list_screen.dart';
import '../../presentation/screens/machine_type_screen.dart';
import '../../presentation/screens/user_detail_screen.dart';

final GoRouter appRouter  = GoRouter(

  // Ruta raiz
  initialLocation: '/login',

  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/logout',
      builder: (context, state) => LogoutScreen(),
    ),
    GoRoute(
      path: '/machineTypes',
      builder: (context, state) => MachineTypeScreen(),
    ),
    GoRoute(
      path: '/machineList',
      builder: (context, state) => MachineListScreen(machineType: state.extra as MachinesTypeE),
    ),
    GoRoute(
      path: '/machineDetail',
      builder: (context, state) => MachineDetailScreen(machineId: state.extra as int),
    ),
    GoRoute(
      path: '/deviceConfig',
      builder: (context, state) => DeviceConfigScreen(),      
    ),
    GoRoute(
      path: '/deviceConfigDetail',
      builder: (context, state) => DeviceConfigScreen(),      
    ),
    GoRoute(
      path: '/appConfig',
      builder: (context, state) => AppconfigScreen(),      
    ),
    GoRoute(
      path: '/userDetail',
      builder: (context, state) => UserDetailsScreen(),      
    ),
    GoRoute(
      path: '/companyDetail',
      builder: (context, state) => CompanyDetailsScreen(),      
    ),
    GoRoute(
      path: '/createAccount',
      builder: (context, state) => CreateAccountScreen(),      
    ),
    
  ],
);