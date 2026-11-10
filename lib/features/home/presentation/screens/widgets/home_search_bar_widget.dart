import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';

class HomeSearchBarWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String hintText;

  const HomeSearchBarWidget({
    super.key,
    this.onTap,
    this.hintText = 'Search phones, laptops, more...',
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Search products',
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: ColorM.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorM.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/search.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.scaleDown,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      hintText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeightM.regular,
                        color: ColorM.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
