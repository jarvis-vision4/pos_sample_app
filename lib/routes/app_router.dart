import 'package:flutter/material.dart';

import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case AppRoutes.dashboard:
      //   return MaterialPageRoute(
      //     builder: (_) => const DashboardScreen(),
      //   );
      //
      // case AppRoutes.pos:
      //   return MaterialPageRoute(
      //     builder: (_) => const PosScreen(),
      //   );
      //
      // case AppRoutes.customerSelection:
      //   return MaterialPageRoute(
      //     builder: (_) => const CustomerSelectionScreen(),
      //   );
      //
      // case AppRoutes.cart:
      //   return MaterialPageRoute(
      //     builder: (_) => const CartScreen(),
      //   );
      //
      // case AppRoutes.orders:
      //   return MaterialPageRoute(
      //     builder: (_) => const OrderListScreen(),
      //   );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page Not Found')),
          ),
        );
    }
  }
}