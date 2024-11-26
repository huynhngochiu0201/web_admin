import 'package:flutter/material.dart';

import 'package:web_admin/routes/route_names.dart';

import '../pages/widgets/service/service_widget.dart';
import '../pages/widgets/home/home_widget.dart';
import '../pages/widgets/product/product_widget.dart';
import '../pages/widgets/order/order_widget.dart';
import '../pages/widgets/category/category_widget.dart';

class RouteConfig {
  static final Map<String, Widget Function(BuildContext)> routes = {
    RouteNames.home: (context) => const HomeWidget(),
    RouteNames.order: (context) => const OrderWidget(),
    RouteNames.category: (context) => const CategoryWidget(),
    RouteNames.product: (context) => const ProductWidget(
          
        ),
    RouteNames.service: (context) => const ServiceWidget(),
  };
}
