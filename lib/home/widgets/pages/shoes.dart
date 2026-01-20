

import 'package:flutter/material.dart';
import '../category_pages.dart';

class ShoesPage extends StatelessWidget {
  const ShoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryPage(
      categoryName: 'Shoes',
      iconPath: 'svg/shoe.svg',
      categoryColor: const Color(0xFF96CEB4),
    );
  }
}