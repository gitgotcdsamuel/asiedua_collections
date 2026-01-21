// lib/home/screens/home_screen.dart (updated)
import 'package:flutter/material.dart';
import 'package:openfashion/home/widgets/category_drawer.dart';
import 'package:openfashion/home/widgets/category_slider_widget.dart';

import 'package:openfashion/home/widgets/custom_app_bar.dart';
import 'package:openfashion/home/widgets/hero_section.dart';
import 'package:openfashion/home/widgets/newsletter_section.dart';
import 'package:openfashion/home/widgets/new_arrivals.dart'; // Add this import

import 'package:openfashion/home/widgets/category_pages.dart';
import 'package:openfashion/home/widgets/pages/accessories.dart';
import 'package:openfashion/home/widgets/pages/bags.dart';
import 'package:openfashion/home/widgets/pages/dress.dart';
import 'package:openfashion/home/widgets/pages/jeans.dart';
import 'package:openfashion/home/widgets/pages/shoes.dart';
import 'package:openfashion/home/widgets/pages/tops.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onCategorySelected(String category) {
    switch (category) {
      case 'Dresses':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DressesPage()),
        );
        break;
      case 'Tops':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TopsPage()),
        );
        break;
      case 'Jeans':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JeansPage()),
        );
        break;
      case 'Shoes':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShoesPage()),
        );
        break;
      case 'Bags':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BagsPage()),
        );
        break;
      case 'Accessories':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccessoriesPage()),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(
              categoryName: category,
              iconPath: 'svg/dress.svg',
              categoryColor: Colors.black,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: CategoryDrawer(
        onCategorySelected: _onCategorySelected,
      ),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            pinned: true,
            snap: false,
            expandedHeight: 60,
            collapsedHeight: 60,
            flexibleSpace: CustomAppBar(
              onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              onSearchPressed: () {},
              onCartPressed: () {},
            ),
          ),

          // Hero Section
          const SliverToBoxAdapter(
            child: HeroSection(),
          ),

          // Compact Category Slider
          SliverToBoxAdapter(
            child: CompactCategorySlider(
              onCategoryTap: _onCategorySelected,
            ),
          ),

          // New Arrivals Section
          SliverToBoxAdapter(
            child: NewArrivals(
              onCategorySelected: _onCategorySelected, onProductTap: (String productId, Map<String, dynamic> product) {  }, // Pass the same function
            ),
          ),

          // Newsletter
          const SliverToBoxAdapter(
            child: NewsletterSection(),
          ),

          // Footer
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF1A1A1A),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'ASIEDUA\'S Gallery',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Elevating everyday style with sustainable luxury',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white30),
                  const SizedBox(height: 20),
                  Text(
                    '© 2024 Asiedua\'s Collection. All rights reserved.',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white54,
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