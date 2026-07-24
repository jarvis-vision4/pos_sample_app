import 'package:intl/intl.dart';
class PriceFormat {
  static String format(double price) {
    final NumberFormat formatter = NumberFormat('#,##0', 'en_US');
    return '${formatter.format(price)} Ks';
  }

}