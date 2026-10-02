import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/filter_provider.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text(
          'Nowrin Store',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            letterSpacing: 0.3,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Badge(
                    label: Text('${cart.totalItems}'),
                    isLabelVisible: cart.totalItems > 0,
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const _SearchAndFilterBar(),
          Expanded(
            child: Consumer<FilterProvider>(
              builder: (context, filter, _) {
                final products = filter.filteredProducts;
                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 56, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text('No products match your search.',
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, i) {
                    final product = products[i]; // fixed: was productCatalog[i]
                    return ProductCard(
                      product: product,
                      onAdd: () {
                        // TODO: change `add` to your CartProvider's method name
                        context.read<CartProvider>().addToCart(product);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                              content: Text('${product.name} added to cart'),
                            ),
                          );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndFilterBar extends StatelessWidget {
  const _SearchAndFilterBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search products…',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) =>
                context.read<FilterProvider>().setQuery(value),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: Consumer<FilterProvider>(
              builder: (context, filter, _) => ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: productCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final category = productCategories[i];
                  final selected = filter.category == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedColor: Colors.black87,
                    backgroundColor: Colors.white,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (_) => filter.setCategory(category),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}