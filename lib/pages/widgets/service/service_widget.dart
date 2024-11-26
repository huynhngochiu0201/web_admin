import 'package:flutter/material.dart';
import 'package:web_admin/pages/widgets/service/widget/area.dart';
import 'package:web_admin/pages/widgets/service/widget/payload.dart';
import 'package:web_admin/pages/widgets/service/widget/wheel_size.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_style.dart';

class ServiceWidget extends StatefulWidget {
  const ServiceWidget({super.key});

  @override
  State<ServiceWidget> createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.Ef5f5f5,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
        ).copyWith(top: 10.0),
        child: Column(
          children: [
            Row(
              children: [Text('Service', style: AppStyle.textHeader)],
            ),
            const SizedBox(height: 10.0),
            Container(
              height: 50.0,
              padding: const EdgeInsets.all(6.0),
              //margin: const EdgeInsets.symmetric(horizontal: 25.0),
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
                  Tab(text: 'Area'),
                  Tab(text: 'Payload'),
                  Tab(text: 'Wheel Size'),
                ],
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
                  children: const [
                    AreaWidget(),
                    PayloadWidget(),
                    WheelSizeWidget()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
