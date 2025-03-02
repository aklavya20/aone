import 'package:aone/addproduct.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  late Future<List<Product>> productsFuture;

  Future<List<Product>> fetchProducts() async {
    final pb = PocketBase('https://desktop-og46q9s.tail7d5586.ts.net');
    final records = await pb.collection('product').getFullList();
    return records.map((record) => Product.fromMap(record.toJson())).toList();
  }

  @override
  void initState() {
    super.initState();
    productsFuture = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Products List"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AddProduct()));
                },
                icon: const Icon(Icons.home)),
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
        body: FutureBuilder<List<Product>>(
          future: productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products available'));
            } else {
              List<Product> products = snapshot.data!;

              return TabBarView(children: [
                buildProductTab(products, 'Combo'),
                buildProductTab(products, 'Fast Food'),
                buildProductTab(products, 'Meal'),
                buildProductTab(products, 'Beverages'),
              ]);
            }
          },
        ),
      ),
    );
  }

  Widget buildProductTab(List<Product> products, String category) {
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
        );
      },
    );
  }
}

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