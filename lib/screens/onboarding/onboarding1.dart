import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:openfashion/screens/onboarding/onboarding2.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final isSmallScreen = screenWidth < 360;
            final isVerySmallScreen = screenHeight < 600;

            return Stack(
              children: [
                // Background Gradient
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFFFAFB),
                          Color(0xFFF8FBFF),
                          Colors.white,
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Decorative Pattern
                Positioned(
                  top: screenHeight * 0.1,
                  right: screenWidth * 0.05,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      Iconsax.grid_1,
                      size: screenWidth * 0.2,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Main Content
                Column(
                  children: [
                    // Skip Button
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Onboarding2(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black54,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenWidth * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Skip',
                            style: GoogleFonts.raleway(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Main Image with Decorative Border
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.08,
                        right: screenWidth * 0.08,
                        top: isVerySmallScreen ? screenHeight * 0.01 : screenHeight * 0.02,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Decorative Background
                          Container(
                            width: screenWidth * (isVerySmallScreen ? 0.85 : 0.8),
                            height: screenHeight * (isVerySmallScreen ? 0.35 : 0.4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F5),
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFFF0F5),
                                  Color(0xFFF0F8FF),
                                ],
                              ),
                            ),
                          ),

                          // Image with Shadow
                          Container(
                            width: screenWidth * (isVerySmallScreen ? 0.8 : 0.75),
                            height: screenHeight * (isVerySmallScreen ? 0.33 : 0.38),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 40,
                                  offset: const Offset(0, 20),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                'assets/on1.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Decorative Corner Icons
                          Positioned(
                            top: screenHeight * 0.02,
                            left: screenWidth * 0.02,
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.03),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Iconsax.star,
                                size: screenWidth * 0.04,
                                color: const Color(0xFFFFD700),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: screenHeight * 0.02,
                            right: screenWidth * 0.02,
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.03),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4ECDC4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Iconsax.heart,
                                size: screenWidth * 0.04,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content Section with SingleChildScrollView to prevent overflow
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.1,
                          right: screenWidth * 0.1,
                          top: screenHeight * 0.02,
                          bottom: screenHeight * 0.02,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Title with Icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Iconsax.category,
                                    color: Colors.white,
                                    size: screenWidth * 0.05,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                Flexible(
                                  child: Text(
                                    'Endless Selection',
                                    style: GoogleFonts.raleway(
                                      fontSize: isSmallScreen ? 22 : 28,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    
                                      height: 1.1,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: isVerySmallScreen ? screenHeight * 0.015 : screenHeight * 0.02),

                            // Subtitle
                            Text(
                              'Browse thousands of premium fashion items',
                              style: GoogleFonts.raleway(
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: isVerySmallScreen ? screenHeight * 0.02 : screenHeight * 0.03),

                            // Description
                            Text(
                              'Asiedua Collections brings you an extensive range of carefully curated fashion pieces. From everyday essentials to statement pieces, find exactly what you need to express your unique style.',
                              style: GoogleFonts.raleway(
                                fontSize: isSmallScreen ? 13 : 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: isVerySmallScreen ? screenHeight * 0.03 : screenHeight * 0.04),

                            // Stats
                            Container(
                              margin: EdgeInsets.only(
                                bottom: isVerySmallScreen ? screenHeight * 0.02 : screenHeight * 0.03,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                                vertical: screenHeight * 0.02,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatItem('2000+', 'Products', screenWidth),
                                  Container(
                                    width: 1,
                                    height: screenHeight * 0.03,
                                    color: Colors.black12,
                                  ),
                                  _buildStatItem('50+', 'Designers', screenWidth),
                                  Container(
                                    width: 1,
                                    height: screenHeight * 0.03,
                                    color: Colors.black12,
                                  ),
                                  _buildStatItem('New', 'Daily', screenWidth),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Section (Fixed)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: isVerySmallScreen ? screenHeight * 0.02 : screenHeight * 0.03,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.black.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Progress Dots
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildProgressDot(true, screenWidth),
                              SizedBox(width: screenWidth * 0.02),
                              _buildProgressDot(false, screenWidth),
                              SizedBox(width: screenWidth * 0.02),
                              _buildProgressDot(false, screenWidth),
                            ],
                          ),

                          SizedBox(height: isVerySmallScreen ? screenHeight * 0.02 : screenHeight * 0.03),

                          // Continue Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Onboarding2(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continue',
                                    style: GoogleFonts.raleway(
                                      fontSize: isSmallScreen ? 15 : 17,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Icon(
                                    Iconsax.arrow_right_3,
                                    size: screenWidth * 0.05,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, double screenWidth) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.raleway(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenWidth * 0.008),
        Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: screenWidth * 0.028,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressDot(bool isActive, double screenWidth) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? screenWidth * 0.07 : screenWidth * 0.022,
      height: screenWidth * 0.022,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(screenWidth * 0.011),
      ),
    );
  }
}