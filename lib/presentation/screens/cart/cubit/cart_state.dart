import '../../../../data/models/cart_item.dart';
import '../../../../data/models/customer.dart';

class CartState {
  final List<CartItem> items;
  final Customer? selectedCustomer;
  final bool isCheckingOut;

  const CartState({
    this.items = const [],
    this.selectedCustomer,
    this.isCheckingOut = false
  });

  CartState copyWith({List<CartItem>? items, Customer? selectedCustomer}) {
    return CartState(items: items ?? this.items,
        selectedCustomer: selectedCustomer ?? this.selectedCustomer);
  }

  int get totalQuantity {
    return items.fold(0, (int sum, CartItem item) => sum + item.quantity);
  }

  double get totalAmount {
    return items.fold(0.0, (double sum, CartItem item) => sum + item.subtotal);
  }

  bool get canCheckOut {
    return selectedCustomer != null && items.isNotEmpty;
  }

}
