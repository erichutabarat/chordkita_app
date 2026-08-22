import 'package:flutter/material.dart';

/// Simple pulsing gray-bar placeholder shown while chord content loads.
/// Swap for the `shimmer` package later if you want a fancier effect -
/// this version has zero extra dependencies.
class ChordSkeleton extends StatefulWidget {
  const ChordSkeleton({super.key});

  @override
  State<ChordSkeleton> createState() => _ChordSkeletonState();
}

class _ChordSkeletonState extends State<ChordSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _bar(double widthFraction) {
    return FractionallySizedBox(
      widthFactor: widthFraction,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 14,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) =>
          Opacity(opacity: _opacity.value, child: child),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bar(0.55),
          _bar(0.75),
          _bar(0.4),
          const SizedBox(height: 16),
          _bar(0.6),
          _bar(0.65),
          _bar(0.5),
        ],
      ),
    );
  }
}
