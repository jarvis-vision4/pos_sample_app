import '../../../../data/models/cart_item.dart';

class CartState {
  final List<CartItem> items;
  const CartState({this.items = const []});
  CartState copyWith({List<CartItem>? cart}) {
    return CartState(items: cart ?? items);
  }
  int get totalQuantity => items.fold(0, (int sum, CartItem item) => sum + item.quantity);
}