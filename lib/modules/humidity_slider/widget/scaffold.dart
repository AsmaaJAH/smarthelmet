import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../nav-bar/Humidity.dart';
import '../utils/icons.dart';
import '../utils/theme.dart';

class HumiditySliderScaffold extends StatelessWidget {
  const HumiditySliderScaffold({
    Key? key,
    required this.body,
    required this.activeIndex,
  }) : super(key: key);

  final Widget body;
  final int activeIndex;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarBrightness: Brightness.dark),
    );
    return Theme(
      data: humiditySliderTheme,
      child: Scaffold(
        backgroundColor: humiditySliderTheme.backgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              body,
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, top: 3),
                  child: IconButton(
                    iconSize: 44,
                    icon: const Icon(
                      Icons.more_horiz,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton(
                        context,
                        FunIcons.chart,
                        const _MockPage(
                          iconData: FunIcons.chart,
                          activeIndex: 0,
                        ),
                        isActive: activeIndex == 0,
                      ),
                      _buildButton(
                        context,
                        FunIcons.drop,
                        HumidityScreen(),
                        isActive: activeIndex == 1,
                      ),
                      _buildButton(
                        context,
                        FunIcons.home,
                        const _MockPage(
                          iconData: FunIcons.home,
                          activeIndex: 2,
                        ),
                        isActive: activeIndex == 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    IconData iconData,
    Widget page, {
    bool isActive = false,
  }) {
    return IconButton(
      icon: Icon(
        iconData,
        color: isActive ? BrandColors.sugarCane : BrandColors.fiord,
      ),
      onPressed: () {},
    );
  }
}

class _MockPage extends StatelessWidget {
  const _MockPage({
    Key? key,
    required this.iconData,
    required this.activeIndex,
  }) : super(key: key);

  final IconData iconData;
  final int activeIndex;
  @override
  Widget build(BuildContext context) {
    return HumiditySliderScaffold(
      activeIndex: activeIndex,
      body: Container(
        alignment: Alignment.center,
        child: Icon(
          iconData,
          color: BrandColors.sugarCane,
          size: 100,
        ),
      ),
    );
  }
}
