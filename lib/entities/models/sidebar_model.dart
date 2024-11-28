import 'package:flutter/material.dart';
import 'package:web_admin/routes/route_names.dart';

class SidebarModel {
  final String title;
  final IconData icon;
  final String route;

  SidebarModel({
    required this.title,
    required this.icon,
    required this.route,
  });
}

List<SidebarModel> sidebarItems = [
  SidebarModel(title: 'Home', icon: Icons.home, route: RouteNames.home),
  SidebarModel(title: 'Order', icon: Icons.person, route: RouteNames.order),
  SidebarModel(
      title: 'Category', icon: Icons.settings, route: RouteNames.category),
  SidebarModel(
      title: 'Product', icon: Icons.message, route: RouteNames.product),
  SidebarModel(
      title: 'Service', icon: Icons.analytics, route: RouteNames.service),
  SidebarModel(
      title: 'setting', icon: Icons.analytics, route: RouteNames.setting),
];
