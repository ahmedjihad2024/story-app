import 'package:flutter/material.dart';
import '../../../../core/widgets/forms/app_text_form_field.dart';

class SignUpNameRowWidget extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final String? Function(String?)? firstNameValidator;
  final String? Function(String?)? lastNameValidator;

  const SignUpNameRowWidget({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    this.firstNameValidator,
    this.lastNameValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AppTextFormField(
            label: 'First Name',
            hintText: 'Alex',
            controller: firstNameController,
            textInputAction: TextInputAction.next,
            validator: firstNameValidator ??
                (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First name is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Min 2 characters';
                  }
                  return null;
                },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppTextFormField(
            label: 'Last Name',
            hintText: 'Johnson',
            controller: lastNameController,
            textInputAction: TextInputAction.next,
            validator: lastNameValidator ??
                (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Last name is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Min 2 characters';
                  }
                  return null;
                },
          ),
        ),
      ],
    );
  }
}
