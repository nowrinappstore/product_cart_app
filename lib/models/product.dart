import 'package:flutter/material.dart';

/// A single product in the local catalog.
///
/// This app has no backend, so every product lives in a plain Dart list
/// (see [productCatalog] below) instead of coming from an API or database.
class Product {
  final int id;
  final String name;
  final double price;
  final IconData icon;
  final String category;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
    required this.category,
    required this.imageUrl,
  });
}

/// Local, hard-coded product catalog (no backend / Firebase / API / DB).
final List<Product> productCatalog = [
  Product(
    id: 1,
    name: 'Wireless Headphones',
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/nowrin-store-1.firebasestorage.app/o/products%2Fmosur%20dal.jpeg?alt=media&token=871f5c83-c96c-4e82-86e9-3b63d5ab4160',
    price: 1850,
    icon: Icons.headphones_rounded,
    category: 'Electronics',
  ),
  Product(
    id: 2,
    name: 'Smart Watch',
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/nowrin-store-1.firebasestorage.app/o/products%2Fmosur%20dal.jpeg?alt=media&token=871f5c83-c96c-4e82-86e9-3b63d5ab4160',
    price: 3200,
    icon: Icons.watch_rounded,
    category: 'Electronics',
  ),
 /* Product(
    id: 3,
    name: 'Cotton T-Shirt',
    price: 650,
    icon: Icons.checkroom_rounded,
    category: 'Fashion',
  ),
  Product(
    id: 4,
    name: 'Running Shoes',
    price: 2400,
    icon: Icons.directions_run_rounded,
    category: 'Fashion',
  ),
  Product(
    id: 5,
    name: 'Coffee Mug',
    price: 320,
    icon: Icons.coffee_rounded,
    category: 'Home',
  ),
  Product(
    id: 6,
    name: 'Table Lamp',
    price: 980,
    icon: Icons.light_rounded,
    category: 'Home',
  ),
  Product(
    id: 7,
    name: 'Backpack',
    price: 1450,
    icon: Icons.backpack_rounded,
    category: 'Fashion',
  ),
  Product(
    id: 8,
    name: 'Bluetooth Speaker',
    price: 1999,
    icon: Icons.speaker_rounded,
    category: 'Electronics',
  ),*/
];

/// All distinct categories in the catalog, plus a leading "All" filter option.
List<String> get productCategories {
  final set = <String>{'All'};
  for (final p in productCatalog) {
    set.add(p.category);
  }
  return set.toList();
}
