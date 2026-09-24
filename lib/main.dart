import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/filter_provider.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(const ProductCartApp());
}

class ProductCartApp extends StatelessWidget {
  const ProductCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
      ],
      child: MaterialApp(
        title: 'Product Cart App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE0073A)),
          useMaterial3: true,
        ),
        home: const ProductListScreen(),
      ),
    );
  }
}
