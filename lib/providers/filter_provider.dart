import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// Bonus feature: holds the search text and selected category, and exposes
/// the already-filtered product list. Kept separate from CartProvider since
/// it's a different concern (browsing) from cart state (purchasing).
class FilterProvider extends ChangeNotifier {
  String _query = '';
  String _category = 'All';

  String get query => _query;
  String get category => _category;

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    return productCatalog.where((p) {
      final matchesCategory = _category == 'All' || p.category == _category;
      final matchesQuery =
          _query.trim().isEmpty ||
          p.name.toLowerCase().contains(_query.trim().toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }
}
