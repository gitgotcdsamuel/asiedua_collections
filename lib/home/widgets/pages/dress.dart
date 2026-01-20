

import 'package:flutter/material.dart';
import '../category_pages.dart';

class DressesPage extends StatelessWidget {
  const DressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryPage(
      categoryName: 'Dresses',
      iconPath: 'svg/dress.svg',
      categoryColor: const Color(0xFFFF6B8B),
    );
  }
}
