
import 'package:flutter/material.dart';
import '../category_pages.dart';

class TopsPage extends StatelessWidget {
  const TopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryPage(
      categoryName: 'Tops',
      iconPath: 'svg/shirt.svg',
      categoryColor: const Color(0xFF4ECDC4),
    );
  }
}