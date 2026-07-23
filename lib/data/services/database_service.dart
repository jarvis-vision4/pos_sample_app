import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/order.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'pos_sample_app_db';
  static const int _dbVersion = 1;
  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
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
    final orderId = await db.insert('orders', order.toMap());

    for (final item in order.items) {
      final itemWithOrder = item.copyWith(orderId: orderId);
      await db.insert('order_items', itemWithOrder.toMap());
    }

    return orderId;
  }
}