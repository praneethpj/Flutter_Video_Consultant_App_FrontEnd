import 'package:flutter/material.dart';

class PulseAnimation extends StatefulWidget {
  final bool isOnline;

  PulseAnimation({required this.isOnline});

  @override
  _PulseAnimationState createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: widget.isOnline ? 1.0 : 0.4,
          child: Container(
            width: 20.0 * _animation.value,
            height: 20.0 * _animation.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isOnline ? Colors.green : Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
