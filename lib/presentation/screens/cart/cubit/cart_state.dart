import '../../../../data/models/cart_item.dart';

class CartState {
  final List<CartItem> items;
  const CartState({this.items = const []});
  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
  int get totalQuantity => items.fold(0, (int sum, CartItem item) => sum + item.quantity);
}