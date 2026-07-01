import 'dart:math' as math;
import 'package:flutter/material.dart';

class PremiumMindLoader extends StatefulWidget {
  final String message;

  const PremiumMindLoader({
    super.key,
    this.message = "Preparing your mindful experience...",
  });

  @override
  State<PremiumMindLoader> createState() => _PremiumMindLoaderState();
}

class _PremiumMindLoaderState extends State<PremiumMindLoader>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _orbitController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _orbitAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.92,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _orbitAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_orbitController);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  Widget _glowOrb({
    required double angle,
    required double radius,
    required double size,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _orbitAnimation,
      builder: (_, __) {
        final currentAngle = angle + _orbitAnimation.value;
        return Transform.translate(
          offset: Offset(
            radius * math.cos(currentAngle),
            radius * math.sin(currentAngle),
          ),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.45),
                  blurRadius: 18,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationController,
          _pulseAnimation,
          _orbitAnimation,
        ]),
        builder: (_, __) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: _pulseAnimation.value,
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: _rotationController.value * 2 * math.pi,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                const Color(0xFF00E5C3).withOpacity(0.0),
                                const Color(0xFF00E5C3),
                                const Color(0xFF8A5CFF),
                                const Color(0xFF00E5C3).withOpacity(0.0),
                              ],
                              stops: const [0.0, 0.35, 0.75, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF00E5C3,
                                ).withOpacity(0.25),
                                blurRadius: 25,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            colors: [
                              Color(0xFF1F2937),
                              Color(0xFF111827),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.06),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.35),
                              blurRadius: 25,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.psychology_rounded,
                            color: Color(0xFF00E5C3),
                            size: 38,
                          ),
                        ),
                      ),

                      _glowOrb(
                        angle: 0,
                        radius: 68,
                        size: 14,
                        color: const Color(0xFF00E5C3),
                      ),
                      _glowOrb(
                        angle: 2.1,
                        radius: 68,
                        size: 10,
                        color: const Color(0xFF8A5CFF),
                      ),
                      _glowOrb(
                        angle: 4.2,
                        radius: 68,
                        size: 12,
                        color: const Color(0xFF38BDF8),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [
                      Color(0xFF00E5C3),
                      Color(0xFF8A5CFF),
                    ],
                  ).createShader(bounds);
                },
                child: const Text(
                  "MindSaarthi",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.68),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    minHeight: 5,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    valueColor: AlwaysStoppedAnimation(
                      const Color(0xFF00E5C3),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}