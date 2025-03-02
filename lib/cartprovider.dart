import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class CartItem {
  final String title;
  final String subtitle;
  final String imageUrl;

  CartItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      title: map['title'],
      subtitle: map['subtitle'],
      imageUrl: map['imageUrl'],
    );
  }
}

class CartStateNotifier extends StateNotifier<List<CartItem>> {
  CartStateNotifier() : super([]);

  final cartBox = Hive.box('cart');

  void addItemToCart(CartItem item) {
    state = [...state, item];
    cartBox.add(item.toMap());
  }

  void removeItemFromCart(String title) {
    state = state.where((item) => item.title != title).toList();
    for (var i = 0; i < cartBox.length; i++) {
      if (cartBox.getAt(i)['title'] == title) {
        cartBox.deleteAt(i);
        break;
      }
    }
  }
}

final cartProvider = StateNotifierProvider<CartStateNotifier, List<CartItem>>(
      (ref) => CartStateNotifier(),
);
