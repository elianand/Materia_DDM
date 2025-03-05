import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/providers.dart'; // Si usas go_router

class LogoutScreen extends ConsumerStatefulWidget {
  const LogoutScreen({super.key});
 

  @override
  LogoutScreenState createState() => LogoutScreenState();
}

class LogoutScreenState extends ConsumerState<LogoutScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_)  {
      
      ref.read(logoutProvider.notifier).initLogout();
      ref.read(logoutProvider.notifier).logout();

    });
  }


  @override
  Widget build(BuildContext context) {

    final provider = ref.watch(logoutProvider);
    if(provider.logoutDone) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.replace('/login');
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
        centerTitle: true,
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}