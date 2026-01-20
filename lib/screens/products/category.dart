import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:openfashion/home/home.dart';
import 'package:openfashion/widget/product_card.dart'; // Assuming you have a separate ProductCard widget
import 'package:openfashion/widget/bottombar.dart'; // Import your BottomNavBar widget
import 'package:openfashion/widget/enum.dart'; // Import the enum for selected tabs

class p_category extends StatefulWidget {
  const p_category({super.key});

  @override
  State<p_category> createState() => _CategoryState();
}

class _CategoryState extends State<p_category> {
  SelectedTab _selectedTab = SelectedTab.category;

  void _handleIndexChanged(int index) {
    setState(() {
      _selectedTab = SelectedTab.values[index];
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _navigateTocat() {
    Navigator.pushReplacementNamed(context, '/menu');
  }

  void _navigateTofav() {
    Navigator.pushReplacementNamed(context, '/fav');
  }
     void _navigateTocart() {
    // If using named routes, replace '/home' with the correct route name.
    Navigator.pushReplacementNamed(context, '/cart');
  }

  void _navigateToaccountinfo() {
    // If using named routes, replace '/home' with the correct route name.
    Navigator.pushReplacementNamed(context, '/account');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Center(
          child: SvgPicture.asset(
            'assets/asiedua.svg', // Replace with your SVG logo path
            height: 40, // Adjust the height to fit your logo
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add the image below the AppBar
              SvgPicture.asset(
                'assets/cat_heading.svg', // Replace with your image path
              ),
              SizedBox(height: 16),
              // Wrap widget to display products
            ]
          ),
        ),
      ),
      // Add the bottom navigation bar back
      bottomNavigationBar: BottomNavBar(
        selectedTab: _selectedTab,
        onTabChanged: (index) => _handleIndexChanged(index),
        onNavigateToHome: _navigateToHome,
        onNavigateTomenu: _navigateTocat,
        onNavigateTofav: _navigateTofav,
        onNavigateTocart: _navigateTocart,
        onnavigateToaccountinfo: _navigateToaccountinfo,
      ),
    );
  }
}
