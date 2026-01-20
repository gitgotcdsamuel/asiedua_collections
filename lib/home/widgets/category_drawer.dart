import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryDrawer extends StatelessWidget {
  final void Function(String) onCategorySelected;

  const CategoryDrawer({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final categories = [
      
      {'title': 'Jeans', 'icon': Icons.roller_skating, 'color': Colors.indigo},
      {'title': 'Shoes', 'icon': Icons.shopping_bag_outlined, 'color': Colors.amber},
      {'title': 'Bags', 'icon': Icons.work_outline, 'color': Colors.brown},
      {'title': 'Accessories', 'icon': Icons.diamond_outlined, 'color': Colors.purple},
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFE6E6),
                  Color(0xFFF2F0FF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 40,
                    color: Color(0xFF8A2BE2),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Categories',
                  style: GoogleFonts.raleway(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Asiedua\'s Collection',
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          
          // Categories List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 0.5,
                color: Colors.black12,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: (category['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      color: category['color'] as Color,
                    ),
                  ),
                  title: Text(
                    category['title'] as String,
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.black54,
                  ),
                  onTap: () {
                    onCategorySelected(category['title'] as String);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Exclusive Collection',
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '© 2024 Asiedua\'s Collection',
                  style: GoogleFonts.raleway(
                    fontSize: 12,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}