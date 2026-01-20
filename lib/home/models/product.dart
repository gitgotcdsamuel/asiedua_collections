// lib/home/models/product.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? isFeatured;
  final double? rating;
  final int? stockCount;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    this.isFeatured = false,
    this.rating = 0.0,
    this.stockCount = 0,
  });

  factory Product.fromFirestore(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isFeatured: data['isFeatured'] ?? false,
      rating: (data['rating'] ?? 0).toDouble(),
      stockCount: data['stockCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isFeatured': isFeatured,
      'rating': rating,
      'stockCount': stockCount,
    };
  }
}