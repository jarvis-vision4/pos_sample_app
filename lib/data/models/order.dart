class Order {
  final int? id;
  final int orderNumber;
  final int customerId;
  final String customerName;
  final DateTime orderDate;
  final int totalQuantity;
  final double totalAmount;
  final List<OrderItem> items;

  Order({
    this.id,
    required this.orderNumber,
    required this.customerId,
    required this.customerName,
    required this.orderDate,
    required this.totalQuantity,
    required this.totalAmount,
    this.items = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'order_number': orderNumber,
      'customer_id': customerId,
      'customer_name': customerName,
      'order_date': orderDate.toIso8601String(),
      'total_quantity': totalQuantity,
      'total_amount': totalAmount,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, {List<OrderItem>? items}) {
    return Order(
      id: map['id'] as int?,
      orderNumber: map['order_number'] as int,
      customerId: map['customer_id'] as int,
      customerName: map['customer_name'] as String,
      orderDate: DateTime.parse(map['order_date'] as String),
      totalQuantity: map['total_quantity'] as int,
      totalAmount: (map['total_amount'] as num).toDouble(),
      items: items ?? [],
    );
  }

  Order copyWith({
    int? id,
    int? orderNumber,
    int? customerId,
    String? customerName,
    DateTime? orderDate,
    int? totalQuantity,
    double? totalAmount,
    List<OrderItem>? items,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      orderDate: orderDate ?? this.orderDate,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      totalAmount: totalAmount ?? this.totalAmount,
      items: items ?? this.items,
    );
  }
}

class OrderItem {
  final int? id;
  final int? orderId;
  final int productId;
  final String productName;
  final String productImage;
  final double unitPrice;
  final int quantity;
  final double subtotal;

  OrderItem({
    this.id,
    this.orderId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'unit_price': unitPrice,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] as int?,
      orderId: map['order_id'] as int?,
      productId: map['product_id'] as int,
      productName: map['product_name'] as String,
      productImage: map['product_image'] as String,
      unitPrice: (map['unit_price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      subtotal: (map['subtotal'] as num).toDouble(),
    );
  }

  OrderItem copyWith({
    int? id,
    int? orderId,
    int? productId,
    String? productName,
    String? productImage,
    double? unitPrice,
    int? quantity,
    double? subtotal,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}
