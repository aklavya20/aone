import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductState {
  final String name;
  final String price;
  final String category;
  final File? image;

  ProductState({
    this.name = '',
    this.price = '',
    this.category = '',
    this.image,
  });

  ProductState copyWith({
    String? name,
    String? price,
    String? category,
    File? image,
  }) {
    return ProductState(
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      image: image ?? this.image,
    );
  }
}

class ProductStateNotifier extends StateNotifier<ProductState> {
  ProductStateNotifier() : super(ProductState());

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updatePrice(String price) {
    state = state.copyWith(price: price);
  }

  void updateCategory(String category) {
    state = state.copyWith(category: category);
  }

  void updateImage(File? image) {
    state = state.copyWith(image: image);
  }

  void resetForm() {
    state = ProductState();
  }
}

final productStateProvider =
StateNotifierProvider<ProductStateNotifier, ProductState>((ref) {
  return ProductStateNotifier();
});


List<Product> productList = [];

class Product {
  final String name;
  final String price;
  final String category;
  final File? image;

  Product({
    required this.name,
    required this.price,
    required this.category,
    required this.image,
  });
}