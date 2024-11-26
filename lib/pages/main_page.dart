import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_admin/components/sidebar/admin_sidebar.dart';
import 'package:web_admin/entities/models/sidebar_model.dart';

class MainPage extends StatelessWidget {
  final Widget child;

  const MainPage({
    super.key,
    required this.child,
  });

  void _handleNavigation(BuildContext context, int index) {
    context.go(sidebarItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          AdminSidebar(
            onItemClick: (index) => _handleNavigation(context, index),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
