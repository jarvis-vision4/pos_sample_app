import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/order.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'pos_sample_app_db';
  static const int _dbVersion = 1;

  final String tableOrders = 'orders';
  final String tableOrderItems = 'order_items';

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_number INTEGER NOT NULL,
        customer_id INTEGER NOT NULL,
        customer_name TEXT NOT NULL,
        order_date TEXT NOT NULL,
        total_quantity INTEGER NOT NULL,
        total_amount REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        product_name TEXT NOT NULL,
        product_image TEXT NOT NULL,
        unit_price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        subtotal REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertOrder(Order order) async {
    final db = await database;
    final orderId = await db.insert(tableOrders, order.toMap());

    for (final item in order.items) {
      await db.insert(tableOrderItems, item.copyWith(orderId: orderId).toMap());
    }

    return orderId;
  }

  Future<List<Order>> getAllOrders() async {
    final db = await database;
    final orderMaps = await db.query(tableOrders, orderBy: 'id DESC');
    final orders = <Order>[];

    for (final orderMap in orderMaps) {
      final itemMaps = await db.query(
        tableOrderItems,
        where: 'order_id = ?',
        whereArgs: [orderMap['id']],
      );
      final items = itemMaps.map((m) => OrderItem.fromMap(m)).toList();
      orders.add(Order.fromMap(orderMap, items: items));
    }

    return orders;
  }

  Future<double> getTotalSales() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(total_amount) as total FROM $tableOrders');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<int> getOrderCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $tableOrders');
    return (result.first['count'] as int?) ?? 0;
  }
}
