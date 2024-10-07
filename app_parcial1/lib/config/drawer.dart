import 'package:flutter/material.dart';


class MenuItem {
  final String title;
  final IconData icon;
  final String link;

  const MenuItem({
    required this.title,
    required this.icon,
    required this.link,
  });
}


const List<MenuItem> menuItems = [
  MenuItem(
      title: 'Remote device configuration',
      icon: Icons.settings_remote,
      link: '/deviceConfig'),
    MenuItem(
      title: 'Configuration',
      icon: Icons.settings,
      link: '/appConfig'),
  MenuItem(
      title: 'User data',
      icon: Icons.manage_accounts,
      link: '/userDetail'),
  MenuItem(
      title: 'Logout',
      icon: Icons.logout,
      link: '/logout'),
  
];
