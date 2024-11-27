import 'package:flutter/material.dart';
import 'package:web_admin/pages/widgets/order/widget/all_page.dart';
import 'package:web_admin/pages/widgets/order/widget/canceled_page.dart';
import 'package:web_admin/pages/widgets/order/widget/delivered_page.dart';
import 'package:web_admin/pages/widgets/order/widget/pending_page.dart';
import 'package:web_admin/pages/widgets/order/widget/to_ship_page.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Theme(
              data: Theme.of(context).copyWith(
                tabBarTheme: TabBarTheme(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ),
              child: TabBar(
                controller: tabController,
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                padding: EdgeInsets.zero, // Loại bỏ padding mặc định
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                      width: 2.0, color: Colors.blue), // Tùy chỉnh chỉ báo
                ),
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'To Ship'),
                  Tab(text: 'Pending'),
                  Tab(text: 'Delivered'),
                  Tab(text: 'Canceled'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    AllPage(),
                    ToShipPage(),
                    PendingPage(),
                    DeliveredPage(),
                    CanceledPage(),
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
