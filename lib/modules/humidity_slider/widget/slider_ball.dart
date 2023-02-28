import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../utils/icons.dart';
import '../utils/theme.dart';

class SliderBall extends StatelessWidget {
  const SliderBall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: BrandColors.sugarCane,
      ),
      height: kBallSize,
      width: kBallSize,
      alignment: Alignment.center,
      child: const Icon(
        Icons.arrow_upward,
        color: BrandColors.fiord,
        size: 20,
      ),
    );
  }
}
