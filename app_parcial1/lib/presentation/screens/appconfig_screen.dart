import 'package:app_parcial1/theme/providers/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppconfigScreen extends ConsumerWidget {
  const AppconfigScreen({super.key});
  
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;   

    return Scaffold(
      appBar: AppBar(
        title: const Text('App configuration'),
        /*actions: [
          IconButton(
            onPressed: () {
              ref.read(themeNotifierProvider.notifier).toggleDarkMode();
            },
            icon: isDarkMode
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.light_mode),
          ),
        ],*/
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Enable dark mode'),
            value: isDarkMode,
            onChanged: (value) {
              ref.read(themeNotifierProvider.notifier).toggleDarkMode();
              /*
              setState(() {

                isDeveloper = !isDeveloper;
              });*/
            }
          ),
        ],
      )
    );
    
  }
}
