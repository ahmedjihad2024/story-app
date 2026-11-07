import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final IconData icon;

  const CategoryModel({
    required this.name,
    required this.icon,
  });
}

class ProductItemModel {
  final String id;
  final String brand;
  final String title;
  final double price;
  final double? oldPrice;
  final int? discountPercent;
  final double rating;
  final String? imageUrl;
  final bool isFavorite;

  const ProductItemModel({
    required this.id,
    required this.brand,
    required this.title,
    required this.price,
    this.oldPrice,
    this.discountPercent,
    required this.rating,
    this.imageUrl,
    this.isFavorite = false,
  });
}

