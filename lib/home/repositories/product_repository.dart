// lib/home/repositories/product_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get ALL products without filters to avoid index requirements
  Stream<List<Product>> getAllProducts() {
    return _firestore
        .collection('products')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get products by category - FILTER IN DART to avoid Firestore index
  Stream<List<Product>> getProductsByCategory(String category) {
    return getAllProducts().map((allProducts) {
      // Filter by category in Dart
      final filtered = allProducts.where((product) => 
          product.category.toLowerCase() == category.toLowerCase()).toList();
      
      // Sort by createdAt (newest first) in Dart
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return filtered;
    });
  }

  // Get featured products by category - FILTER IN DART
  Stream<List<Product>> getFeaturedProductsByCategory(String category) {
    return getAllProducts().map((allProducts) {
      // Filter by category AND isFeatured in Dart
      final filtered = allProducts.where((product) => 
          product.category.toLowerCase() == category.toLowerCase() &&
          (product.isFeatured == true)).toList();
      
      // Sort by createdAt (newest first) in Dart
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return filtered;
    });
  }

  // Get single product by ID
  Future<Product?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection('products').doc(id).get();
      if (doc.exists) {
        return Product.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting product: $e');
      return null;
    }
  }

  // Search products by name or description
  Stream<List<Product>> searchProducts(String query) {
    return getAllProducts().map((allProducts) {
      final searchQuery = query.toLowerCase();
      return allProducts.where((product) {
        return product.name.toLowerCase().contains(searchQuery) ||
               product.description.toLowerCase().contains(searchQuery) ||
               product.category.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  // Get products sorted by price
  Stream<List<Product>> getProductsByCategorySortedByPrice(String category, {bool ascending = true}) {
    return getProductsByCategory(category).map((products) {
      products.sort((a, b) => ascending 
          ? a.price.compareTo(b.price) 
          : b.price.compareTo(a.price));
      return products;
    });
  }

  // Get top rated products
  Stream<List<Product>> getTopRatedProductsByCategory(String category, {int limit = 10}) {
    return getProductsByCategory(category).map((products) {
      products.sort((a, b) => b.rating!.compareTo(a.rating!));
      return products.take(limit).toList();
    });
  }

  // Get products in stock
  Stream<List<Product>> getInStockProductsByCategory(String category) {
    return getProductsByCategory(category).map((products) {
      return products.where((product) => (product.stockCount ?? 0) > 0).toList();
    });
  }

  // Get product count by category
  Stream<int> getProductCountByCategory(String category) {
    return getProductsByCategory(category).map((products) => products.length);
  }

  // Helper to clear cache (if needed)
  void clearCache() {
    // This is a no-op for Firestore, but can be used if you add caching later
  }
}