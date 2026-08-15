import 'package:flutter/material.dart';
import 'package:pos_sample_app/data/models/order.dart';
import 'package:pos_sample_app/theme/app_theme.dart';
import 'package:pos_sample_app/utils/price_format.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.orderNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Completed',
                    style: TextStyle(color: AppTheme.successColor, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                Icon(Icons.person_outline, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items: ${order.totalQuantity}', style: TextStyle(color: Colors.grey[600])),
                Text(
                  PriceFormat.format(order.totalAmount),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.accentColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
