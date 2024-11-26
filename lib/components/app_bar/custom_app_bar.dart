import 'package:flutter/material.dart';
import '../../constants/app_color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.leftPressed,
      this.rightPressed,
      required this.title,
      this.avatar,
      this.color = AppColor.Ef5f5f5});

  final VoidCallback? leftPressed;
  final VoidCallback? rightPressed;
  final String title;
  final String? avatar;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    Positioned(
                      left: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back,
                            size: 20.0, color: AppColor.brown),
                      ),
                    ),
                  ],
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
