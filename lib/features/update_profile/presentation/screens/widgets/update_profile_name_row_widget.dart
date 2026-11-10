import 'package:flutter/material.dart';
import '../../../../../core/widgets/forms/app_text_form_field.dart';

class UpdateProfileNameRowWidget extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final String? Function(String?)? firstNameValidator;
  final String? Function(String?)? lastNameValidator;
  final bool enabled;

  const UpdateProfileNameRowWidget({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    this.firstNameValidator,
    this.lastNameValidator,
    this.enabled = true,
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
            enabled: enabled,
            validator: firstNameValidator,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppTextFormField(
            label: 'Last Name',
            hintText: 'Johnson',
            controller: lastNameController,
            textInputAction: TextInputAction.next,
            enabled: enabled,
            validator: lastNameValidator,
          ),
        ),
      ],
    );
  }
}

