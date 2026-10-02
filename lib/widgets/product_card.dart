import 'package:flutter/material.dart';

import '../models/product.dart';
// import your product.dart here

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAdd;
  final VoidCallback? onTap;
  const ProductCard({super.key, required this.product, this.onAdd, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(22)),
                      child: Hero(
                        tag: 'product_${product.id}',
                        child: _image(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(product.category,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: const Icon(Icons.favorite_border,
                          size: 18, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text('৳${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: onAdd,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.add_shopping_cart_rounded,
                          size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallback() => Container(
    color: Colors.grey.shade100,
    child: Center(
      child: Icon(product.icon, size: 44, color: Colors.grey.shade400),
    ),
  );

  Widget _image() {
    if (product.imageUrl.isEmpty) return _fallback();
    return Image.network(
      product.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(color: Colors.grey.shade200);
      },
      errorBuilder: (context, error, stack) {
        debugPrint('IMAGE ERROR for ${product.name}: $error');
        return _fallback();
      },
    );
  }
}