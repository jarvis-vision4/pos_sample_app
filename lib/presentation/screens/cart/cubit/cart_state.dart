import '../../../../data/models/cart_item.dart';
import '../../../../data/models/customer.dart';

class CartState {
  final List<CartItem> items;
  final Customer? selectedCustomer;

  const CartState({this.items = const [], this.selectedCustomer});

  CartState copyWith({List<CartItem>? items, Customer? selectedCustomer}) {
    return CartState(items: items ?? this.items,selectedCustomer: selectedCustomer ?? this.selectedCustomer);
  }

  int get totalQuantity =>
      items.fold(0, (int sum, CartItem item) => sum + item.quantity);
}
