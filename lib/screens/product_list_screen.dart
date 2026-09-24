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
      appBar: AppBar(
        title: const Text('Nowrin Store',style: TextStyle(fontSize: 30,color: Colors.red)),
        actions: [
          // Consumer rebuilds just the badge when the cart changes --
          // the rest of this screen doesn't need to know about it.
          Consumer<CartProvider>(
            builder: (context, cart, _) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Badge(
                  label: Text('${cart.totalItems}'),
                  isLabelVisible: cart.totalItems > 0,
                  child: const Icon(Icons.shopping_cart_rounded),
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _SearchAndFilterBar(),
          const Divider(height: 1),
          Expanded(
            child: Consumer<FilterProvider>(
              builder: (context, filter, _) {
                final products = filter.filteredProducts;
                if (products.isEmpty) {
                  return const Center(
                    child: Text('No products match your search.'),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, i) => ProductCard(product: products[i]),
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search products…',
              prefixIcon: Icon(Icons.search_rounded),
              isDense: true,
              border: OutlineInputBorder(),
            ),
            // context.read() -- we're only calling a method, not reading a
            // value during build, so no need to watch here.
            onChanged: (value) => context.read<FilterProvider>().setQuery(value),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 36,
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
