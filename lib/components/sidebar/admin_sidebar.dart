import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/entities/models/sidebar_model.dart';
import 'package:web_admin/extensions/build_context_extension.dart';
import 'package:web_admin/pages/auth/login_pages.dart';
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
    return Column(
      children: [
        _buildSidebarItems(context),
      ],
    );
  }

  Widget _buildSidebarItems(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: context.responsive ? 70 : 200,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(
          horizontal: context.responsive ? 10 : 16, vertical: 16),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: sidebarItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, index) => _buildSidebarItem(index, context),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPages()),
                );
              },
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index, BuildContext context) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => _handleItemClick(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.symmetric(
            vertical: 10.0, horizontal: context.responsive ? 13 : 16.0),
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
            AnimatedContainer(
                duration: Duration(
                  milliseconds: 500,
                ),
                width: context.responsive ? 0 : 16),
            if (!context.responsive)
              Text(
                sidebarItems[index].title,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
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
