import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:web_admin/constants/double_extension.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_style.dart';
import '../../../entities/models/order_model.dart';
import '../../../services/remote/home_servive.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Future<List<OrderModel>> ordersFuture;
  late Future<double> totalPriceFuture;
  late Future<int> allProductsFuture;
  late Future<int> allServicesFuture;
  late Future<int> allCategoriesFuture;

  final HomeService homeService = HomeService();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      ordersFuture = homeService.getAllOrders();
      totalPriceFuture = homeService.calculateTotalPrice();
      allProductsFuture = homeService.getAllProductsCount();
      allServicesFuture = homeService.getAllServiveCount();
      allCategoriesFuture = homeService.getAllCategoriesCount();
    });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Home', style: AppStyle.textHeader),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<List<OrderModel>>(
                  future: ordersFuture,
                  builder: (context, snapshot) {
                    int orderCount = snapshot.data?.length ?? 0;
                    return _buildCard(
                      icon: Icons.article,
                      title: 'Order',
                      value: orderCount.toString(),
                      color: Colors.white,
                    );
                  },
                ),
                FutureBuilder<int>(
                  future: allServicesFuture,
                  builder: (context, snapshot) {
                    int service = snapshot.data ?? 0;
                    return _buildCard(
                      icon: Icons.list,
                      title: 'Service',
                      value: service.toString(),
                      color: Colors.white,
                    );
                  },
                ),
                FutureBuilder<double>(
                  future: totalPriceFuture,
                  builder: (context, snapshot) {
                    double totalPrice = snapshot.data ?? 0.0;
                    return _buildCard(
                      icon: Icons.attach_money,
                      title: 'Total Sales',
                      value: totalPrice.toVND(),
                      color: Colors.white,
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildPieChart()),
                  SizedBox(width: 20.0),
                  Expanded(
                      child: Column(
                    children: [
                      _buildLegend(),
                      Expanded(child: _buildGroupedBarChart()),
                    ],
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          height: 100,
          width: 300,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
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

  Widget _buildPieChart() {
    return FutureBuilder(
      future: Future.wait([ordersFuture, allServicesFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Lấy giá trị từ FutureBuilder
        final orders =
            (snapshot.data![0] as List<OrderModel>).length.toDouble();
        final services = snapshot.data![1] as int;

        // Biến lưu trạng thái phần đang được chọn
        int? touchedIndex;

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Stack(
                children: [
                  // Hiển thị legend với giá trị orders và services
                  Positioned(
                    top: 10.0,
                    right: 50.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem(
                          color: Colors.blue,
                          label: 'Orders',
                          value: orders, // Giá trị orders
                        ),
                        const SizedBox(height: 10.0),
                        _buildLegendItem(
                          color: Colors.green,
                          label: 'Services',
                          value: services.toDouble(), // Giá trị services
                        ),
                      ],
                    ),
                  ),
                  // Hiển thị PieChart
                  Center(
                    child: SizedBox(
                      width: 400,
                      height: 400,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: orders,
                              title: 'Orders',
                              color: Colors.blue,
                              radius: touchedIndex == 0 ? 110 : 100,
                              titleStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              value: services.toDouble(),
                              title: 'Services',
                              color: Colors.green,
                              radius: touchedIndex == 1 ? 90 : 100,
                              titleStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              if (pieTouchResponse != null &&
                                  pieTouchResponse.touchedSection != null) {
                                setState(() {
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              } else {
                                setState(() {
                                  touchedIndex = null;
                                });
                              }
                            },
                          ),
                          sectionsSpace: 4,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required double value,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 8.0,
        ),
        const SizedBox(width: 10.0),
        Text(
          '$label: ${value.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildGroupedBarChart() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0), color: Colors.white),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          maxY: 500, // Giá trị lớn nhất trên trục Y
          barGroups: [
            // Nhóm 1: Physical
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 512, // Total
                  color: Colors.blue,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: 315, // Used
                  color: Colors.amber,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: 197, // Free
                  color: Colors.red,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
              barsSpace: 8,
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 150, // Total
                  color: Colors.amber,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: 90, // Used
                  color: Colors.red,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: 60, // Free
                  color: Colors.blue,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
              barsSpace: 8,
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 300, // Total
                  color: Colors.blue,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: 200, // Used
                  color: Colors.amber,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: 100, // Free
                  color: Colors.red,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
              barsSpace: 8,
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Physical',
                          style: TextStyle(fontSize: 12));
                    case 1:
                      return const Text('RAM', style: TextStyle(fontSize: 12));
                    case 2:
                      return const Text('Virtual',
                          style: TextStyle(fontSize: 12));
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value % 100 == 0) {
                    return Text('${value.toInt()}');
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade300,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          groupsSpace: 40,
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(right: 20.0, top: 20.0, bottom: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 8.0,
                    ),
                    const SizedBox(width: 8.0),
                    const Text('Delivered'),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 8.0,
                    ),
                    const SizedBox(width: 8.0),
                    const Text('Pending'),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 8.0,
                    ),
                    const SizedBox(width: 8.0),
                    const Text('Canceled'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
