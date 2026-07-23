import 'package:flutter/material.dart';

import '../presentation/screens/cart/cart_screen.dart';
import '../presentation/screens/customer_selection/customer_selection_screen.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/screens/order_list/order_list_screen.dart';
import '../presentation/screens/pos/pos_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case AppRoutes.pos:
        return MaterialPageRoute(builder: (_) => const PosScreen());

      case AppRoutes.customerSelection:
        return MaterialPageRoute(builder: (_) => const CustomerSelectionScreen());

      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case AppRoutes.orders:
        return MaterialPageRoute(
          builder: (_) => const OrderListScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page Not Found'))),
        );
    }
  }
}
