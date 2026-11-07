import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/color_manager.dart';
import '../../theme/fonts_manager.dart';
import '../../theme/sizes_manager.dart';

class AppTextFormField extends StatefulWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;

  const AppTextFormField({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontFamily: FontsM.inter.name,
              fontSize: 14,
              fontWeight: FontWeightM.semiBold,
              color: ColorM.textSecondary,
              height: 20 / 14,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: TextStyle(
            fontFamily: FontsM.inter.name,
            fontSize: 16,
            fontWeight: FontWeightM.regular,
            color: ColorM.textPrimary,
          ),
          cursorColor: ColorM.primary,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontFamily: FontsM.inter.name,
              fontSize: 16,
              fontWeight: FontWeightM.regular,
              color: ColorM.gray300,
            ),
            filled: true,
            fillColor: ColorM.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: _toggleObscure,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, left: 8),
                      child: SvgPicture.asset(
                        _obscureText
                            ? 'assets/svg/eye.svg'
                            : 'assets/svg/eye_off.svg',
                        width: 20,
                        height: 20,
                        fit: BoxFit.scaleDown,
                        colorFilter: const ColorFilter.mode(
                          ColorM.textSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                : widget.suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeM.inputBorderRadius),
              borderSide: const BorderSide(
                color: ColorM.border,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeM.inputBorderRadius),
              borderSide: const BorderSide(
                color: ColorM.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeM.inputBorderRadius),
              borderSide: const BorderSide(
                color: ColorM.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeM.inputBorderRadius),
              borderSide: const BorderSide(
                color: ColorM.error,
                width: 1.5,
              ),
            ),
            errorStyle: TextStyle(
              fontFamily: FontsM.inter.name,
              fontSize: 12,
              color: ColorM.error,
            ),
          ),
        ),
      ],
    );
  }
}
