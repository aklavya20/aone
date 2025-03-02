import 'dart:io';
import 'package:aone/viewproduct.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'addpro.dart';
import 'login.dart';
import 'productprovider.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Add(), // Removed const here
      debugShowCheckedModeBanner: false,
    );
  }
}

class Add extends ConsumerStatefulWidget {
  const Add({super.key});

  @override
  ConsumerState<Add> createState() => _AddState();
}

class _AddState extends ConsumerState<Add> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  final AddtheProduct _addtheProduct = AddtheProduct();

  @override
  void initState() {
    super.initState();
    final productState = ref.read(productStateProvider);
    _nameController = TextEditingController(text: productState.name);
    _priceController = TextEditingController(text: productState.price);
    _categoryController = TextEditingController(text: productState.category);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      ref
          .read(productStateProvider.notifier)
          .updateImage(File(pickedFile.path));
    }
  }

  void _addProduct() async {
    final productState = ref.read(productStateProvider);
    try {
      // Call the addProduct method from AddtheProduct
      final response = await _addtheProduct.addProduct(
        productState.name,
        productState.price,
        productState.category,
        productState.image!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product Added: ${response['Name']}')),
      );

      // Reset the form fields
      ref.read(productStateProvider.notifier).resetForm();
      _nameController.clear();
      _priceController.clear();
      _categoryController.clear();

      setState(() {}); // Refresh the UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product was not Added: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productStateProvider);
    final productNotifier = ref.read(productStateProvider.notifier);

    // Update controllers if the state changes externally
    _nameController.text = productState.name;
    _priceController.text = productState.price;
    _categoryController.text = productState.category;

    return Scaffold(
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ViewProduct()),
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
                MaterialPageRoute(builder: (context) => const Admin()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Product Name TextField
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter Product Name',
                  contentPadding: EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                onChanged: (value) => productNotifier.updateName(value),
              ),
              const SizedBox(height: 10),
              // Product Price TextField
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Enter Product Price',
                  contentPadding: EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => productNotifier.updatePrice(value),
              ),
              const SizedBox(height: 10),
              // Product Category TextField
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Enter Product Category',
                  contentPadding: EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                onChanged: (value) => productNotifier.updateCategory(value),
              ),
              const SizedBox(height: 10),
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: productState.image == null
                      ? const Center(child: Text('Tap to select an image'))
                      : Image.file(
                          productState.image!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 24),
              // Add Product Button
              ElevatedButton(
                onPressed: _addProduct,
                child: const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
