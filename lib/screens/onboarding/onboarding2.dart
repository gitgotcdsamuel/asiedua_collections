import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:openfashion/home/home.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

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

            return Stack(
              children: [
                // Main Image with Background
                Positioned(
                  top: screenHeight * 0.05,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1,
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.5,
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
                        'assets/on2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Content Overlay at Bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: screenHeight * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 30,
                          offset: const Offset(0, -10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Title
                        Text(
                          'Exclusive Offers & Discounts',
                          style: GoogleFonts.raleway(
                            fontSize: isSmallScreen ? 28 : 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // Description
                        Text(
                          'Get access to limited-time deals and special promotions available only to our valued customers. Enjoy member-only prices and early access to sales.',
                          style: GoogleFonts.raleway(
                            fontSize: isSmallScreen ? 15 : 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // Benefits Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildFeature(
                              Iconsax.discount_circle,
                              'Exclusive\nDeals',
                              screenWidth,
                            ),
                            _buildFeature(
                              Iconsax.crown,
                              'VIP\nAccess',
                              screenWidth,
                            ),
                            _buildFeature(
                              Iconsax.gift,
                              'Free\nGifts',
                              screenWidth,
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.05),

                        // Progress Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDot(false, screenWidth),
                            SizedBox(width: screenWidth * 0.02),
                            _buildDot(true, screenWidth),
                            SizedBox(width: screenWidth * 0.02),
                            _buildDot(false, screenWidth),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // Get Started Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.022,
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
                                  'Get Started',
                                  style: GoogleFonts.raleway(
                                    fontSize: isSmallScreen ? 16 : 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                const Icon(Iconsax.arrow_right_3),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Back Button
                Positioned(
                  top: screenHeight * 0.02,
                  left: screenWidth * 0.05,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Iconsax.arrow_left_2,
                      size: screenWidth * 0.07,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text, double screenWidth) {
    return Column(
      children: [
        Container(
          width: screenWidth * 0.16,
          height: screenWidth * 0.16,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF0F5), Color(0xFFF0F8FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(screenWidth * 0.08),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: screenWidth * 0.07,
            color: const Color(0xFFFF6B6B),
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Text(
          text,
          style: GoogleFonts.raleway(
            fontSize: screenWidth * 0.034,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDot(bool isActive, double screenWidth) {
    return Container(
      width: isActive ? screenWidth * 0.08 : screenWidth * 0.025,
      height: screenWidth * 0.025,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(screenWidth * 0.0125),
      ),
    );
  }
}