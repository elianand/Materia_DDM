import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceConfigScreen extends ConsumerStatefulWidget {
  const DeviceConfigScreen({Key? key}) : super(key: key);
 

  @override
  _DeviceConfigScreenState createState() => _DeviceConfigScreenState();
}

class _DeviceConfigScreenState extends ConsumerState<DeviceConfigScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Configuration'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Nothing to show",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}