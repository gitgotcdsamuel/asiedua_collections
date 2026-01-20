import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:openfashion/widget/product_card.dart';


class CategoryPage extends StatefulWidget {
  final String? category;

  const CategoryPage({super.key, this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String _selectedCategory = 'All';
  String _selectedSort = 'Popular';
  String _selectedFilter = 'All';
  bool _showFilters = false;
  double _priceRange = 500.0;
  
  final List<String> _sortOptions = [
    'Popular',
    'Newest',
    'Price: Low to High',
    'Price: High to Low',
    'Rating: High to Low'
  ];
  
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Iconsax.category, 'count': 42},
  
    {'name': 'Bags', 'icon': Iconsax.bag_2, 'count': 8},
    {'name': 'Accessories', 'icon': Iconsax.diamonds, 'count': 16},
  ];

  final List<Map<String, dynamic>> _filterOptions = [
    {'name': 'All', 'color': Colors.black},
    {'name': 'New Arrivals', 'color': Color(0xFFFF6B6B)},
    {'name': 'Best Sellers', 'color': Color(0xFF4ECDC4)},
    {'name': 'On Sale', 'color': Color(0xFFFFD166)},
    {'name': 'Sustainable', 'color': Color(0xFF06D6A0)},
  ];

  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'title': 'Silk Evening Gown',
      'price': '299.99',
      'originalPrice': '399.99',
      'image': 'assets/product1.png',
      'category': 'Dresses',
      'rating': 4.8,
      'reviews': 42,
      'isNew': true,
      'isFavorite': false,
      'isSustainable': true,
      'tags': ['Evening', 'Formal', 'Luxury']
    },
    {
      'id': '2',
      'title': 'Cashmere Blazer',
      'price': '189.99',
      'originalPrice': '229.99',
      'image': 'assets/product2.png',
      'category': 'Tops',
      'rating': 4.6,
      'reviews': 28,
      'isNew': false,
      'isFavorite': true,
      'isSustainable': true,
      'tags': ['Office', 'Formal', 'Premium']
    },
    {
      'id': '3',
      'title': 'Leather Tote Bag',
      'price': '159.99',
      'image': 'assets/product3.png',
      'category': 'Bags',
      'rating': 4.9,
      'reviews': 56,
      'isNew': true,
      'isFavorite': false,
      'isSustainable': false,
      'tags': ['Everyday', 'Leather', 'Spacious']
    },
    {
      'id': '4',
      'title': 'Linen Summer Dress',
      'price': '129.99',
      'originalPrice': '159.99',
      'image': 'assets/product4.png',
      'category': 'Dresses',
      'rating': 4.7,
      'reviews': 34,
      'isNew': false,
      'isFavorite': true,
      'isSustainable': true,
      'tags': ['Casual', 'Summer', 'Breathable']
    },
    {
      'id': '5',
      'title': 'Designer Heels',
      'price': '229.99',
      'image': 'assets/product1.png',
      'category': 'Shoes',
      'rating': 4.5,
      'reviews': 19,
      'isNew': true,
      'isFavorite': false,
      'isSustainable': false,
      'tags': ['Heels', 'Evening', 'Designer']
    },
    {
      'id': '6',
      'title': 'Gold Pendant Necklace',
      'price': '89.99',
      'image': 'assets/product2.png',
      'category': 'Accessories',
      'rating': 4.8,
      'reviews': 47,
      'isNew': false,
      'isFavorite': true,
      'isSustainable': true,
      'tags': ['Gold', 'Minimalist', 'Everyday']
    },
    {
      'id': '7',
      'title': 'Denim Jacket',
      'price': '149.99',
      'originalPrice': '199.99',
      'image': 'assets/product3.png',
      'category': 'Tops',
      'rating': 4.4,
      'reviews': 22,
      'isNew': true,
      'isFavorite': false,
      'isSustainable': false,
      'tags': ['Denim', 'Casual', 'Versatile']
    },
    {
      'id': '8',
      'title': 'Crossbody Phone Bag',
      'price': '79.99',
      'image': 'assets/product4.png',
      'category': 'Bags',
      'rating': 4.6,
      'reviews': 31,
      'isNew': false,
      'isFavorite': false,
      'isSustainable': true,
      'tags': ['Small', 'Phone', 'Crossbody']
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.category != null && widget.category != 'All') {
      _selectedCategory = widget.category!;
    }
  }

  List<Map<String, dynamic>> get _filteredProducts {
    List<Map<String, dynamic>> filtered = _products;
    
    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((product) => product['category'] == _selectedCategory).toList();
    }
    
    // Filter by filter option
    if (_selectedFilter == 'New Arrivals') {
      filtered = filtered.where((product) => product['isNew'] == true).toList();
    } else if (_selectedFilter == 'Best Sellers') {
      filtered = filtered.where((product) => (product['reviews'] as int) > 30).toList();
    } else if (_selectedFilter == 'On Sale') {
      filtered = filtered.where((product) => product['originalPrice'] != null).toList();
    } else if (_selectedFilter == 'Sustainable') {
      filtered = filtered.where((product) => product['isSustainable'] == true).toList();
    }
    
    // Filter by price
    filtered = filtered.where((product) {
      final price = double.parse(product['price'] as String);
      return price <= _priceRange;
    }).toList();
    
    // Sort products
    switch (_selectedSort) {
      case 'Newest':
        filtered.sort((a, b) => (b['isNew'] == true ? 1 : 0).compareTo(a['isNew'] == true ? 1 : 0));
        break;
      case 'Price: Low to High':
        filtered.sort((a, b) {
          final priceA = double.parse(a['price'] as String);
          final priceB = double.parse(b['price'] as String);
          return priceA.compareTo(priceB);
        });
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) {
          final priceA = double.parse(a['price'] as String);
          final priceB = double.parse(b['price'] as String);
          return priceB.compareTo(priceA);
        });
        break;
      case 'Rating: High to Low':
        filtered.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
        break;
      default: // Popular
        filtered.sort((a, b) => (b['reviews'] as int).compareTo(a['reviews'] as int));
    }
    
    return filtered;
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Sort By',
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              ..._sortOptions.map((option) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option,
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: _selectedSort == option 
                          ? FontWeight.w700 
                          : FontWeight.w500,
                      color: _selectedSort == option ? Colors.black : Colors.black54,
                    ),
                  ),
                  trailing: _selectedSort == option
                      ? const Icon(Iconsax.tick_circle, color: Color(0xFF4ECDC4), size: 24)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedSort = option;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  void _toggleFavorite(int index) {
    final product = _filteredProducts[index];
    final productId = product['id'] as String;
    final productIndex = _products.indexWhere((p) => p['id'] == productId);
    
    if (productIndex != -1) {
      setState(() {
        _products[productIndex]['isFavorite'] = !_products[productIndex]['isFavorite'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            floating: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFF9F3),
                      Color(0xFFFFF1E6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 100, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedCategory == 'All' ? 'All Collections' : _selectedCategory,
                        style: GoogleFonts.raleway(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedCategory == 'All' 
                            ? 'Discover our complete collection of premium fashion'
                            : 'Curated selection of premium ${_selectedCategory.toLowerCase()}',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Iconsax.arrow_left_2,
                color: Colors.black,
                size: 24,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _showSortBottomSheet(),
                icon: const Icon(
                  Iconsax.sort,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
                icon: Icon(
                  _showFilters ? Iconsax.filter_remove : Iconsax.filter,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ],
          ),

          // Filter Options (Conditional)
          if (_showFilters)
            SliverToBoxAdapter(
              child: _buildFilterSection(),
            ),

          // Categories Horizontal Scroll
          SliverToBoxAdapter(
            child: _buildCategoriesSection(),
          ),

          // Products Count and Sort Info
          SliverToBoxAdapter(
            child: _buildProductsInfoSection(),
          ),

          // Products Grid
          if (_filteredProducts.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
             // sliver: SliverGrid(
             //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
             ///     crossAxisCount: 2,
             //     mainAxisSpacing: 16,
              //    crossAxisSpacing: 16,
              //    childAspectRatio: 0.65,
                ),
                //delegate: SliverChildBuilderDelegate(
                //  (context, index) {
               //     final product = _filteredProducts[index];
               //     return ProductCard(
               //       imagePath: product['image'],
                //      title: product['title'],
               //       price: product['price'],
               //       id: product['id'],
                //      isNew: product['isNew'],
               //       isFavorite: product['isFavorite'],
               //       onFavoriteToggle: () => _toggleFavorite(index),
               //     );
               //   },
               //   childCount: _filteredProducts.length,
            //    ),
            //  ),
          //  )
          //else
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.box_search,
                      size: 64,
                      color: Color(0xFFE0E0E0),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No products found',
                      style: GoogleFonts.raleway(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try adjusting your filters',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.black38,
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

  Widget _buildFilterSection() {
    return Container(
      color: const Color(0xFFFAFAFA),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: GoogleFonts.raleway(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          
          // Filter Options
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _filterOptions.map((filter) {
              final isSelected = _selectedFilter == filter['name'];
              return ChoiceChip(
                label: Text(
                  filter['name'],
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                selected: isSelected,
                selectedColor: filter['color'] as Color,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? filter['color'] as Color : Colors.black12,
                    width: 1,
                  ),
                ),
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = selected ? filter['name'] as String : 'All';
                  });
                },
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Price Range
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price Range',
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '\$0 - \$${_priceRange.toInt()}',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF6B6B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                  thumbColor: Colors.white,
                  activeTrackColor: Color(0xFFFF6B6B),
                  inactiveTrackColor: Colors.black12,
                ),
                child: Slider(
                  value: _priceRange,
                  min: 50,
                  max: 1000,
                  divisions: 19,
                  onChanged: (value) {
                    setState(() {
                      _priceRange = value;
                    });
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Clear Filters Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'All';
                  _priceRange = 500.0;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'CLEAR FILTERS',
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category['name'];
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['name'] as String;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFFFF6B6B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Color(0xFFFF6B6B) : Colors.black12,
                        width: 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Color(0xFFFF6B6B).withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ] : null,
                    ),
                    child: Icon(
                      category['icon'] as IconData?,
                      color: isSelected ? Colors.white : Colors.black54,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category['name'] as String,
                  style: GoogleFonts.raleway(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Color(0xFFFF6B6B) : Colors.black54,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${_filteredProducts.length} ',
                  style: GoogleFonts.raleway(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: 'items',
                  style: GoogleFonts.raleway(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _showSortBottomSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Iconsax.sort,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedSort,
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
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
}