import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/cart_item.dart';
import '../../../../data/models/customer.dart';
import '../../../../data/models/order.dart';
import '../../../../data/models/product.dart';
import '../../../../data/services/database_service.dart';
import '../../../../locator/locator.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final DatabaseService _databaseService=getIt.get<DatabaseService>();
  CartCubit() : super(const CartState());

  void addToCart(Product product) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      final updatedCart = List<CartItem>.of(state.items);
      final cartItem = updatedCart[existingIndex];
      updatedCart[existingIndex] = cartItem.copyWith(
        quantity: cartItem.quantity + 1,
      );
      emit(state.copyWith(items: updatedCart));
    } else {
      emit(
        state.copyWith(
          items: [
            ...state.items,
            CartItem(product: product),
          ],
        ),
      );
    }
  }

  void removeFromCart(int productId) {
    final updatedCart = state.items
        .where((item) => item.product.id != productId)
        .toList();
    emit(state.copyWith(items: updatedCart));
  }

  void increaseQuantity(int productId) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == productId,
    );
    if (existingIndex >= 0) {
      final updatedCart = List<CartItem>.from(state.items);
      final cartItem = updatedCart[existingIndex];
      updatedCart[existingIndex] = cartItem.copyWith(
        quantity: cartItem.quantity + 1,
      );
      emit(state.copyWith(items: updatedCart));
    }
  }

  void decreaseQuantity(int productId) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == productId,
    );
    if (existingIndex >= 0) {
      final updatedCart = List<CartItem>.from(state.items);
      final cartItem = updatedCart[existingIndex];
      final currentQty = cartItem.quantity;
      if (currentQty > 1) {
        updatedCart[existingIndex] = cartItem.copyWith(
          quantity: currentQty - 1,
        );
        emit(state.copyWith(items: updatedCart));
      } else {
        removeFromCart(productId);
      }
    }
  }

  void removeItem(int productId) {
    final updatedItems = state.items
        .where((item) => item.product.id != productId)
        .toList();
    emit(state.copyWith(items: updatedItems));
  }

  void setCustomer(Customer customer) {
    emit(state.copyWith(selectedCustomer: customer));
  }

  void checkout(Customer customer) {
    if (state.canCheckOut) {
      emit(state.copyWith(isCheckingOut: true, checkoutSuccess: true,selectedCustomer: customer));
      final orderItems = state.items.map((cartItem) {
        return OrderItem(
          productId: cartItem.product.id,
          productName: cartItem.product.title,
          productImage: cartItem.product.image,
          unitPrice: cartItem.product.price.toDouble(),
          quantity: cartItem.quantity,
          subtotal: cartItem.subtotal.toDouble(),
        );
      }).toList();
      for (var item in orderItems) {
        print(item.productName);
      }
      final now = DateTime.now();
      final dateInt = now.year * 10000 + now.month * 100 + now.day;
      final order = Order(
        orderNumber:dateInt,
        customerId: state.selectedCustomer!.id,
        customerName: state.selectedCustomer!.name,
        orderDate: DateTime.now(),
        totalQuantity: state.totalQuantity,
        totalAmount: state.totalAmount,
        items: orderItems,
      );
      print(order.customerName);
    }
    emit(
      state.copyWith(
        isCheckingOut: false,
        items: [],
      ),
    );
  }
  void resetCheckout(){
    emit(state.copyWith(checkoutSuccess: false,selectedCustomer:null));
  }
}
