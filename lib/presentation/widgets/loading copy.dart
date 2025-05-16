import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/styles/text.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _animation,
            child: Center(
              child: SizedBox(
                width: 48,
                height: 48,
                child: SvgPicture.asset('assets/icons/loadingg.svg'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading...',
            style: TextStyles.heading3(
              color: Colors.white,
              weight: FontWeightOption.regular,
            ),
          ),
        ],
      ),
    );
  }
}
