import 'package:flutter/material.dart';


class MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String link;

  const MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.link,
  });
}


const List<MenuItem> menuItems = [
  MenuItem(
      title: 'Remote device configuration',
      subtitle: 'Riverpod counter',
      icon: Icons.settings_remote,
      link: '/counter'),
    MenuItem(
      title: 'Configuration',
      subtitle: 'Riverpod counter',
      icon: Icons.settings,
      link: '/appConfig'),
  MenuItem(
      title: 'User data',
      subtitle: 'Different types of buttons',
      icon: Icons.manage_accounts,
      link: '/buttons'),
  MenuItem(
      title: 'Logout',
      subtitle: 'Different types of cards',
      icon: Icons.logout,
      link: '/login'),
  
];
