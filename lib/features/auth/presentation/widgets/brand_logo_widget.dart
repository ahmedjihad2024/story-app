import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';

class BrandLogoWidget extends StatelessWidget {
  const BrandLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorM.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/svg/storey_logo.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              ColorM.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'STOREY',
          style: TextStyle(
            fontFamily: FontsM.inter.name,
            fontSize: 20,
            fontWeight: FontWeightM.extraBold,
            letterSpacing: -0.5,
            color: ColorM.textPrimary,
          ),
        ),
      ],
    );
  }
}
