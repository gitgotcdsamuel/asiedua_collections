// lib/home/widgets/pages/tops.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:openfashion/home/models/product.dart';
import 'package:openfashion/home/repositories/product_repository.dart';

class TopsPage extends StatefulWidget {
  const TopsPage({super.key});

  @override
  State<TopsPage> createState() => _TopsPageState();
}

class _TopsPageState extends State<TopsPage> {
  final ProductRepository _productRepository = ProductRepository();
  final String _categoryName = 'Tops';
  
  String _sortBy = 'newest';
  bool _inStockOnly = false;
  String _selectedFilter = 'all';
  String _selectedSize = 'all';
  List<String> _selectedMaterials = [];

  // Enhanced filter categories for tops
  final Map<String, String> _filterOptions = {
    'all': 'All',
    'tshirt': 'T-Shirts',
    'blouse': 'Blouses',
    'shirt': 'Shirts',
    'sweater': 'Sweaters',
    'hoodie': 'Hoodies',
    'tank': 'Tank Tops',
    'crop': 'Crop Tops',
    'formal': 'Formal',
  };

  final List<String> _sizeOptions = ['XS', 'S', 'M', 'L', 'XL'];
  final Map<String, String> _materialOptions = {
    'cotton': 'Cotton',
    'linen': 'Linen',
    'silk': 'Silk',
    'wool': 'Wool',
    'polyester': 'Polyester',
    'denim': 'Denim',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF45B7D1).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, 
              size: 18, 
              color: Color(0xFF45B7D1)
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _categoryName,
          style: GoogleFonts.raleway(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Stack(
              children: [
                IconButton(
                  icon: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF45B7D1), Color(0xFF6CD1E3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF45B7D1).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.filter_list_rounded, 
                      color: Colors.white, 
                      size: 22
                    ),
                  ),
                  onPressed: () => _showEnhancedFilterBottomSheet(context),
                ),
                if (_hasActiveFilters())
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  bool _hasActiveFilters() {
    return _inStockOnly || 
           _selectedFilter != 'all' || 
           _selectedSize != 'all' || 
           _selectedMaterials.isNotEmpty;
  }

  Widget _buildBody() {
    return StreamBuilder<List<Product>>(
      stream: _productRepository.getProductsByCategory(_categoryName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        final allProducts = snapshot.data!;
        final filteredProducts = _applyFilters(allProducts);
        final sortedProducts = _applySorting(filteredProducts);

        return _buildProductGrid(sortedProducts, allProducts.length);
      },
    );
  }

  List<Product> _applyFilters(List<Product> products) {
    var filtered = products;

    // Stock filter
    if (_inStockOnly) {
      filtered = filtered.where((p) => (p.stockCount ?? 0) > 0).toList();
    }

    // Category filter
    if (_selectedFilter != 'all') {
      filtered = filtered.where((p) {
        final name = p.name.toLowerCase();
        final desc = p.description.toLowerCase();
        final category = p.category.toLowerCase();
        final filter = _selectedFilter.toLowerCase();
        return name.contains(filter) || 
               desc.contains(filter) || 
               category.contains(filter);
      }).toList();
    }

    // Size filter (assuming size is stored in product tags or description)
    if (_selectedSize != 'all') {
      filtered = filtered.where((p) {
        final desc = p.description.toLowerCase();
        final name = p.name.toLowerCase();
        return desc.contains(_selectedSize.toLowerCase()) || 
               name.contains(_selectedSize.toLowerCase());
      }).toList();
    }

    // Material filter
    if (_selectedMaterials.isNotEmpty) {
      filtered = filtered.where((p) {
        final desc = p.description.toLowerCase();
        return _selectedMaterials.any((material) => desc.contains(material));
      }).toList();
    }

    return filtered;
  }

  List<Product> _applySorting(List<Product> products) {
    switch (_sortBy) {
      case 'price_low':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        products.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case 'popular':
        products.sort((a, b) => (b.stockCount ?? 0).compareTo(a.stockCount ?? 0));
        break;
      case 'newest':
      default:
        products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
    return products;
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCategoryBanner(null),
          const SizedBox(height: 20),
          _buildFilterChips(null),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.68,
              ),
              itemCount: 6,
              itemBuilder: (context, index) => _buildProductShimmer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCategoryBanner(0),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF45B7D1).withOpacity(0.05),
                    const Color(0xFF6CD1E3).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF45B7D1).withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF45B7D1).withOpacity(0.1),
                          const Color(0xFF6CD1E3).withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      size: 40,
                      color: Color(0xFF45B7D1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connection Error',
                    style: GoogleFonts.raleway(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unable to load tops collection',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF45B7D1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      elevation: 0,
                      shadowColor: const Color(0xFF45B7D1).withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.refresh_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Retry Connection',
                          style: GoogleFonts.raleway(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCategoryBanner(0),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade50,
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF45B7D1).withOpacity(0.1),
                          const Color(0xFF6CD1E3).withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/svg/shirt.svg',
                        height: 48,
                        width: 48,
                        color: const Color(0xFF45B7D1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Tops Found',
                    style: GoogleFonts.raleway(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try adjusting your filters or check back later\nfor new arrivals',
                    style: GoogleFonts.raleway(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  if (_hasActiveFilters())
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _inStockOnly = false;
                          _selectedFilter = 'all';
                          _selectedSize = 'all';
                          _selectedMaterials.clear();
                          _sortBy = 'newest';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF45B7D1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Color(0xFF45B7D1),
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        elevation: 0,
                        shadowColor: const Color(0xFF45B7D1).withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.clear_all_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Clear All Filters',
                            style: GoogleFonts.raleway(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products, int totalCount) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildCategoryBanner(totalCount),
          const SizedBox(height: 16),
          _buildFilterChips(totalCount),
          const SizedBox(height: 8),
          if (_hasActiveFilters())
            _buildActiveFiltersIndicator(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72, // Slightly taller for tops
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(product);
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF45B7D1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF45B7D1).withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF45B7D1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.filter_alt_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Active Filters',
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF45B7D1),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _inStockOnly = false;
                _selectedFilter = 'all';
                _selectedSize = 'all';
                _selectedMaterials.clear();
              });
            },
            child: Text(
              'Clear All',
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBanner(int? totalCount) {
    final count = totalCount ?? 0;
    
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF45B7D1),
            const Color(0xFF6CD1E3),
            const Color(0xFF8BDCE9),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF45B7D1).withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Abstract pattern
          Positioned(
            right: -30,
            top: -30,
            child: Opacity(
              opacity: 0.1,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 15,
                  ),
                ),
              ),
            ),
          ),
          
          // Small circles
          Positioned(
            left: 30,
            bottom: 30,
            child: Opacity(
              opacity: 0.1,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 5,
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/shirt.svg',
                      height: 26,
                      width: 26,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'TOP',
                        style: GoogleFonts.raleway(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                          height: 1.0,
                        ),
                      ),
                      TextSpan(
                        text: 'S',
                        style: GoogleFonts.raleway(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                          height: 1.0,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Elevate your style with premium tops',
                  style: GoogleFonts.raleway(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.95),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.inventory_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$count styles',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.eco_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Sustainable',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_shipping_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Free Shipping',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(int? totalCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              if (totalCount != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF45B7D1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF45B7D1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$totalCount items',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF45B7D1),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filterOptions.length,
              itemBuilder: (context, index) {
                final key = _filterOptions.keys.elementAt(index);
                final label = _filterOptions[key]!;
                final isSelected = _selectedFilter == key;
                
                return Container(
                  margin: EdgeInsets.only(
                    right: index == _filterOptions.length - 1 ? 0 : 8,
                    bottom: 4,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedFilter = key;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: isSelected 
                              ? const LinearGradient(
                                  colors: [Color(0xFF45B7D1), Color(0xFF6CD1E3)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: isSelected ? null : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected 
                                ? Colors.transparent 
                                : Colors.grey.shade300,
                            width: 1,
                          ),
                          boxShadow: isSelected 
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF45B7D1).withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          label,
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            fontWeight: isSelected 
                                ? FontWeight.w700 
                                : FontWeight.w500,
                            color: isSelected 
                                ? Colors.white 
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final isNew = DateTime.now().difference(product.createdAt).inDays < 7;
    final isLowStock = (product.stockCount ?? 0) <= 5 && (product.stockCount ?? 0) > 0;
    final isOutOfStock = (product.stockCount ?? 0) == 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Handle product tap
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -5,
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    height: 170,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF45B7D1).withOpacity(0.05),
                          const Color(0xFF6CD1E3).withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade100,
                                child: Center(
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/svg/shirt.svg',
                                      height: 20,
                                      width: 20,
                                      color: const Color(0xFF45B7D1).withOpacity(0.3),
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade100,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/svg/shirt.svg',
                                          height: 20,
                                          width: 20,
                                          color: const Color(0xFF45B7D1),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Top',
                                        style: GoogleFonts.raleway(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF45B7D1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // New badge
                        if (isNew)
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.red, Colors.orange],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                'NEW',
                                style: GoogleFonts.raleway(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ),
                        
                        // Favorite button
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.favorite_border_rounded,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Product Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      style: GoogleFonts.raleway(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        height: 1.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        size: 14,
                                        color: Color(0xFFFFD166),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        product.rating?.toStringAsFixed(1) ?? '4.5',
                                        style: GoogleFonts.raleway(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.category,
                                style: GoogleFonts.raleway(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF45B7D1),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),

                          // Description
                          Text(
                            product.description,
                            style: GoogleFonts.raleway(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Price and Stock
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'GHS ${product.price.toStringAsFixed(0)}',
                                        style: GoogleFonts.raleway(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      if (product.price > 100)
                                        Text(
                                          'Premium Quality',
                                          style: GoogleFonts.raleway(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF45B7D1),
                                          ),
                                        ),
                                    ],
                                  ),
                                  
                                  // Stock indicator
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isOutOfStock
                                          ? Colors.red.shade50
                                          : isLowStock
                                              ? Colors.orange.shade50
                                              : Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: isOutOfStock
                                                ? Colors.red
                                                : isLowStock
                                                    ? Colors.orange
                                                    : Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          isOutOfStock
                                              ? 'Out of Stock'
                                              : '${product.stockCount} left',
                                          style: GoogleFonts.raleway(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: isOutOfStock
                                                ? Colors.red.shade700
                                                : isLowStock
                                                    ? Colors.orange.shade700
                                                    : Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Quick add to cart
              if (!isOutOfStock)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF45B7D1), Color(0xFF6CD1E3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF45B7D1).withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductShimmer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: -3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 20,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEnhancedFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Filter & Sort',
                    style: GoogleFonts.raleway(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Refine your tops collection',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Sort Section
                  _buildFilterSection(
                    title: 'SORT BY',
                    child: Column(
                      children: [
                        _buildEnhancedSortOption(
                          'newest',
                          'Newest Arrivals',
                          Icons.new_releases_rounded,
                          Icons.bolt_rounded,
                          setState,
                        ),
                        _buildEnhancedSortOption(
                          'price_low',
                          'Price: Low to High',
                          Icons.arrow_upward_rounded,
                          Icons.attach_money_rounded,
                          setState,
                        ),
                        _buildEnhancedSortOption(
                          'price_high',
                          'Price: High to Low',
                          Icons.arrow_downward_rounded,
                          Icons.money_off_rounded,
                          setState,
                        ),
                        _buildEnhancedSortOption(
                          'rating',
                          'Highest Rated',
                          Icons.star_rate_rounded,
                          Icons.thumb_up_rounded,
                          setState,
                        ),
                        _buildEnhancedSortOption(
                          'popular',
                          'Most Popular',
                          Icons.trending_up_rounded,
                          Icons.local_fire_department_rounded,
                          setState,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Size Filter
                  _buildFilterSection(
                    title: 'SIZE',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sizeOptions.map((size) {
                        final isSelected = _selectedSize == size;
                        return ChoiceChip(
                          label: Text(size),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedSize = selected ? size : 'all';
                            });
                          },
                          backgroundColor: Colors.grey.shade50,
                          selectedColor: const Color(0xFF45B7D1),
                          labelStyle: GoogleFonts.raleway(
                            fontSize: 14,
                            fontWeight: isSelected 
                                ? FontWeight.w700 
                                : FontWeight.w500,
                            color: isSelected 
                                ? Colors.white 
                                : Colors.grey.shade700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected 
                                  ? const Color(0xFF45B7D1) 
                                  : Colors.grey.shade300,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Material Filter
                  _buildFilterSection(
                    title: 'MATERIAL',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _materialOptions.entries.map((entry) {
                        final key = entry.key;
                        final label = entry.value;
                        final isSelected = _selectedMaterials.contains(key);
                        return FilterChip(
                          label: Text(label),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedMaterials.add(key);
                              } else {
                                _selectedMaterials.remove(key);
                              }
                            });
                          },
                          backgroundColor: Colors.grey.shade50,
                          selectedColor: const Color(0xFF45B7D1),
                          checkmarkColor: Colors.white,
                          labelStyle: GoogleFonts.raleway(
                            fontSize: 13,
                            fontWeight: isSelected 
                                ? FontWeight.w700 
                                : FontWeight.w500,
                            color: isSelected 
                                ? Colors.white 
                                : Colors.grey.shade700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected 
                                  ? const Color(0xFF45B7D1) 
                                  : Colors.grey.shade300,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Stock Filter
                  _buildFilterSection(
                    title: 'AVAILABILITY',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => _inStockOnly = !_inStockOnly),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _inStockOnly 
                                ? const Color(0xFF45B7D1).withOpacity(0.1) 
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _inStockOnly 
                                  ? const Color(0xFF45B7D1) 
                                  : Colors.grey.shade300,
                              width: _inStockOnly ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _inStockOnly 
                                    ? Icons.check_circle_rounded 
                                    : Icons.circle_outlined,
                                color: _inStockOnly 
                                    ? const Color(0xFF45B7D1) 
                                    : Colors.grey.shade600,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'In Stock Only',
                                  style: GoogleFonts.raleway(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _inStockOnly 
                                        ? const Color(0xFF45B7D1) 
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              Text(
                                _inStockOnly ? 'ON' : 'OFF',
                                style: GoogleFonts.raleway(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _inStockOnly 
                                      ? const Color(0xFF45B7D1) 
                                      : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _sortBy = 'newest';
                              _inStockOnly = false;
                              _selectedFilter = 'all';
                              _selectedSize = 'all';
                              _selectedMaterials.clear();
                            });
                            Navigator.pop(context);
                            setState(() {});
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.refresh_rounded, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Reset All',
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF45B7D1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            shadowColor: const Color(0xFF45B7D1).withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_rounded, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Apply Filters',
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.raleway(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF45B7D1),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildEnhancedSortOption(
    String value,
    String label,
    IconData primaryIcon,
    IconData secondaryIcon,
    StateSetter setState,
  ) {
    final isSelected = _sortBy == value;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _sortBy = value),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFF45B7D1).withOpacity(0.1) 
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                    ? const Color(0xFF45B7D1) 
                    : Colors.grey.shade200,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF45B7D1), Color(0xFF6CD1E3)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [
                              Colors.grey.shade200,
                              Colors.grey.shade300,
                            ],
                          ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    primaryIcon,
                    size: 20,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.black : Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            secondaryIcon,
                            size: 14,
                            color: isSelected 
                                ? const Color(0xFF45B7D1) 
                                : Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getSortDescription(value),
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: isSelected 
                                  ? const Color(0xFF45B7D1) 
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF45B7D1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getSortDescription(String value) {
    switch (value) {
      case 'newest':
        return 'Latest arrivals first';
      case 'price_low':
        return 'From lowest price';
      case 'price_high':
        return 'From highest price';
      case 'rating':
        return 'Top rated products';
      case 'popular':
        return 'Most purchased items';
      default:
        return '';
    }
  }
}