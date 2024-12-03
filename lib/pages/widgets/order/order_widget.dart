import 'package:flutter/material.dart';
import 'package:web_admin/constants/app_style.dart';
import 'package:web_admin/pages/widgets/home/widget/all_page.dart';
import 'package:web_admin/pages/widgets/order/widget/canceled_page.dart';
import 'package:web_admin/pages/widgets/order/widget/delivered_page.dart';
import 'package:web_admin/pages/widgets/order/widget/pending_page.dart';
import 'package:web_admin/pages/widgets/order/widget/service_page.dart';
import '../../../constants/columndata.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  // ValueNotifier để theo dõi tab hiện tại
  final ValueNotifier<int> _currentTabNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);

    // Lắng nghe sự thay đổi của tabController
    tabController.addListener(() {
      _currentTabNotifier.value = tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    _currentTabNotifier.dispose();
    super.dispose();
  }

  List<ColumnData> get columns => const [
        ColumnData(title: 'Order ID', width: 100),
        ColumnData(title: 'Name', width: 100),
        ColumnData(title: 'Items', width: 45),
        ColumnData(title: 'Order Status', width: 90),
      ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manage Order', style: AppStyle.textHeader),
            const SizedBox(height: 20),
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
                child: Column(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        tabBarTheme: TabBarTheme(
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                      ),
                      child: TabBar(
                        controller: tabController,
                        isScrollable: true,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        padding: EdgeInsets.zero, // Loại bỏ padding mặc định
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(
                              width: 2.0,
                              color: Colors.blue), // Tùy chỉnh chỉ báo
                        ),
                        tabs: const [
                          // Tab(text: 'All'),
                          Tab(text: 'Service'),
                          Tab(text: 'Pending'),
                          Tab(text: 'Delivered'),
                          Tab(text: 'Canceled'),
                        ],
                      ),
                    ),
                    // Hiển thị TableHeader dựa trên tab hiện tại
                    ValueListenableBuilder<int>(
                      valueListenable: _currentTabNotifier,
                      builder: (context, currentTabIndex, child) {
                        // Chỉ hiển thị header nếu không phải tab All hoặc Service
                        if (currentTabIndex == 0 || currentTabIndex == 1) {
                          return const SizedBox.shrink();
                        }
                        return Container();
                      },
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: const [
                          // AllPage(),
                          ServicePage(),
                          PendingPage(),
                          DeliveredPage(),
                          CanceledPage(),
                        ],
                      ),
                    ),
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
