import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.image.isNotEmpty
                ? Image.memory(
                    base64Decode(product.image),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: Icon(Icons.image, size: 250, color: Colors.grey),
                  ),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Rp. ${product.price}",
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 20),
            Text(product.desc, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
