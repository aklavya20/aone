import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'cartprovider.dart';

class ShoppingCart extends StatelessWidget {
  final cartBox = Hive.box('cart');

  ShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: ValueListenableBuilder(
        valueListenable: cartBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }
          final cartItems = box.values.cast<Map>().toList();
          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final itemMap = cartItems[index].cast<String, dynamic>();
              final item = CartItem.fromMap(itemMap);
              return ListTile(
                title: Text(item.title),
                subtitle: Text(item.subtitle),
                leading: ClipOval(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(item.imageUrl),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    cartBox.deleteAt(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item removed from cart')),
                    );
                  },
                  icon: const Icon(Icons.remove),
                ),
              );
            },
          );
        },
      ),
    );
  }
}