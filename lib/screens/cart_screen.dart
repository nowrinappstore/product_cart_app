
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) => IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: 'Clear cart',
              onPressed: cart.isEmpty
                  ? null
                  : () => _confirmClear(context),
            ),
          ),
        ],
      ),
      // context.watch() -- this whole body should rebuild whenever the cart
      // changes, so we watch it once at the top instead of wrapping every
      // little piece in its own Consumer.
      body: Builder(
        builder: (context) {
          final cart = context.watch<CartProvider>();

          if (cart.isEmpty) {
            return _EmptyCart();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) => _CartTile(item: cart.items[i]),
                ),
              ),
              _CartSummary(cart: cart),
            ],
          );
        },
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('This removes every item from your cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<CartProvider>().clearCart();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItem item;
  const _CartTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.product.icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('৳${item.product.price.toStringAsFixed(0)} each',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _QtyButton(
                        icon: Icons.remove_rounded,
                        onTap: () => cart.decrement(item.product.id),
                      ),
                      SizedBox(
                        width: 32,
                        child: Text(
                          '${item.quantity}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.add_rounded,
                        onTap: () => cart.increment(item.product.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '৳${item.lineTotal.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  tooltip: 'Remove',
                  onPressed: () => cart.removeItem(item.product.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final CartProvider cart;
  const _CartSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SummaryRow(label: 'Total items', value: '${cart.totalItems}'),
          _SummaryRow(
              label: 'Subtotal', value: '৳${cart.subtotal.toStringAsFixed(0)}'),
          _SummaryRow(
            label: cart.isDiscountApplied
                ? 'Discount (10%)'
                : 'Discount (10% over ৳2000)',
            value: cart.isDiscountApplied
                ? '- ৳${cart.discount.toStringAsFixed(0)}'
                : '৳0',
            highlight: cart.isDiscountApplied,
          ),
          const Divider(height: 20),
          _SummaryRow(
            label: 'Final total',
            value: '৳${cart.total.toStringAsFixed(0)}',
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool highlight;
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.w500,
      fontSize: bold ? 18 : 14,
      color: highlight ? Theme.of(context).colorScheme.primary : null,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.remove_shopping_cart_rounded,
                size: 75, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Add a few products to see them here.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.storefront_rounded),
              label: const Text('Back to products'),
            ),
          ],
        ),
      ),
    );
  }
}
