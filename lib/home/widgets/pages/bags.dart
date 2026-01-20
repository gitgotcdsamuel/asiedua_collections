

import 'package:flutter/material.dart';
import '../category_pages.dart';

class BagsPage extends StatelessWidget {
  const BagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryPage(
      categoryName: 'Bags',
      iconPath: 'svg/bag.svg',
      categoryColor: const Color(0xFFFFD166),
    );
  }
}