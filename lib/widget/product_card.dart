import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

// lib/widgets/product_card.dart (partial update)
class ProductCard extends StatelessWidget {
  late final String imagePath;
  // ... other properties

  @override
  Widget build(BuildContext context) {
    return Container(
      // ... existing container properties
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Update image widget
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(Icons.broken_image, size: 50),
                  );
                },
              ),
            ),
          ),
          // ... rest of the code
        ],
      ),
    );
  }
}