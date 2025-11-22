import 'package:flutter/material.dart';

/// Shimmer effect widget for skeleton loading
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: <double>[
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton for circular avatar
class SkeletonAvatar extends StatelessWidget {
  final double size;

  const SkeletonAvatar({Key? key, this.size = 80}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}

/// Skeleton for text line
class SkeletonText extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonText({Key? key, required this.width, this.height = 16})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
    );
  }
}

/// Skeleton for profile page
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        key: const Key('profile_skeleton'),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar skeleton
            const Center(child: SkeletonAvatar(size: 120)),
            const SizedBox(height: 24),

            // Name skeleton
            const Center(child: SkeletonText(width: 200, height: 24)),
            const SizedBox(height: 8),

            // Email skeleton
            const Center(child: SkeletonText(width: 250, height: 16)),
            const SizedBox(height: 32),

            // Form fields skeleton
            _buildFieldSkeleton(),
            const SizedBox(height: 16),
            _buildFieldSkeleton(),
            const SizedBox(height: 16),
            _buildFieldSkeleton(),
            const SizedBox(height: 16),
            _buildFieldSkeleton(),
            const SizedBox(height: 16),
            _buildFieldSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SkeletonText(width: 100, height: 14),
        SizedBox(height: 8),
        SkeletonText(width: double.infinity, height: 48),
      ],
    );
  }
}
