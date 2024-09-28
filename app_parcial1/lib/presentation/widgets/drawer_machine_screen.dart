import 'package:app_parcial1/config/drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class DrawerMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scafoldKey;
  const DrawerMenu({super.key, required this.scafoldKey});

  @override
  State<DrawerMenu> createState() => _DraweMenuState();
}

class _DraweMenuState extends State<DrawerMenu> {
  int selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: selectedScreen,
      onDestinationSelected: (value) {
        setState(() {
          selectedScreen = value;
        });
        context.push(menuItems[value].link);
        widget.scafoldKey.currentState?.closeDrawer();
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 28, 5),
          child: Text('Main', style: Theme.of(context).textTheme.titleMedium),
        ),
        NavigationDrawerDestination(    // Configuracion de dispositivos
              icon: Icon(menuItems[0].icon),
              label: Text(menuItems[0].title),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 10, 28, 5),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 28, 5),
          child: Text('App',
              style: Theme.of(context).textTheme.titleMedium),
        ),
        NavigationDrawerDestination(    // Datos de usuario
              icon: Icon(menuItems[1].icon),
              label: Text(menuItems[1].title),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 10, 28, 5),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 28, 5),
          child: Text('User options',
              style: Theme.of(context).textTheme.titleMedium),
        ),
        NavigationDrawerDestination(    // Datos de usuario
              icon: Icon(menuItems[2].icon),
              label: Text(menuItems[2].title),
        ),
        NavigationDrawerDestination(    // Cerrar sesion
              icon: Icon(menuItems[3].icon),
              label: Text(menuItems[3].title),
        ),
      ],
    );
  }
}
