import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarthelmet/modules/home-page/HomePage.dart';
import 'package:smarthelmet/shared/functions/shared_function.dart';
import '../screen/humidity_screen.dart';

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
                    onPressed: () {

                       // navigateTo(context,HomePageScreen()); 
                    }
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
                        Icons.bar_chart,
                        const _MockPage(
                          iconData: Icons.bar_chart,
                          activeIndex: 0,
                        ),
                        isActive: activeIndex == 0,
                      ),
                      _buildButton(
                        context,
                        Icons.emergency,
                        HumidityScr(),
                        isActive: activeIndex == 1,
                      ),
                      _buildButton(
                        context,
                        Icons.home,
                        const _MockPage(
                          iconData: Icons.home,
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
