import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// Owns every piece of cart state (which products, how many of each) and
/// notifies listeners whenever it changes. Screens never call setState()
/// for cart data -- they just watch this provider instead.
class CartProvider extends ChangeNotifier {
  // Keyed by product id so the same product is never duplicated as two rows.
  final Map<int, CartItem> _items = {};

  /// Discount kicks in once the subtotal passes this amount (৳).
  static const double discountThreshold = 2000;
  static const double discountRate = 0.10; // 10%

  List<CartItem> get items => _items.values.toList(growable: false);

  bool get isEmpty => _items.isEmpty;

  /// Total number of units in the cart (used for the AppBar badge).
  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.lineTotal);

  bool get isDiscountApplied => subtotal > discountThreshold;

  double get discount => isDiscountApplied ? subtotal * discountRate : 0.0;

  double get total => subtotal - discount;

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void increment(int productId) {
    final item = _items[productId];
    if (item == null) return;
    item.quantity++;
    notifyListeners();
  }

  void decrement(int productId) {
    final item = _items[productId];
    if (item == null) return;
    if (item.quantity <= 1) {
      _items.remove(productId);
    } else {
      item.quantity--;
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
