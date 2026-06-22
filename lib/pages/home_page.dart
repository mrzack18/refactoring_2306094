import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';

  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    getUser();
    loadProducts();
  }

  Future<void> loadProducts() async {
    // Simulasi pengambilan data produk dari API atau database
    final prefs = await SharedPreferences.getInstance();
    List<String> productList =
        prefs.getStringList('products') ?? []; // Simulasi delay

    setState(() {
      products = productList
          .map((item) => ProductModel.fromJson(item))
          .toList();
    });
  }

  Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList = products
        .map((product) => product.toJson())
        .toList();
    await prefs.setStringList('products', productList);
  }

  Future<void> addProduct(ProductModel product) async {
    setState(() {
      products.add(product);
    });
    await saveProducts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk berhasil ditambahkan!')),
    );
  }

  Future<void> editProduct(int index, ProductModel product) async {
    setState(() {
      products[index] = product;
    });
    await saveProducts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk berhasil diperbarui!')),
    );
  }

  Future<void> deleteProduct(int index) async {
    setState(() {
      products.removeAt(index);
    });
    await saveProducts();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Produk berhasil dihapus!')));
  }

  void showForm({ProductModel? product, int? index}) {
    TextEditingController nameController = TextEditingController(
      text: product?.name ?? '',
    );
    TextEditingController descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    TextEditingController priceController = TextEditingController(
      text: product != null ? product.price.toString() : '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product == null ? "Tambah Produk" : "Edit Produk"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi Produk'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Harga Produk'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final newProduct = ProductModel(
                name: nameController.text,
                description: descriptionController.text,
                price: double.tryParse(priceController.text) ?? 0.0,
                imageUrl: 'https://picsum.photos/200', // Placeholder image
              );
              if (product == null) {
                addProduct(newProduct);
              } else {
                editProduct(index!, newProduct);
              }
              Navigator.pop(context);
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage('https://picsum.photos/50'),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hai, Selamat Datang!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: logout,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.logout,
                          size: 28,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => showForm(),
                      child: Text("Tambah Produk"),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Expanded(
                child: products.isEmpty
                    ? const Center(child: Text("Belum ada produk"))
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(15),
                              title: Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text("Rp. ${product.price}"),
                                  const SizedBox(height: 5),
                                  Text(product.description),
                                ],
                              ),
                              leading: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () => showForm(
                                  product: products[index],
                                  index: index,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteProduct(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
