import 'package:flutter/material.dart';

class AngularLoading extends StatefulWidget {
  const AngularLoading({super.key});

  @override
  State<AngularLoading> createState() => _AngularLoadingState();
}

class _AngularLoadingState extends State<AngularLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        'assets/images/angular-loading.png',
        // width: 80,
        // height: 80,
      ),
    );
  }
}
