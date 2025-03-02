import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod package
import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';
import 'cartprovider.dart';
import 'fetchproductprovider.dart';
import 'shopping.dart';
import 'login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope( // Wrap with ProviderScope
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Aone(),
      ),
    );
  }
}

class Aone extends ConsumerStatefulWidget {
  const Aone({super.key});

  @override
  _AoneState createState() => _AoneState();
}

class _AoneState extends ConsumerState<Aone> {
  @override
  void initState() {
    super.initState();
    // Fetch products when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Aone",
            style: TextStyle(
              fontFamily: "Georgia",
              fontStyle: FontStyle.italic,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShoppingCart(),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_bag),
            ),
            IconButton(
              onPressed: () async {
                final box = Hive.box('authBox');
                await box.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            labelStyle: TextStyle(
              fontFamily: 'Sans-Serif',
              fontSize: 11,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 9,
            ),
            tabs: [
              Tab(icon: Icon(Icons.food_bank), text: "Combo"),
              Tab(icon: Icon(Icons.fastfood), text: "Fast food"),
              Tab(icon: Icon(Icons.dining), text: "Meal"),
              Tab(icon: Icon(Icons.emoji_food_beverage), text: "Beverages"),
            ],
          ),
        ),
        body: products.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            buildProductTab(products, 'Combo', ref),
            buildProductTab(products, 'Fast Food', ref),
            buildProductTab(products, 'Meal', ref),
            buildProductTab(products, 'Beverages', ref),
          ],
        ),
      ),
    );
  }

  Widget buildProductTab(List<Product> products, String category, WidgetRef ref) {
    final filteredProducts = products.where((product) => product.category == category).toList();
    final pb = PocketBase('https://desktop-og46q9s.tail7d5586.ts.net');
    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        final imageUrl = '${pb.baseUrl}/api/files/product/${product.id}/${product.image}';
        return ListTile(
          title: Text(product.name),
          subtitle: Text('\$${product.price}'),
          leading: ClipOval(
            child: CircleAvatar(
              child: Image.network(imageUrl),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              ref.read(cartProvider.notifier).addItemToCart(CartItem(
                title: product.name,
                subtitle: '\$${product.price}',
                imageUrl: imageUrl,
              ));

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item added to cart')));
            },
            icon: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}