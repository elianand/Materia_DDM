import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/general_provider.dart'; // Si usas go_router

class LogoutScreen extends ConsumerStatefulWidget {
  const LogoutScreen({super.key});
 

  @override
  LogoutScreenState createState() => LogoutScreenState();
}

class LogoutScreenState extends ConsumerState<LogoutScreen> {

  @override
  void initState() {
    super.initState();
    _logout();
  }

  Future<void> _logout() async {
    
    await ref.read(userDataProvider.notifier).logout();

    if (mounted) {
      context.replace('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
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