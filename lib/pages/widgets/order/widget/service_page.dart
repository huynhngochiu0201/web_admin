import 'package:flutter/material.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_style.dart';

import '../../service/replace_tire_page.dart';
import '../../service/rescue_page.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          const SizedBox(height: 10.0),
          Theme(
            data: Theme.of(context).copyWith(
              tabBarTheme: TabBarTheme(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ),
            child: Container(
              height: 50.0,
              padding: const EdgeInsets.all(6.0),
              margin: const EdgeInsets.symmetric(horizontal: 25.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.0),
                color: Colors.transparent,
              ),
              child: TabBar(
                unselectedLabelStyle: AppStyle.regular_12,
                dividerColor: Colors.transparent,
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.0),
                    color: AppColor.E43484B),
                labelColor: Colors.white,
                tabs: [
                  Tab(text: 'Rescue'),
                  Tab(text: 'Replace Tire'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TabBarView(
                controller: tabController,
                children: [
                  RescuePage(),
                  ReplaceTirePage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
