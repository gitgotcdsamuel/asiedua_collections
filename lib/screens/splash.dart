import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:openfashion/screens/onboarding/onboarding1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _logoRotate;
  late Animation<double> _textFade;
  late Animation<double> _particleOpacity;
  late Animation<Color?> _backgroundGradient;
  
  List<Widget> _particles = [];
  Timer? _particleTimer;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );
    
    _logoRotate = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
    
    _particleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );
    
    _backgroundGradient = ColorTween(
      begin: const Color(0xFFFFF9F3),
      end: Colors.white,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    // Start particle animation
    _startParticleAnimation();
    
    // Start main animation
    _controller.forward();
    
    // Navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      _navigateToOnboarding();
    });
  }
  
  void _startParticleAnimation() {
    _particleTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_particles.length > 20) {
        _particles.removeAt(0);
      }
      
      setState(() {
        _particles.add(_createParticle());
      });
    });
  }
  
  Widget _createParticle() {
    final random = DateTime.now().microsecond;
    final size = 2.0 + (random % 10) / 10.0 * 8.0;
    final opacity = 0.2 + (random % 10) / 10.0 * 0.3;
    final duration = 1500 + (random % 1000);
    final offsetX = (random % 100) / 100.0 * 200 - 100;
    final offsetY = (random % 100) / 100.0 * 200 - 100;
    
    return ParticleWidget(
      size: size,
      opacity: opacity,
      duration: duration,
      offsetX: offsetX,
      offsetY: offsetY,
    );
  }
  
  void _navigateToOnboarding() {
    _particleTimer?.cancel();
    
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const Onboarding1(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOutCubic;
          
          var scaleTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var scaleAnimation = animation.drive(scaleTween);
          
          var fadeTween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
          var fadeAnimation = animation.drive(fadeTween);
          
          return ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 1200),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _particleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _backgroundGradient.value!,
                  _backgroundGradient.value!.withOpacity(0.95),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Background Particles
                ..._particles,
                
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Container with Glow Effect
                      Transform.translate(
                        offset: Offset(0, -10 * (1 - _logoFade.value)),
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Transform.rotate(
                            angle: _logoRotate.value,
                            child: Opacity(
                              opacity: _logoFade.value,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.9),
                                      Colors.white.withOpacity(0.7),
                                    ],
                                    stops: const [0.1, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF6B6B).withOpacity(0.1 * _logoFade.value),
                                      blurRadius: 40,
                                      spreadRadius: 5,
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFF4ECDC4).withOpacity(0.1 * _logoFade.value),
                                      blurRadius: 40,
                                      spreadRadius: -5,
                                      offset: const Offset(10, 10),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Outer Ring
                                    Container(
                                      width: 180,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black.withOpacity(0.05),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    
                                    // Middle Ring
                                    Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black.withOpacity(0.05),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    
                                    // Logo
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: SvgPicture.asset(
                                        'assets/asiedua.svg',
                                        width: 120,
                                      ),
                                    ),
                                    
                                    // Rotating Ring
                                    Transform.rotate(
                                      angle: _controller.value * 2 * 3.14159,
                                      child: Container(
                                        width: 210,
                                        height: 210,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.black.withOpacity(0.1),
                                            width: 2,
                                            strokeAlign: BorderSide.strokeAlignOutside,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Animated Brand Text
                      Opacity(
                        opacity: _textFade.value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - _textFade.value)),
                          child: Column(
                            children: [
                              Text(
                                'ASIEDUA',
                                style: GoogleFonts.raleway(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  letterSpacing: 3,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'COLLECTION',
                                style: GoogleFonts.raleway(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(137, 69, 69, 69),
                                  letterSpacing: 8,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: 100,
                                height: 2,
                                color: Colors.black.withOpacity(0.1),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: _controller.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF6B6B),
                                          Color(0xFF4ECDC4),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Loading Indicator with Icons
                      Opacity(
                        opacity: _textFade.value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: AnimatedIconWidget(
                                index: index,
                                controller: _controller,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Bottom Tagline
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: _textFade.value,
                    child: Column(
                      children: [
                        Text(
                          'Premium Fashion & Lifestyle',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Crafting timeless elegance since 2024',
                          style: GoogleFonts.raleway(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
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
        },
      ),
    );
  }
}

class ParticleWidget extends StatefulWidget {
  final double size;
  final double opacity;
  final int duration;
  final double offsetX;
  final double offsetY;
  
  const ParticleWidget({
    super.key,
    required this.size,
    required this.opacity,
    required this.duration,
    required this.offsetX,
    required this.offsetY,
  });

  @override
  State<ParticleWidget> createState() => _ParticleWidgetState();
}

class _ParticleWidgetState extends State<ParticleWidget> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _positionAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: widget.opacity,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _positionAnimation = Tween<Offset>(
      begin: Offset(widget.offsetX, widget.offsetY),
      end: Offset(widget.offsetX * 1.5, widget.offsetY * 1.5),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    _controller.forward().whenComplete(() {
      _controller.reverse();
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width / 2 + _positionAnimation.value.dx,
          top: MediaQuery.of(context).size.height / 2 + _positionAnimation.value.dy,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedIconWidget extends StatefulWidget {
  final int index;
  final AnimationController controller;
  
  const AnimatedIconWidget({
    super.key,
    required this.index,
    required this.controller,
  });

  @override
  State<AnimatedIconWidget> createState() => _AnimatedIconWidgetState();
}

class _AnimatedIconWidgetState extends State<AnimatedIconWidget> {
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          0.7 + (widget.index * 0.1),
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + 0.2 * _animation.value,
          child: Opacity(
            opacity: 0.5 + 0.5 * _animation.value,
            child: Icon(
              [Iconsax.grid_1, Iconsax.star, Iconsax.heart][widget.index],
              size: 20,
              color: const Color(0xFF4ECDC4).withOpacity(0.8),
            ),
          ),
        );
      },
    );
  }
}