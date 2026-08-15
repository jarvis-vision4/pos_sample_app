import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/cart_item.dart';
import '../../../../data/models/customer.dart';
import '../../../../data/models/order.dart';
import '../../../../data/models/product.dart';
import '../../../../data/services/database_service.dart';
import '../../../../locator/locator.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final DatabaseService _databaseService = getIt.get<DatabaseService>();

  CartCubit() : super(const CartState());

  void addToCart(Product product) {
    final existingIndex = state.items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      final updated = List<CartItem>.from(state.items);
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + 1,
      );
      emit(state.copyWith(items: updated));
    } else {
      emit(state.copyWith(items: [...state.items, CartItem(product: product)]));
    }
  }

  void removeFromCart(int productId) {
    emit(state.copyWith(items: state.items.where((item) => item.product.id != productId).toList()));
  }

  void increaseQuantity(int productId) {
    final index = state.items.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    final updated = List<CartItem>.from(state.items);
    updated[index] = updated[index].copyWith(quantity: updated[index].quantity + 1);
    emit(state.copyWith(items: updated));
  }

  void decreaseQuantity(int productId) {
    final index = state.items.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    final currentQty = state.items[index].quantity;
    if (currentQty > 1) {
      final updated = List<CartItem>.from(state.items);
      updated[index] = updated[index].copyWith(quantity: currentQty - 1);
      emit(state.copyWith(items: updated));
    } else {
      removeFromCart(productId);
    }
  }

  void setCustomer(Customer customer) {
    emit(state.copyWith(selectedCustomer: customer));
  }

  void clearCart() {
    emit(state.copyWith(items: [], clearCustomer: true));
  }

  Future<void> checkout() async {
    if (!state.canCheckOut) return;

    emit(state.copyWith(isCheckingOut: true));

    final orderItems = state.items.map((item) => OrderItem(
      productId: item.product.id,
      productName: item.product.title,
      productImage: item.product.image,
      unitPrice: item.product.price.toDouble(),
      quantity: item.quantity,
      subtotal: item.subtotal.toDouble(),
    )).toList();

    final now = DateTime.now();
    final order = Order(
      orderNumber: now.year * 10000 + now.month * 100 + now.day,
      customerId: state.selectedCustomer!.id,
      customerName: state.selectedCustomer!.name,
      orderDate: now,
      totalQuantity: state.totalQuantity,
      totalAmount: state.totalAmount,
      items: orderItems,
    );

    await _databaseService.insertOrder(order);

    emit(state.copyWith(isCheckingOut: false, checkoutSuccess: true, items: [], clearCustomer: true));
  }

  void resetCheckout() {
    emit(state.copyWith(checkoutSuccess: false));
  }
}
