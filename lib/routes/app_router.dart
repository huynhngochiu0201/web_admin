import 'package:go_router/go_router.dart';

import 'package:web_admin/routes/route_config.dart';

import '../entities/models/sidebar_model.dart';
import '../pages/main_page.dart';

final GoRouter router = GoRouter(
  initialLocation: sidebarItems[0].route,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainPage(child: child);
      },
      routes: [
        for (final route in RouteConfig.routes.entries)
          GoRoute(
            pageBuilder: (context, state) =>
                NoTransitionPage(child: route.value(context)),
            path: route.key,
          ),
      ],
    ),
  ],
);
