import 'dart:convert';

import 'package:http/http.dart' as http;

import 'core/config.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    title: json['title'],
    price: (json['price'] as num).toDouble(),
    thumbnail: json['thumbnail'],
  );
}

class ProductApiImpl {
  Future<List<Product>> getProducts() async {
    final res = await http.get(Uri.parse('${AppConfig.baseUrl}/products'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      List<Product> list = [];
      for (var item in data['products']) {
        list.add(Product.fromJson(item));
      }
      return list;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> addToCart(int productId) async {
    final res = await http.post(
      Uri.parse('${AppConfig.baseUrl}/cart/items'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'product_id': productId}),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to add to cart');
    }
  }

  Future<void> removeFromCart(int productId) async {
    final res = await http.delete(
      Uri.parse('${AppConfig.baseUrl}/cart/items/$productId'),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to remove from cart');
    }
  }

  Future<Map<String, dynamic>> getCart() async {
    final res = await http.get(Uri.parse('${AppConfig.baseUrl}/cart'));
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('Failed to load cart');
    }
  }
}
