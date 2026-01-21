// lib/home/widgets/compact_category_slider.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CompactCategorySlider extends StatefulWidget {
  final Function(String) onCategoryTap;
  
  const CompactCategorySlider({
    super.key,
    required this.onCategoryTap,
  });

  @override
  State<CompactCategorySlider> createState() => _CompactCategorySliderState();
}

class _CompactCategorySliderState extends State<CompactCategorySlider> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  double _scrollOffset = 0.0;

  final List<Map<String, dynamic>> _categories = const [
    {
      'name': 'Dresses',
      'icon': 'assets/svg/dress.svg',
      'color': Color(0xFFFF6B8B),
      'accent': Color(0xFFFFF0F3),
      'count': '240+',
      'gradient': [Color(0xFFFF6B8B), Color(0xFFFF8E9E)],
    },
    {
      'name': 'Tops',
      'icon': 'assets/svg/shirt.svg',
      'color': Color(0xFF4ECDC4),
      'accent': Color(0xFFF0FFFD),
      'count': '180+',
      'gradient': [Color(0xFF4ECDC4), Color(0xFF7CE0D8)],
    },
    {
      'name': 'Jeans',
      'icon': 'assets/svg/jeans.svg',
      'color': Color(0xFF45B7D1),
      'accent': Color(0xFFF0FAFF),
      'count': '120+',
      'gradient': [Color(0xFF45B7D1), Color(0xFF6AD1E6)],
    },
    {
      'name': 'Shoes',
      'icon': 'assets/svg/shoe.svg',
      'color': Color(0xFF96CEB4),
      'accent': Color(0xFFF5FFFA),
      'count': '200+',
      'gradient': [Color(0xFF96CEB4), Color(0xFFB4E6C8)],
    },
    {
      'name': 'Bags',
      'icon': 'assets/svg/bag.svg',
      'color': Color(0xFFFFD166),
      'accent': Color(0xFFFFFBF0),
      'count': '150+',
      'gradient': [Color(0xFFFFD166), Color(0xFFFFE08A)],
    },
    {
      'name': 'Accessories',
      'icon': 'assets/svg/accessories.svg',
      'color': Color(0xFF9D8DF1),
      'accent': Color(0xFFF8F7FF),
      'count': '300+',
      'gradient': [Color(0xFF9D8DF1), Color(0xFFB8ADF8)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateCurrentIndex);
  }

  void _updateCurrentIndex() {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 360 ? 88.0 : 100.0;
    const separatorWidth = 16.0;
    const padding = 20.0;
    
    // Calculate visible items per screen
    final itemWidth = cardWidth + separatorWidth;
    final visibleItemsCount = (screenWidth - 2 * padding) / itemWidth;
    
    // Calculate current index based on scroll position
    final offset = _scrollController.offset;
    final newIndex = (offset / itemWidth).round();
    
    // Ensure index is within bounds
    final maxIndex = (_categories.length - visibleItemsCount).ceil();
    final clampedIndex = newIndex.clamp(0, maxIndex);
    
    if (_currentIndex != clampedIndex) {
      setState(() {
        _currentIndex = clampedIndex;
        _scrollOffset = offset;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateCurrentIndex);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate card width based on screen size
    final cardWidth = screenWidth < 360 ? 88.0 : 100.0;
    final iconSize = screenWidth < 360 ? 20.0 : 24.0;
    final containerSize = screenWidth < 360 ? 52.0 : 56.0;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern Header with Apple-style typography
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: GoogleFonts.raleway(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Curated Collections',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${_categories.length}',
                        style: GoogleFonts.raleway(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Responsive Horizontal Category List with proper scrolling
          SizedBox(
            height: 140, // Slightly taller to accommodate shadows
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final category = _categories[index];
                return _CategoryCard(
                  category: category,
                  cardWidth: cardWidth,
                  containerSize: containerSize,
                  iconSize: iconSize,
                  onTap: () => widget.onCategoryTap(category['name']),
                );
              },
            ),
          ),
          
          // Dot Indicator
          const SizedBox(height: 16),
          _buildDotIndicator(screenWidth, cardWidth),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(double screenWidth, double cardWidth) {
    const separatorWidth = 16.0;
    const padding = 20.0;
    final itemWidth = cardWidth + separatorWidth;
    final visibleItemsCount = (screenWidth - 2 * padding) / itemWidth;
    final totalDots = (_categories.length - visibleItemsCount + 1).ceil().clamp(1, _categories.length);
    
    // If all items fit on screen, don't show dots
    if (visibleItemsCount >= _categories.length) {
      return const SizedBox.shrink();
    }
    
    return SizedBox(
      height: 12,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalDots,
          itemBuilder: (context, index) {
            final isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 24.0 : 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: isActive 
                    ? _categories[index.clamp(0, _categories.length - 1)]['color'] as Color
                    : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
                boxShadow: isActive ? [
                  BoxShadow(
                    color: _categories[index.clamp(0, _categories.length - 1)]['color'].withOpacity(0.5) as Color,
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ] : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final Map<String, dynamic> category;
  final double cardWidth;
  final double containerSize;
  final double iconSize;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.cardWidth,
    required this.containerSize,
    required this.iconSize,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: _isPressed ? 0.95 : (_isHovered ? 1.02 : 1.0),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: widget.cardWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: _isPressed
                  ? [
                      BoxShadow(
                        color: (widget.category['color'] as Color).withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                        spreadRadius: -2,
                      ),
                    ]
                  : _isHovered
                      ? [
                          BoxShadow(
                            color: (widget.category['color'] as Color).withOpacity(0.1),
                            blurRadius: 25,
                            offset: const Offset(0, 8),
                            spreadRadius: -5,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                            spreadRadius: -5,
                          ),
                        ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Modern Icon Container with subtle gradient
                Container(
                  width: widget.containerSize,
                  height: widget.containerSize,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.category['gradient'] as List<Color>,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.category['color'] as Color).withOpacity(0.25),
                        blurRadius: _isHovered ? 16 : 12,
                        offset: Offset(0, _isHovered ? 6 : 4),
                        spreadRadius: _isHovered ? -1 : 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      width: widget.iconSize,
                      height: widget.iconSize,
                      child: SvgPicture.asset(
                        widget.category['icon'] as String,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Category Name with precise typography
                Text(
                  widget.category['name'] as String,
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                
                // Item Count with subtle styling
                Text(
                  widget.category['count'] as String,
                  style: GoogleFonts.raleway(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5,
                  ),
                ),
                
                // Subtle animated indicator dot
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isHovered ? 6 : 4,
                  height: _isHovered ? 6 : 4,
                  decoration: BoxDecoration(
                    color: widget.category['color'] as Color,
                    shape: BoxShape.circle,
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: (widget.category['color'] as Color).withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}