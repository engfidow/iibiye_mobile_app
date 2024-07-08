import 'package:flutter/material.dart';
import 'package:flash_retail/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts(List<String> uids) async {
    _isLoading = true;
    notifyListeners();

    final url =
        Uri.parse('https://retailflash.up.railway.app/api/products/info/uids');

    try {
      final response = await http.get(
        url.replace(queryParameters: {'uids': uids.join(',')}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> productsJson = jsonDecode(response.body);
        _products = productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
