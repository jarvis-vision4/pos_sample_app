import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_sample_app/presentation/screens/cart/cubit/cart_state.dart';

import '../../../../data/models/cart_item.dart';
import '../../../../data/models/customer.dart';
import '../../../../data/models/product.dart';

class CartCubit extends Cubit<CartState>{
  CartCubit(): super(const CartState());

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


}