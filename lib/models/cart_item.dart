import 'product.dart';

/// A product sitting in the cart, together with how many of it were added.
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get lineTotal => product.price * quantity;
}
