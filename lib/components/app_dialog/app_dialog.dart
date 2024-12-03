import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../button/cr_elevated_button.dart';

class AppDialog {
  AppDialog._();

  static void dialog(
    BuildContext context, {
    required String title,
    required String content,
    Function()? action,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColor.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CrElevatedButton.smallOutline(
                      onPressed: () => Navigator.pop(context),
                      text: 'No',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CrElevatedButton.smallOutline(
                      onPressed: () {
                        action?.call();
                        Navigator.pop(context);
                      },
                      text: 'Yes',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
