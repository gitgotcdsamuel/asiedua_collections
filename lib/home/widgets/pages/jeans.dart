
import 'package:flutter/material.dart';
import '../category_pages.dart';

class JeansPage extends StatelessWidget {
  const JeansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryPage(
      categoryName: 'Jeans',
      iconPath: 'svg/jeans.svg',
      categoryColor: const Color(0xFF45B7D1),
    );
  }
}