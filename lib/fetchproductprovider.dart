import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

class Product {
  final String id;
  final String name;
  final int price;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['Name'],
      price: map['Price'],
      category: map['Category'],
      image: map['Images'],
    );
  }
}

class ProductStateNotifier extends StateNotifier<List<Product>> {
  ProductStateNotifier() : super([]);
  Future<void> fetchProducts() async {
    final pb = PocketBase('https://desktop-og46q9s.tail7d5586.ts.net');
    final records = await pb.collection('product').getFullList();
    state = records.map((record) => Product.fromMap(record.toJson())).toList();
  }
}

final productProvider = StateNotifierProvider<ProductStateNotifier, List<Product>>(
      (ref) => ProductStateNotifier(),
);
