import '../../../../data/models/cart_item.dart';
import '../../../../data/models/customer.dart';

class CartState {
  final List<CartItem> items;
  final Customer? selectedCustomer;
  final bool isCheckingOut;
  final bool checkoutSuccess;
  const CartState({
    this.items = const [],
    this.selectedCustomer,
    this.isCheckingOut = false,
    this.checkoutSuccess = false
  });

  CartState copyWith({
    List<CartItem>? items,
    Customer? selectedCustomer,
    bool? isCheckingOut,
    bool? checkoutSuccess
  }) {
    return CartState(
        items: items ?? this.items,
        selectedCustomer: selectedCustomer,
        isCheckingOut: isCheckingOut ?? this.isCheckingOut,
        checkoutSuccess: checkoutSuccess ?? this.checkoutSuccess
    );
  }

  int get totalQuantity => items.fold(0, (int sum, CartItem item) => sum + item.quantity);


  double get totalAmount => items.fold(0.0, (double sum, CartItem item) => sum + item.subtotal);


  bool get canCheckOut => selectedCustomer != null && items.isNotEmpty;


}
