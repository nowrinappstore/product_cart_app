# Product Cart App (Provider)

A Flutter shopping cart demo built entirely with local state and the
`provider` package — no Firebase, REST API, or database.

## Run it

```bash
flutter pub get
flutter run
```

## Project layout

```
lib/
  models/
    product.dart        # Product model + hard-coded catalog of 8 products
    cart_item.dart       # CartItem (product + quantity)
  providers/
    cart_provider.dart   # ChangeNotifier owning all cart state
    filter_provider.dart # ChangeNotifier for search text + category (bonus)
  widgets/
    product_card.dart    # One product tile with an "Add to Cart" button
  screens/
    product_list_screen.dart  # Grid of products, search bar, category chips
    cart_screen.dart          # Cart items, +/− qty, remove, summary, clear
  main.dart               # MultiProvider setup + MaterialApp
```

## How each requirement is met

- **Product list** — `product_list_screen.dart` renders `productCatalog`
  (8 items in `models/product.dart`) as a grid; each `ProductCard` shows
  name, price, an icon, and an *Add to Cart* button.
- **State management** — `CartProvider extends ChangeNotifier` is the only
  source of truth for cart data. Every screen reads it via `Consumer`,
  `context.watch()`, or `context.read()` — `setState()` is never used for
  cart data (it's only used implicitly by stateless widgets, which don't
  use it at all here).
- **Add to cart** — `ProductCard` calls `context.read<CartProvider>().addToCart(product)`.
  The AppBar's `Consumer<CartProvider>` rebuilds the badge automatically.
- **Cart screen** — lists every `CartItem` with name, price, quantity, and
  `+` / `−` / remove controls that call `increment`, `decrement`,
  `removeItem` on the provider.
- **Cart summary** — `_CartSummary` shows total items, subtotal, a 10%
  discount once the subtotal passes ৳2000 (`CartProvider.discount`), and
  the final total.
- **Clear cart** — the delete icon in the cart AppBar confirms, then calls
  `cart.clearCart()`.
- **Empty cart** — `_EmptyCart` shows a message and a button that pops back
  to the product list.
- **Bonus** — `FilterProvider` (a second `ChangeNotifier`) holds the search
  query and selected category; `product_list_screen.dart` watches it to
  filter the grid live.

## Notes

- Prices are in Taka (৳) to match the ৳2000 discount threshold in the brief.
- Product images are Material icons rather than network/asset images, since
  the brief only asks for "Image/icon" and this keeps the project fully
  offline with zero assets to manage.
