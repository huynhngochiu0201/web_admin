import 'package:flutter/material.dart';
import 'package:web_admin/entities/models/sidebar_model.dart';

import '../../constants/app_color.dart';

class AdminSidebar extends StatefulWidget {
  final Function(int) onItemClick;
  const AdminSidebar({
    super.key,
    required this.onItemClick,
  });

  @override
  State<AdminSidebar> createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          _buildSidebarItems(),
        ],
      ),
    );
  }

  Widget _buildSidebarItems() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: sidebarItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, index) => _buildSidebarItem(index),
      ),
    );
  }

  Widget _buildSidebarItem(int index) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => _handleItemClick(index),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.E464447 : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              sidebarItems[index].icon,
              color: isSelected ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 16),
            Text(
              sidebarItems[index].title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleItemClick(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemClick(index);
  }
}
