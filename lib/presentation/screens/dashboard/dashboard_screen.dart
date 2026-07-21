import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard Screen")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.pos);
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.point_of_sale,
                          color: Colors.deepPurpleAccent,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Point of Sale",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Browse products and create orders",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 2,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.orders);
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.deepOrangeAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.point_of_sale,
                          color: Colors.deepOrangeAccent,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order List",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Completed Orders",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
