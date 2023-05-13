import 'package:flutter/material.dart';

class SlideLeftAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const SlideLeftAnimation({super.key, required this.child, required this.duration});

  @override
  _SlideLeftAnimationState createState() => _SlideLeftAnimationState();
}

class _SlideLeftAnimationState extends State<SlideLeftAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}